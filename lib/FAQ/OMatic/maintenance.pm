##############################################################################
# The Faq-O-Matic is Copyright 1997 by Jon Howell, all rights reserved.      #
#                                                                            #
# This program is free software; you can redistribute it and/or              #
# modify it under the terms of the GNU General Public License                #
# as published by the Free Software Foundation; either version 2             #
# of the License, or (at your option) any later version.                     #
#                                                                            #
# This program is distributed in the hope that it will be useful,            #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with this program; if not, write to the Free Software                #
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.#
#                                                                            #
# Jon Howell can be contacted at:                                            #
# 6211 Sudikoff Lab, Dartmouth College                                       #
# Hanover, NH  03755-3510                                                    #
# jonh@cs.dartmouth.edu                                                      #
#                                                                            #
# An electronic copy of the GPL is available at:                             #
# http://www.gnu.org/copyleft/gpl.html                                       #
#                                                                            #
##############################################################################

use strict;

##
## maintenance.pm
##
## This module should be invoked periodically by cron.
## It can be given an argument to run a specific task, or it will
## automatically determine which tasks to run.
##
## FAQ::OMatic::maintenance::main() (via the dispatch.pm CGI mechanism) will
##	make this script do its thing.
##
## FAQ::OMatic::maintenance::invoke(host, port, url) will request the url from the host.
##	Cron scripts should invoke me that way, which will cause the above
##	invocation (and make maintenance do its thing).

package FAQ::OMatic::maintenance;

use CGI;
use Socket;

use FAQ::OMatic;
use FAQ::OMatic::Log;
use FAQ::OMatic::Auth;
use FAQ::OMatic::buildSearchDB;
use FAQ::OMatic::Versions;
use FAQ::OMatic::ImageRef;
use FAQ::OMatic::Slow;

my $metaDir = $FAQ::OMatic::Config::metaDir;

# global
my $html = '';

my %taskUntaint = map {$_=>$_}
	( 'writeMaintenanceHint', 'trimUHDB', 'trimSubmitTmps',
	 'buildSearchDB', 'trim', 'cookies', 'errors', 'logSummary',
	 'rebuildAllSummaries', 'rebuildCache', 'expireBags', 'bagAllImages',
	 'mirrorClient', 'trimSlowOutput');

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;

	## Demand a secret key from the caller, so that we don't have
	## Joe Q. Random firing up umpteen copies of the mainenance script
	## and slowing things down. With the hints that keep it from doing
	## much very often, this probably doesn't matter, but anyway.
	if ($cgi->param('secret') ne $FAQ::OMatic::Config::maintenanceSecret) {
		print $cgi->header("-type"=>"text/plain");
		print "Bad maintenance key.\n";
		return;
	}

	my %schedules = ('month'=>1,'week'=>1,'day'=>1,'hour'=>1);
	my @tasks = split(',', ($cgi->param('tasks')||''));
	if ((@tasks == 0) or ((@tasks == 1) and $schedules{$tasks[0]})) {
		@tasks = periodicTasks($tasks[0] || '');
	}

	my $slow = '';
	my $tasks = $cgi->param('tasks') || '';
	if ($tasks ne 'mirrorClient'
		and $tasks ne 'rebuildCache') {
		# (don't force out the header for Slow processes, which need
		# to be able to redirect.)
		print $cgi->header("-type"=>"text/html");
		print "<title>FAQ-O-Matic Maintenance</title>\n";
		FAQ::OMatic::flush('STDOUT');
			# just in case some other junk sneaks out on the fd
	} else {
		$slow = '-slow';	# tell task to run interactively
	}

	$html.="<pre>\n";
	foreach my $i (sort @tasks) {
		$i =~ s/\d+ //;
		if (defined $taskUntaint{$i}) {
			$i = $taskUntaint{$i};
			$html.= "--- $i($slow)\n";
			if (not eval "$i($slow); return 1;") {
				$html.= "*** Task $i failed\n    Error: $@\n";
			}
		} else {
			$html.="*** Task $i undefined\n";
		}
	}

	# output results
	print $html."\n</pre>\n";

	# provide a link to the install page, just for kicks
	FAQ::OMatic::getParams($cgi);
	print FAQ::OMatic::button(
			FAQ::OMatic::makeAref('install', {}, ''),
			"Go To Install/Configuration Page");

}

