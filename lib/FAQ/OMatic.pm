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
## FAQ::OMatic.pm
##
## This module contains routines common to the various faqomatic cgi-bins.
## It also loads FaqConfig.pm, which also defines variables in the
## FAQ::OMatic:: namespace.
##

package FAQ::OMatic;

use FAQ::OMatic::Item;
use FAQ::OMatic::Log;
use FAQ::OMatic::Appearance;
use FAQ::OMatic::Intl;

$VERSION = '2.506';

# This is never used to automatically send mail to (that's authorEmail),
# but when we need to report the author's address, we use this constant:
$authorAddress = 'jonh@cs.dartmouth.edu';

my $seenHeader = 0;

sub pageHeader {
	my $printingNow = shift;
	$seenHeader = 1 if $printingNow;
		# so gripe() only displays header if not sent yet.
	return FAQ::OMatic::Appearance::cPageHeader();
}

sub pageFooter {
	my $page = '';
	if ($userGripes ne '') {
		$page.="<hr><h3>Warnings:</h3>\n".$userGripes."<hr>\n";
	}
	$page.=FAQ::OMatic::Appearance::cPageFooter(@_);
	return $page;
}

# the name of the entire FAQ
sub fomTitle {
	my $topitem = new FAQ::OMatic::Item('1');
	my $title = $topitem->getTitle('undefokay');
	if (not $title) {
		FAQ::OMatic::gripe('note', "Your Faq-O-Matic would have a title if "
			."it had an item 1, which it will when you've run the installer.");
		$title = "Untitled Faq-O-Matic";
	}
	return $title;
}

# a description of the page we're on right now
sub pageDesc {
	my $cmd = commandName();
	my $rt;

	$cmd = 'insertItem'
		if (($cmd eq 'editItem') and ($theParams{'_insert'}));
	$cmd = 'insertPart'
		if (($cmd eq 'editPart') and ($theParams{'_insertpart'}));

	$rt = $FAQ::OMatic::Intl::pageDesc{$cmd};

	if ($rt eq 'FAQ') {
		if ($theParams{'file'} ne 1) {
			my $item = new FAQ::OMatic::Item($theParams{'file'});
			$rt = $item->getTitle();
		} else {
			$rt = "";
		}
	}
	return $rt ? ": $rt" : "";
}

sub keyValue {
	my ($line) = shift;
	my ($key,$value) = ($line =~ m/([A-Za-z0-9\-]*): (.*)$/);
	return ($key,$value);
}

# returns the name of the currently executing command module (was CGI)
sub commandName {
	return ($theParams{'cmd'} || 'faq');
}

