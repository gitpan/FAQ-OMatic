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

$metaDir = $FAQ::OMatic::Config::metaDir;

# global
my $html = '';

my %taskUntaint = map {$_=>$_}
	( 'writeMaintenanceHint', 'trimUHDB', 'trimSubmitTmps',
	 'buildSearchDB', 'trim', 'cookies', 'errors', 'logSummary',
	 'rebuildAllSummaries', 'verifyCache' );

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

	print $cgi->header("-type"=>"text/html");
	print "<title>FAQ-O-Matic Maintenance</title>\n";
	FAQ::OMatic::flush('STDOUT');	# just in case some other junk sneaks out on the fd

	foreach $i (sort @tasks) {
		$i =~ s/\d+ //;
		if (defined $taskUntaint{$i}) {
			$i = $taskUntaint{$i};
			$html.= "--- $i()\n";
			if (not eval "$i(); return 1;") {
				$html.= "*** Task $i failed\n    Error: $@\n";
			}
		} else {
			$html.="*** Task $i undefined\n";
		}
	}

	# output results
	print "<pre>\n".$html."\n</pre>\n";

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
		'40 verifyCache',
		'50 cookies',
		'60 logSummary',
		'80 trimUHDB',		# turns on a flag so trim() will trim uhdbs
		'81 trimSubmitTmps',# turns on a flag so trim() will trim submitTmps
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
%trimset = ();

############################################################################
########  Task definitions  ################################################
############################################################################

sub writeMaintenanceHint {
	if (open LMHINT, ">$metaDir/lastMaintenance") {
		print LMHINT $^T."  ".scalar localtime($^T)."\n";
		close LMHINT;
	}
}

sub trimUHDB {
	$trimset{'uhdb'} = 1;
}

sub trimSubmitTmps {
	$trimset{'submitTmp'} = 1;
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
	while (defined($file = readdir(NEWLOGDIR))) {
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
	$sin = sockaddr_in($port, inet_aton($host));
	if (not connect(HTTPSOCK, $sin)) {
		die "bang, $!, $@!\n"
	}
	print HTTPSOCK "GET $url HTTP/1.0\n\n";
	FAQ::OMatic::flush('HTTPSOCK');

	my @reply = <HTTPSOCK>;
	close HTTPSOCK;

	if ($verbose) {
		print join('', @reply);
	}
}

sub verifyCache {
	return if ((not defined $FAQ::OMatic::Config::cacheDir)
				or ($FAQ::OMatic::Config::cacheDir eq ''));
	
	my $itemName;
	my $configFileTime = mtime("$FAQ::OMatic::Config::metaDir/config");

	foreach $itemName (FAQ::OMatic::getAllItemNames()) {
		my $itemFileTime = mtime("$FAQ::OMatic::Config::itemDir/$itemName");
		my $cacheFileTime =
						mtime("$FAQ::OMatic::Config::cacheDir/$itemName.html");
		if ($cacheFileTime < $itemFileTime
			or $cacheFileTime < $configFileTime) {
			$html.="Updating $itemName "
				."(item $itemFileTime, cache $cacheFileTime)\n";
			my $item = new FAQ::OMatic::Item($itemName);
			$item->saveToFile();
		}
	}
}

sub mtime {
	my $filename = shift;
	return (stat($filename))[9] || 0;
}

1;