sub periodicTasks {
	my $arg = shift || '';
	my $lastMaintenance;
	if (open LMHINT, "$metaDir/lastMaintenance") {
		<LMHINT> =~ m/^(\d+)/;
		$lastMaintenance = int($1);
		close LMHINT;
	} else {
		$lastMaintenance = 0;
	}

	my @thenTime = localtime($lastMaintenance);
	my @nowTime = localtime($^T);

	my $newYear =	($thenTime[5] != $nowTime[5])?1:0;
	my $newMonth =	(!defined($thenTime[4])
					or !defined($nowTime[4])
					or ($thenTime[4] != $nowTime[4])
					or $newYear
					or ($arg eq 'month'))
						?1:0;

	# a tricky case:
	my $newWeek = 	(($thenTime[6] > $nowTime[6])
						# it's now "earlier" in the week than then
					or ($lastMaintenance<($^T-(86400*7)))
					or ($arg eq 'week')) ? 1 : 0;
						# or it's at least a week later

	my $newDay =	(($thenTime[3] != $nowTime[3]) or $newMonth
					or ($arg eq 'day'))?1:0;
	my $newHour =	(($thenTime[2] != $nowTime[2]) or $newDay
					or ($arg eq 'hour'))?1:0;

	my @tasks = ();

	# The number in front of the task is the sort order
	push @tasks, (
		'10 buildSearchDB'
		) if $newHour;
	push @tasks, (
		'40 mirrorClient',	# if we're a mirror, this will do an update.
		'50 cookies',
		'60 logSummary',
		'80 trimUHDB',		# turns on a flag so trim() will trim uhdbs
		'81 trimSubmitTmps',# turns on a flag so trim() will trim submitTmps
		'82 trimSlowOutput',# turns on a flag so trim() will trim slow-outputs
		'89 trim' 		# traverse metadir (needed for trim() to do anything)
		) if $newDay;
	push @tasks, (
		'55 errors'
		) if $newWeek;
	push @tasks, '98 writeMaintenanceHint';

	$html.= 'Executing schedules:'
		.($newHour	? ' Hourly'	:'')
		.($newDay	? ' Daily'	:'')
		.($newWeek	? ' Weekly'	:'')
		."\n\n";

	my %tasks = map { ($_,1) } @tasks;
	return keys %tasks;
}

# sub runScript {
# 	my $script = shift;
# 	$html.= "    Executing $script...\n";
# 	if (system("$script")) {
# 		$html.= "   ...failed because $!\n";
# 	}
# }

# set of files to trim in trim()
my %trimset = ();

############################################################################
########  Task definitions  ################################################
############################################################################

sub writeMaintenanceHint {
	if (open LMHINT, ">$metaDir/lastMaintenance") {
		print LMHINT $^T."  ".scalar localtime($^T)."\n";
		close LMHINT;
	}
	FAQ::OMatic::Versions::setVersion('MaintenanceInvoked');
}

sub trimUHDB {
	$trimset{'uhdb'} = 1;
}

sub trimSubmitTmps {
	$trimset{'submitTmp'} = 1;
}

sub trimSlowOutput {
	$trimset{'slow'} = 1;
}

sub buildSearchDB {
	if ((not -f "$metaDir/freshSearchDBHint")
		or (-M "$metaDir/freshSearchDBHint" > 1/24)) {
		FAQ::OMatic::buildSearchDB::build();
	} else {
		$html.= "    (not needed)\n";
	}
}

sub rebuildAllSummaries {
	FAQ::OMatic::Log::rebuildAllSummaries();
}