# returns the end of the URL (the CGI name)
sub cgiName {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $url = $cgi->url();
	my $cgiName = ($url =~ m#([^/]*)$#)[0];
	return $cgiName;
}

# returns the URL base (including the final /) of this faqomatic
sub urlBase {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $url = $cgi->url();
	$url =~ s#/[^/]*$#/#;
	return $url;
}

sub shortdate {
	my (@date) = localtime(time());
	return sprintf("%02d/%02d/%02d %02d:%02d:%02d",
		$date[5], $date[4], $date[3], $date[2], $date[1], $date[0]);
}

$userGripes = "";

sub gripe {
	# interesting severity values:
	# 'note': appends msg to log
	# 'debug': appends to log, tells user
	# 'error': appends to log, tells user, aborts CGI
	# 'problem': mails msg to $faqAdmin, appends to log, tells user
	# 'abort': mails msg to $faqAdmin, appends to log, tells user, aborts CGI
	# 'panic': mails trouble to $faqAdmin, $faqAuthor, appends to log,
	# 	tells user, and aborts the CGI
	my $severity = shift;
	my $msg = shift;
	my $mailguys = '';
	my $id = $FAQ::OMatic::Auth::trustedID || $theParams{'id'};

	# mail someone
	if ($severity eq 'panic') {
		# mail admin & author
		$mailguys = $FAQ::OMatic::Config::adminEmail." ".$FAQ::OMatic::Config::authorEmail;
	} elsif ($severity eq 'problem' or $severity eq 'abort') {
		# mail admin
		$mailguys = $FAQ::OMatic::Config::adminEmail;
	}

	if ($mailguys ne '') {
		my $message = "The \"".fomTitle()."\" Faq-O-Matic (v. $VERSION)\n";
		$message.="maintained by $FAQ::OMatic::Config::adminEmail\n";
		$message.="had a $severity situation.\n\n";
		$message.="The command was: \"".commandName()."\"\n";
		$message.="The message is: \"$msg\".\n";
		$message.="The process number is: $$\n";
		$message.="The user had given this ID: <$id>\n";
		sendEmail($mailguys,
				"Faq-O-Matic $severity Mail",
				$message);
	}

	# tell user
	if ($severity ne 'note') {
		$userGripes .= "<li>$msg\n";
	}

	# log to file
	open ERRORFILE, ">>$FAQ::OMatic::Config::metaDir/errors";
	print ERRORFILE FAQ::OMatic::Log::numericDate()." $severity ".commandName()
		." $$ <$id> $msg\n";
	close ERRORFILE;

	# abort
	if ($severity eq 'error' or $severity eq 'panic' or $severity eq 'abort') {
		print FAQ::OMatic::pageHeader() if (not $seenHeader);
		print FAQ::OMatic::pageFooter();
		exit 0;
	}
}

sub lockFile {
	my $filename = shift;
	my $lockname = "$FAQ::OMatic::Config::metaDir/$filename.lck";
	if (-e $lockname) {
		sleep 10;
		if (-e $lockname) {
			gripe 'problem',
				"$filename.lck has been there 10 seconds. Failing.";
			return 0;
		}
	}
	open (LOCK, ">$lockname") or
		gripe('abort', "Can't create lockfile $lockname ($!)");
	print LOCK $$;
	close LOCK;
	return $lockname;
}

sub unlockFile {
	my $lockname = shift;
	if (-e $lockname) {
		unlink $lockname;
		return 1;
	}
	gripe 'abort', "$lockname didn't exist -- uh oh, is the locking system broken?";
	return 0;
}

# turns faqomatic:file references into HTML links with pleasant titles.
sub faqomaticReference {
	my $filename = shift;

	my $item = new FAQ::OMatic::Item($filename);
	my $title = $item->getTitle();

	# we should cause the link to inherit the appropriate user parameters!
	return makeAref('faq', {"file"=>$filename})."$title</a>";
}

# turns link-looking things into actual HTML links, but also turns
# <, > and & into entities to prevent them getting interpreted as HTML.
sub insertLinks {
	my $arg = shift;
	$arg = entify($arg);
	$arg =~ s#(http://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
														# absolute URL
	$arg =~ s#http:((?!//)[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
														# relative URL
	$arg =~ s#(ftp://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	$arg =~ s#(gopher://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	$arg =~ s#(telnet://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	$arg =~ s#(mailto:\S+@\S*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	$arg =~ s#faqomatic:(\S*[^\s.,)\?!])#faqomaticReference($1)#sge;

	return $arg;
}

# insert [item title] into faqomatic:XX references
sub addTitleToFaqomaticReference {
	my $filename = shift;

	my $item = new FAQ::OMatic::Item($filename);
	my $title = $item->getTitle();
	$title =~ tr/\[\]/\(\)/;	# eliminate []'s

	return "faqomatic[$title]:$filename";
}

sub addTitleToFaqomaticReferences {
	my $arg = shift;
	$arg =~ s#faqomatic:(\S+)( ?)#addTitleToFaqomaticReference($1).$2#sge;
	return $arg;
}

sub entify {
	my $arg = shift;
	$arg =~ s/&/&amp;/sg;
	$arg =~ s/</&lt;/sg;
	$arg =~ s/>/&gt;/sg;
	$arg =~ s/"/&quot;/sg;
	return $arg;
}

%theParams=();	# the parameters for this invocation (hash ref)

# returns ref to %theParams
sub getParams {
	my $cgi = shift;
	my $dontLog = shift;	# so statgraph requests don't count as hits
	my $i;
	foreach $i ($cgi->param()) {
		$theParams{$i} = $cgi->param($i);
	}

	# Log this access
	FAQ::OMatic::Log::logEvent() if (not $dontLog);

	# set up DIEs to panic and WARNs to note in log.
	# grep log for "Perl" to see if this is happening.
	# We only do this in getParams so that command-line utils
	# don't get confused.
	$SIG{__DIE__} = sub { gripe('panic', "Perl died: ".$_[0]); };
	$SIG{__WARN__} = sub { gripe('note', "Perl warning: ".$_[0]); };

	return \%theParams;
}

sub makeAref {
	my $command = shift;
	my $changedParams = shift;	# hash ref to new params
	my $reftype = shift;		# '' => <a href="...">
								# 'POST' => <form method='POST' ...
								# 'GET' => <form method='GET' ...
								# 'url' => just the GET url
	my $saveTransients = shift;	# true => don't zap the _params, since
								# they're only passing through an interposing
								# script (authentication script, for example)
	my $blastAll = shift;		# true => zap all params, then use
								# changedParams as only new ones.
	my %newParams;
	if ($blastAll) {
		%newParams = ();
	} else {
		%newParams = %theParams;
	}
	my $rt = "";

	# parameters with a _ prefix are defined to be "transient" -- they
	# never make it into a new Aref. That way we can introduce new
	# transient parameters, and they automatically get deleted here.
	if (not $saveTransients) {
		foreach $i (keys %newParams) {
			delete $newParams{$i} if ($i =~ m/^_/);
		}
	}

	# change the requested parameters
	foreach $i (keys %{ $changedParams }) {
		if ($changedParams->{$i} eq '') {
			delete $newParams{$i};
		} else {
			$newParams{$i} = $changedParams->{$i};
		}
	}

	# Old system used a different CGI for each command; hence the
	# separate parameter to this subroutine. New organization (fom2.4+)
	# uses a single dispatcher CGI, so we embed the command as a
	# parameter.
	# Also, we strip the useless .pl suffix from commands now, if
	# some lame client passes it in.
	if ($command =~ m/\.pl$/) {
		gripe('note',
			"Got passed a command like \"$command\" -- fix source.\n");
		$command =~ s/\.pl$//;
	}
	$command = '' if ($command eq 'faq');	# it's implied anyway
	if ($command eq '') {
		delete $newParams{'cmd'};
	} else {
		$newParams{'cmd'}=$command;
	}

	foreach $i (sort keys %newParams) {
		if ($reftype eq 'POST' or $reftype eq 'GET') {
			$rt .= "<input type=hidden name=\"$i\" value=\""
				.$newParams{$i}."\">\n";
		} else {	# regular GET
			$rt.="&".CGI::escape($i)."=".CGI::escape($newParams{$i});
		}
	}
	if (($reftype eq 'POST') or ($reftype eq 'GET')) {
		return "<form action=\"".cgiName()."\" "
				."method=\"$reftype\">\n$rt";
	} elsif ($reftype eq 'url') {
		$rt =~ s/^\&/\?/;	# turn initial & into ?
		return cgiName().$rt;
	} else {
		$rt =~ s/^\&/\?/;	# turn initial & into ?
		return "<a href=\"".cgiName()."$rt\">";
	}
}

# takes an a href and a button label, and makes a button.
sub button {
	my $ahref = shift;
	my $label = shift;
	$label =~ s/ /\&nbsp;/g;
	return "[$ahref$label</a>]";
}

sub getAllItemNames {
	my @allfiles;

	opendir DATADIR, $FAQ::OMatic::Config::itemDir or
		FAQ::OMatic::gripe('problem', "Can't open data directory.");
	while ($_ = readdir DATADIR) {
		next if (m/^\./);
		next if (not -f $FAQ::OMatic::Config::itemDir."/".$_);
		push @allfiles, $_;
	}
	close DATADIR;
	return @allfiles;
}

sub lotsOfApostrophes {
	my $word = shift;
	$word =~ s/(.)/$1'*/go;
	return $word;
}

sub highlightWords {
	my $text = shift;
	my $params = shift;
	
	my @hw;
	if ($params->{'_highlightWords'}) {
		@hw = split(' ', $params->{'_highlightWords'});
	} elsif ($params->{'_searchArray'}) {
		@hw = @{ $params->{'_searchArray'} };
	}
	if (@hw) {
		my $rt = '';
		@hw = map { lotsOfApostrophes($_) } @hw;

		# we'll use this to split the text into not-matches and
		# "delimiters" (matches). Split returns a list item for every
		# pair of parens, so we need to know how many parens we
		# ended up with. Then we can reassemble the text my taking
		# the zeroth item, which didn't match at all, the first item,
		# which matched the first set of parens (the anti-HTML-bashing
		# set), the fourth item which actually matched the word, then
		# continue with the zero+$numparens+1 item, which is the next
		# "split-ee."
		# see Camel ed. 2 p. 221
		my $matchstr = '((^|>)([^<]*[^\w<&])?)(('.join(')|(',@hw).'))';
		my $numparens = scalar(@hw)+4;
		@parts = split(/$matchstr/i, $text);

		# reassemble the split parts according to the description above
		my $i;
		$rt = '';
		for ($i=0; $i<@parts; $i+=$numparens+1) {
			$rt .= $parts[$i+0];
			$rt .= $parts[$i+1] if ($i+1<@parts);
			$rt .= $FAQ::OMatic::Appearance::highlightStart
					.$parts[$i+4]
					.$FAQ::OMatic::Appearance::highlightEnd if ($i+4 < @parts);
		}
		$text = $rt;
	}
	return $text;
}

sub unallocatedItemName {
	my $filename=1;
	if (open HINT, "<$FAQ::OMatic::Config::metaDir/biggestFileHint") {
		$filename = int(<HINT>);
		$filename = 1 if ($filename<1);
		close HINT;
		if (not -e "$FAQ::OMatic::Config::itemDir/$filename") {
			# make sure the hint's valid; else rewind to get earliest empty
			# file
			$filename = 1;
		}
	}
	while (-e "$FAQ::OMatic::Config::itemDir/$filename") {
		$filename++;
	}
	if (open HINT, ">$FAQ::OMatic::Config::metaDir/biggestFileHint") {
		print HINT "$filename\n";
		close HINT;
	}
	return $filename;
}

sub notACGI {
	return if (not defined $ENV{'QUERY_STRING'});

	print "Content-type: text/plain\n\n";
	print "This script (".commandName().") may not be run as a CGI.\n";
	exit 0;
}

sub binpath {
	my $binpath = $0;
	$binpath =~ s#[^/]*$##;
	$binpath = "." if (not $path);
	return $binpath;
}

sub validEmail {
	# returns true if the argument looks like an email address
	my $arg = shift;
	my $cnt = ($arg =~ /^([\w-.+]+\@[\w-.+]+)$/);
	return ($cnt == 1);
}

# sends email; returns true if there was a problem.
sub sendEmail {
	my $to = shift;		# array ref or scalar
	my $subj = shift;
	my $mesg = shift;

	$to = join(" ", @{$to}) if (ref $to);

	if ($FAQ::OMatic::Config::mailCommand =~ m/sendmail/) {
		my $to2 = $to;
		$to2 =~ s/ /, /g;
		if (not open (MAILX, "|$FAQ::OMatic::Config::mailCommand $to 2>&1 "
							.">>$FAQ::OMatic::Config::metaDir/errors")) {
			return 'problem';
		}
		print MAILX "To: $to2\n";
		print MAILX "Subject: $subj\n";
		print MAILX "\n";
		print MAILX $mesg;
		close MAILX;
	} else {
		if (not open (MAILX, "|$FAQ::OMatic::Config::mailCommand -s '$subj' $to")) {
			return 'problem';
		}
		print MAILX $mesg;
		close MAILX;
	}
	return 0;	# no problem
}

'true';