sub trim {
	if (not opendir NEWLOGDIR, $metaDir) {
		$html.= "*** Couldn't scan $metaDir.";
		return;
	}

	$html.= "trimming: ".join(' ', sort keys %trimset)."\n";

	my $daybefore = FAQ::OMatic::Log::adddays(FAQ::OMatic::Log::numericToday(), -2);
	while (defined(my $file = readdir(NEWLOGDIR))) {
		# untaint file -- we should be able to trust the operating system
		# to provide only reasonable filenames from a readdir().
		$file =~ m/^(.*)$/;
		$file = $1;

		# uhdb's (unique host databases, part of the access log)
		if ($trimset{'uhdb'} and ($file =~ m/^[\d-]+.uhdb./)) {
			my @dates = ($file =~ m/^([\d-]+)/);
			my $date = $dates[0];

			# Delete all uhdb files before yesterday to save
			# space.  we save the day-before's log, since
			# we need it if we summarize yesterday's log (which
			# is another task on the maintenance agenda).
			# (uhdb = Unique Host Database files. Since no
			# "new" unique hosts will be joining logs from the
			# past, having the files around doesn't help
			# anymore.)
			# Notice we do these tests based on the name of the
			# file, not the mod date, since it could have been
			# generated today by a regenerateSmrys.
			if ($date lt $daybefore) {
				$html.= "removing $file\n";
				unlink "$metaDir/$file";
			}
		}

		# submitTmp
		if ($trimset{'submitTmp'} and ($file =~ m/^submitTmp\./)) {
			# only trim files older than a day
			if (-M "$metaDir/$file" > 1.0) {
				$html.= "removing $file\n";
				unlink "$metaDir/$file";
			}
		}

		# slow
		if ($trimset{'slow'} and ($file =~ m/^slow-output\./)) {
			# only trim files older than a day
			if (-M "$metaDir/$file" > 1.0) {
				$html.= "removing $file\n";
				unlink "$metaDir/$file";
			}
		}
	}
	close NEWLOGDIR;
}

sub cookies {
	# throw away old cookies
	if (not open COOKIES, "$metaDir/cookies") {
		$html.= "no cookie file.\n";
		return;
	}
	if (not open NEWCOOKIES, ">$metaDir/cookies.new") {
		$html.= "can't create $metaDir/cookies.new.\n";
		return;
	}
	while (<COOKIES>) {
		my ($cookie,$id,$time) = split(' ');
		if ($time+$FAQ::OMatic::Auth::cookieLife+$FAQ::OMatic::Auth::cookieExtra > $^T) {
			print NEWCOOKIES $_;
		}
	}
	close COOKIES;
	close NEWCOOKIES;
	unlink "$metaDir/cookies";
	if (not rename("$metaDir/cookies.new","$metaDir/cookies")) {
		$html.=
			"Couldn't rename $metaDir/cookies.new to $metaDir/cookies\n"
			."because $!\n";
	}
}

sub errors {
	if (not $FAQ::OMatic::Config::maintSendErrors) {
		$html.="    Config says don't mail errors.\n";
		return;
	}

	my $size = (-s "$metaDir/errors") || 0;
	if ($size == 0) {
		$html.="    No ($size) errors to mail.\n";
		return;
	}

	my $msg = "Errors from ".FAQ::OMatic::fomTitle()
		." (v. $FAQ::OMatic::VERSION):\n\n";
	if (not open(ERRORS, "$metaDir/errors")) {
		$html.="   Couldn't read $metaDir/errors because $!; not truncating\n";
	} else {
		$html.="   Sending errors...\n";
		my @errs = <ERRORS>;
		close ERRORS;
		FAQ::OMatic::sendEmail($FAQ::OMatic::Config::adminEmail,
					"Faq-O-Matic Error Log",
					$msg.join('', @errs));

		# truncate errorfile
		open ERRORS, ">$metaDir/errors";
		close ERRORS;
	}
}

sub logSummary {
	my $yesterday = FAQ::OMatic::Log::adddays(FAQ::OMatic::Log::numericToday(), -1);

	FAQ::OMatic::Log::summarizeDay($yesterday);
}

sub invoke {
	my $host = shift;
	my $port = shift;
	my $url = shift;
	my $verbose = shift;

	my $proto = getprotobyname('tcp');
	socket(HTTPSOCK, PF_INET, SOCK_STREAM, $proto);
	my $httpsock = \*HTTPSOCK;	# filehandles are such a nasty legacy in Perl
	my $sin = sockaddr_in($port, inet_aton($host));
	if (not connect(HTTPSOCK, $sin)) {
		die "maintenance::invoke can't connect(): $!, $@!\n"
	}
	print $httpsock "GET $url HTTP/1.0\n\n";
	FAQ::OMatic::flush($httpsock);
		# Thanks to Miro Jurisic <meeroh@MIT.EDU> for this fix.

	my @reply = <$httpsock>;
	close $httpsock;

	if ($verbose) {
		print join('', @reply);
	}
	return @reply if wantarray();
}

# We used to have a verifyCache task that rebuilt cached files if
# they were older than their item file (or the config file).
# The former condition wasn't very useful, since caches are rewritten
# whenever items are. The latter shouldn't really have happened
# automatically, because it can be verrrry slow on a big FAQ.
# And in neither case could you refresh *every* item in the cache.
# The new task simply reads and writes every item in the item/ directory,
# which ensures that its cache and dependencies are up-to-date.
# (note also the 'updateAllDependencies' flag to saveToFile().)
#
sub rebuildCache {
	my $slow = shift || '';

	return if ((not defined $FAQ::OMatic::Config::cacheDir)
				or ($FAQ::OMatic::Config::cacheDir eq ''));
	
	if ($slow) {
		FAQ::OMatic::Slow::split();
		# from now on, our output goes into the slow-output file
		# to be periodically loaded by the browser. We should
		# flush STDOUT pretty often.
	}

	my $itemName;
	foreach $itemName (FAQ::OMatic::getAllItemNames()) {
		$html.="<br>Updating $itemName\n";
		my $item = new FAQ::OMatic::Item($itemName);
		$item->saveToFile('', '', 'noChange', 'updateAllDependencies');

		# flush stdout
		print STDOUT $html;
		FAQ::OMatic::flush('STDOUT');
		$html = '';
	}

	FAQ::OMatic::Versions::setVersion('CacheRebuild');
}

sub expireBags {
	return if ((not defined $FAQ::OMatic::Config::cacheDir)
				or ($FAQ::OMatic::Config::cacheDir eq '')
				or (not defined $FAQ::OMatic::Config::bagsDir)
				or ($FAQ::OMatic::Config::bagsDir eq ''));
	
	my $anyMessages = 0;
	my @bagList = grep { not m/\.desc$/ }
		FAQ::OMatic::getAllItemNames($FAQ::OMatic::Config::bagsDir);
	my $bagName;
	foreach $bagName (@bagList) {
		#$html.="<br>Checking $bagName\n";
		my @dependents = FAQ::OMatic::Item::getDependencies("bags.".$bagName);
		if (scalar(@dependents) == 0) {
			# don't declare system-supplied bags invalid
			# THANKS: to John Goerzen for pointing this out
			my ($prefix) = ($bagName =~ m/^(.*)\.[^\.]+$/);
			next if (FAQ::OMatic::ImageRef::validImage($prefix));

			if (not $anyMessages) {
				$html .= "The following suggestion(s) are based on "
					."dependency files.\n You might run rebuildCache first "
					."if you want to be certain that they are valid.\n\n";
			}
			$anyMessages = 1;
			my $msg = "Consider removing bag $bagName; it is not linked from "
				."any item in the FAQ.";
			$html.="<br>$msg\n";
			# TODO: in a future version, we could actually just unlink
			# TODO: the unreferenced bags. (garbage collection).
			# The comment above about rebuildCache would apply.
			# Dependencies should stay current, but I'd sure hate
			# to accidentally blast your bag.
		}
	}
}

sub bagAllImages {
	return if ((not defined $FAQ::OMatic::Config::bagsDir)
				or ($FAQ::OMatic::Config::bagsDir eq ''));

	require FAQ::OMatic::ImageRef;
	FAQ::OMatic::ImageRef::bagAllImages();

	FAQ::OMatic::Versions::setVersion('SystemBags');
}

sub mirrorClient {
	my $slow = shift || '';
	my $url = $FAQ::OMatic::Config::mirrorURL;

	if ((not defined $url)
		or ($url eq '')) {
		$html.="mirrorClient() exiting silently because this is "
			."not a mirror.\n";
		return;
	}

	if ($slow) {
		FAQ::OMatic::Slow::split();
		# from now on, our output goes into the slow-output file
		# to be periodically loaded by the browser. We should
		# flush STDOUT pretty often.
	}

	my $limit = -1;	# Set to a small number for debugging, so you don't
					# have to wait for the whole mirror to complete.
					# Set to -1 for normal operation.

	require FAQ::OMatic::install;

	# cheesily parse the URL. This seemed better than use'ing the
	# whole URL.pm kit. I had bad luck with it once. Maybe I'm irrational.
	my ($host, $port, $path) =
		$url =~ m#http://([^/:]+)(:\d+)?/(.*)$#;
	if (defined $port) {
		$port =~ s/^://;
	} else {
		$port = 80;
	}
	$path = "/$path?cmd=mirrorServer";

	my @reply = invoke($host, $port, $path);

	# chew HTTP headers until a blank line
	while (not $reply[0] =~ m/^[\r\n]*$/) {
		shift @reply;
	}
	shift @reply;	# chew off that blank line
	@reply = grep { not m/^#/ } @reply;		# chew off comment lines
	@reply = map { chomp $_; $_ } @reply;		# chomp LFs

	# first line of remaining content must be version number
	my $version = shift @reply;
	if ($version ne 'version 1.0') {
		die "This FAQ-O-Matic version $FAQ::OMatic::VERSION only understands "
			."mirrorServer data version 1.0; received $version.";
	}

	#$html = join("\n", @reply);

	my @itemURL = grep { m/^itemURL\s/ } @reply;
	my $itemURL = ($itemURL[0] =~ m/^itemURL\s+(.*)$/)[0];
	if (not defined $itemURL) {
		die "master didn't send itemURL line.";
	}

	my @configs = grep { m/^config\s/ } @reply;
	my $config;
	my $map = FAQ::OMatic::install::readConfig();
	$html .= "configs supplied: ".scalar(@configs)."\n";
	foreach $config (@configs) {
		my ($left,$right) =
			($config =~ m/config (\$\S+) = (.*)$/);
		$map->{$left} = $right;
		$html.="$left => $right\n";
	}
	FAQ::OMatic::install::writeConfig($map);
	# now make sure that config takes effect for all the cache
	# files we're about to write
	FAQ::OMatic::install::rereadConfig();

	my $count = 0;
	my @items = grep { m/^item\s/ } @reply;
	my $line;
	foreach $line (@items) {
		my ($file,$lms) =
			($line =~ m/item\s+(\S+)\s+(\S+)/);
		if (not defined $file || $file eq '') {
			$html .= "<br>Can't parse: $line\n";
			next;
		}
		my $item = new FAQ::OMatic::Item($file);
		my $existingLms = $item->{'LastModifiedSecs'} || -1;
		if ($lms != $existingLms) {
			$html .= "<br>Needs update: item $file ".$item->getTitle()."\n";
			mirrorItem($host, $port, $itemURL."$file", $file, '');
			$count++;	# each net access counts 1, whether or not it takes
		} else {
			# $html .= "<br>Already have: $file ".$item->getTitle()."\n";
			# Benign output supressed so you can see which items you
			# don't have.
		}

		if ($limit>=0 && $count >= $limit) {
			$html .= "<p>stopping because count = limit ($limit)\n";
			return;
		}
		# flush stdout
		print STDOUT $html;
		FAQ::OMatic::flush('STDOUT');
		$html = '';
	}

	my @bagsURL = grep { m/^bagsURL\s/ } @reply;
	my $bagsURL = ($bagsURL[0] =~ m/^bagsURL\s+(.*)$/)[0];
	if (not defined $bagsURL) {
		die "master didn't send bagsURL line.";
	}

	my @bags = grep { m/^bag\s/ } @reply;
	foreach $line (@bags) {
		my ($file,$lms) =
			($line =~ m/bag\s+(\S+)\s+(\S+)/);
		$file = FAQ::OMatic::Bags::untaintBagName($file);
		if ($file eq '') {
			$html .= "<br>Tainted bag name in '$line'\n";
			next;
		}

		my $descFile = $file.".desc";
		my $descItem = new FAQ::OMatic::Item($descFile,
							$FAQ::OMatic::Config::bagsDir);
		my $existingLms = $descItem->{'LastModifiedSecs'} || -1;

		if ($lms != $existingLms) {
			$html .= "<br>Needs update: bag $file ($lms,$existingLms)\n";
			# transfer bag byte-for-byte to my bags dir
			mirrorBag($host, $port, $bagsURL."$file", $file);
			# transfer the .desc file, using same item mirroring code as above
			mirrorItem($host, $port, $bagsURL.$descFile,
				$descFile, $FAQ::OMatic::Config::bagsDir);
			# update the link in any items that point to this bag
			FAQ::OMatic::Bags::updateDependents($file);
			$count += 2;
		} else {
			# $html .= "<br>Already have: $file\n";
		}

		if ($limit>=0 && $count >= $limit) {
			$html .= "<p>stopping because count = limit ($limit)\n";
			return;
		}
		# flush stdout
		print STDOUT $html;
		FAQ::OMatic::flush('STDOUT');
		$html = '';
	}
}

# a close relative of previous function invoke().
sub mirrorItem {
	my $host = shift;
	my $port = shift;
	my $path = shift;
	my $itemFilename = shift;
	my $itemDir = shift;

	my $proto = getprotobyname('tcp');
	my $sin = sockaddr_in($port, inet_aton($host));

	socket(HTTPSOCK, PF_INET, SOCK_STREAM, $proto);
	my $httpsock = \*HTTPSOCK;

	if (not connect($httpsock, $sin)) {
		die "mirrorItem can't connect(): $!, $@!\n"
	}
	my $request = "GET $path HTTP/1.0";
	print $httpsock "$request\n\n";
	FAQ::OMatic::flush($httpsock);
		# Thanks to Miro Jurisic <meeroh@MIT.EDU> for this fix.
	my $httpstatus = <$httpsock>;	# get initial result
	chomp $httpstatus;
	my ($statusNum) = ($httpstatus =~ m/\s(\d+)\s/);
	if ($statusNum != 200) {
		$html .= "<br>Request '$request' for $itemFilename from "
			."$host:$port failed: ($statusNum) $httpstatus\n";
		close($httpsock);
		return;
	}
	while (<$httpsock>) {			# blow past HTTP headers
		last if ($_ =~ m/^[\r\n]*$/);
	}

	my $item = new FAQ::OMatic::Item();
	$item->{'filename'} = $itemFilename;
	$item->loadFromFileHandle($httpsock);
	close($httpsock);

	$item->{'titleChanged'} = 'true';
		# since we just mirrored this guy, the title may very well
		# have changed, so we need to be sure to rewrite dependent items.
	$item->saveToFile($itemFilename, $itemDir, 'noChange', 'updateAllDeps');
		# notice we're passing in a filename we got from that
		#	web server -- an insidious master might try to pass
		#	off bogus item filenames with '..'s in them. But saveToFile()
		#	has a taint-check to prevent that sort of thing.
		# 'noChange' keeps lastModified date intact, so we won't keep
		#	re-mirroring this item.
		# 'updateAllDependencies' is necessary, because otherwise
		#	saveToFile only adds those dependencies that are "new" to
		#	this item -- but we only have the item, not the .dep file,
		#	so we need to always regenerate all deps.
	$html.="<br>I think I mirrored $itemFilename successfully.\n";
}

sub mirrorBag {
	my $host = shift;
	my $port = shift;
	my $path = shift;
	my $bagFilename = shift;	# already untainted by caller

	my $proto = getprotobyname('tcp');
	my $sin = sockaddr_in($port, inet_aton($host));

	socket(HTTPSOCK, PF_INET, SOCK_STREAM, $proto);
	my $httpsock = \*HTTPSOCK;	# filehandles are such a nasty legacy in Perl

	if (not connect($httpsock, $sin)) {
		die "mirrorBag can't connect(): $!, $@!\n"
	}
	my $request = "GET $path HTTP/1.0";
	print $httpsock "$request\n\n";
	FAQ::OMatic::flush($httpsock);
		# Thanks to Miro Jurisic <meeroh@MIT.EDU> for this fix.
	my $httpstatus = <$httpsock>;	# get initial result
	chomp $httpstatus;
	my ($statusNum) = ($httpstatus =~ m/\s(\d+)\s/);
	if ($statusNum != 200) {
		$html .= "<br>Request '$request' for $bagFilename from "
			."$host:$port failed: ($statusNum) $httpstatus\n";
		close($httpsock);
		return;
	}
	while (<$httpsock>) {			# blow past HTTP headers
		last if ($_ =~ m/^[\r\n]*$/);
	}

	# input looks good at this point -- open output bag file
	if (not open(BAGFILE, ">".$FAQ::OMatic::Config::bagsDir.$bagFilename)) {
		$html .= "<br>open of $bagFilename failed: $!\n";
		close $httpsock;
		return;
	}

	my $sizeBytes = 0;
	my $buf;
	while (read($httpsock, $buf, 4096)) {
		print BAGFILE $buf;
		$sizeBytes += length($buf);
		# TODO: maybe have (mirror-site-admin)-configurable length limit here
	}
	close(BAGFILE);
	close($httpsock);

	if (not chmod(0644, $FAQ::OMatic::Config::bagsDir.$bagFilename)) {
		FAQ::OMatic::gripe('problem', "chmod("
			.$FAQ::OMatic::Config::bagsDir.$bagFilename
			." failed: $!");
	}

	if ($sizeBytes == 0) {
		$html .= "<br><b>Uh oh, I read no bytes for $bagFilename.</b>\n";
		return;
	}

	$html.="<br>I think I mirrored $bagFilename successfully.\n";
}

sub mtime {
	my $filename = shift;
	return (stat($filename))[9] || 0;
}

1;
