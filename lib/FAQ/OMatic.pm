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
use FAQ::OMatic::Bags;

$VERSION = '2.606';

# This is never used to automatically send mail to (that's authorEmail),
# but when we need to report the author's address, we use this constant:
$authorAddress = 'jonh@cs.dartmouth.edu';

my $seenHeader = 0;

sub pageHeader {
	my $params = shift || \%theParams;
	my $suppressType = shift;
	return FAQ::OMatic::Appearance::cPageHeader($params, $suppressType);
}

sub pageFooter {
	my $params = shift;			# arg passed to Apperance::cPageFooter
	my $showLinks = shift;		# arg passed to Apperance::cPageFooter
	my $isCached = shift || '';	# don't put gripes in the cached copies

	my $page = '';
	if (not $isCached and $userGripes ne '') {
		$page.="<hr><h3>Warnings:</h3>\n".$userGripes."<hr>\n";
	}
	$page.=FAQ::OMatic::Appearance::cPageFooter($params, $showLinks);
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
	my $params = shift;
	my $cmd = commandName($params);
	my $rt;

	$cmd = 'insertItem'
		if (($cmd eq 'editItem') and ($params->{'_insert'}));
	$cmd = 'insertPart'
		if (($cmd eq 'editPart') and ($params->{'_insertpart'}));

	$rt = $FAQ::OMatic::Intl::pageDesc{$cmd} || "$cmd page";

	if ($rt eq 'FAQ') {
		my $file = $params->{'file'} || '';
		if ($file ne 1) {
			my $item = new FAQ::OMatic::Item($params->{'file'});
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
	my $params = shift || \%theParams;
	return ($params->{'cmd'} || 'faq');
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
	return '';
	# since all makeArefs are now always absolute, we don't want to
	# insert this before redirects (or before $secreturl in submitPass.pm).
	# TODO: hack out all code referring to urlBase.

#	my $cgi = $FAQ::OMatic::dispatch::cgi;
#	my $url = $cgi->url();
#	$url =~ s#/[^/]*$#/#;
#	return $url;
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
	my $severity = shift || 'problem';
	my $msg = shift || '[gripe with no msg]';
	my $mailguys = '';
	my $id = $FAQ::OMatic::Auth::trustedID || $theParams{'id'} || '(noID)';

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
	my $lockname = $filename;
	$lockname =~ s#/#-#gs;
	$lockname =~ m#^(.*)$#;
	$lockname = "$FAQ::OMatic::Config::metaDir/$1.lck";
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
	my $params = shift;
	my $filename = shift;
	my $which = shift;		# '-small' (children) or '-also' (see-also links)

	my $item = new FAQ::OMatic::Item($filename);
	my $title = FAQ::OMatic::ImageRef::getImageRefCA($which,
					'border=0', $item->isCategory(), $params)
				.$item->getTitle();

	return makeAref('-command'=>'faq',
					'-params'=>$params,
					'-changedParams'=>{"file"=>$filename})
			."$title</a>";
}

sub baginlineReference {
	my $params = shift;
	my $filename = shift;

	if (not -f $FAQ::OMatic::Config::bagsDir.$filename) {
		return "[no bag '$filename' on server]";
	}

	my $sw = FAQ::OMatic::Bags::getBagProperty($filename, SizeWidth, '');
	$sw = " width=$sw" if ($sw ne '');
	my $sh = FAQ::OMatic::Bags::getBagProperty($filename, SizeHeight, '');
	$sh = " height=$sh" if ($sh ne '');

	# should point directly to bags dir
	# TODO: deal with this correctly when handling all the variations on
	# TODO: urls.
	my $bagUrl = makeBagRef($filename, $params);
	return "<img src=\"$bagUrl\"$sw$sh>";
}

sub baglinkReference {
	my $params = shift;
	my $filename = shift;

	if (not -f $FAQ::OMatic::Config::bagsDir.$filename) {
		return "[no bag '$filename' on server]";
	}

	my $bagDesc = new FAQ::OMatic::Item($filename.".desc",
		$FAQ::OMatic::Config::bagsDir);
	my $size = $bagDesc->{'SizeBytes'} || '';
	if ($size ne '') {
		$size = " ".describeSize($size);
	}

	# should point directly to bags dir
	# TODO: deal with this correctly when handling all the variations on
	# TODO: urls.
	my $bagUrl = makeBagRef($filename, $params);
	return "<a href=\"$bagUrl\">"
		.FAQ::OMatic::ImageRef::getImageRef('baglink', 'border=0', $params)
		.$filename
		.$size
		."</a>";
}

my @hapCache;
sub hostAndPath {
	return @hapCache if (scalar(@hapCache)==2);

	my $cgiUrl = $FAQ::OMatic::dispatch::cgi->url();
	my ($urlRoot,$urlPath) = $cgiUrl =~ m#^(http://[^/]+)/(.*)$#;
	if (not defined $urlRoot or not defined $urlPath) {
		FAQ::OMatic::gripe('problem', "Can't parse my own URL: $cgiUrl");
	}
	return @hapCache = ($urlRoot, $urlPath);
}

sub relativeReference {
	my $params = shift;
	my $url = shift;

	my ($urlRoot,$urlPath) = hostAndPath();

	if ($url =~ m#^/#) {
		return $urlRoot.$url;
	}

	# Else url is relative to current directory.
	# Deal with ..'s. We would leave this to the browser, but we
	# want to return an URL that works everywhere, not just from the
	# CGI. (So it works from a cached file or a mirrored file.)
	my @urlPath = split('/', $urlPath);
	pop @urlPath;							# pop off last element (CGI name)
	while (($url =~ m#^../(.*)$#) and (scalar(@urlPath)>0)) {
		$url = $1;		# strip ../ component...
		pop @urlPath;	# ...and in exchange, explicitly remove path element
	}
	push @urlPath, $url;
	return $urlRoot."/".join("/",@urlPath);
}

# turns link-looking things into actual HTML links, but also turns
# <, > and & into entities to prevent them getting interpreted as HTML.
sub insertLinks {
	my $params = shift;
	my $arg = shift;
	my $ishtml = shift || 0;
	my $isdirectory = shift || 0;

	my $sa = $isdirectory ? '-small' : '-also';
	
	if (not $ishtml) {
	    $arg = entify($arg);
	    $arg =~ s#(http://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
														# absolute URL
	    $arg =~ s#http:((?!//)[^\s"]*[^\s.,)\?!])#"<a href=\"".relativeReference($params,$1)."\">$1</a>"#sge;
														# relative URL
	    $arg =~ s#(ftp://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(gopher://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(telnet://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(mailto:\S+@\S*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	}

	$arg =~ s#faqomatic:(\S*[^\s.,)\?!])#faqomaticReference($params,$1,$sa)#sge;
	$arg =~ s#baginline:(\S*[^\s.,)\?!])#baginlineReference($params,$1)#sge;
	$arg =~ s#baglink:(\S*[^\s.,)\?!])#baglinkReference($params,$1)#sge;

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
	$arg =~ s#faqomatic:(\S*[^\s.,)\?!])#addTitleToFaqomaticReference($1)#sge;
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
	$SIG{__WARN__} = sub { gripe('note', "Perl warning: ".$_[0]); };
	# so it turns out SIGs are the wrong way to catch die()s. Evals
	# are the right way.
	# $SIG{__DIE__} = sub { gripe('panic', "Perl died: ".$_[0]); };

	return \%theParams;
}

sub makeAref {
	my $command = 'faq';
	my $changedParams = {};
	my $refType = '';
	my $saveTransients = '';
	my $blastAll = '';
	my $params = \%theParams;	# default to global params (not preferred, tho)
	my $target = '';			# <a TARGET=""> tag
	my $noCache = '';			# prevent conversion to a cache URL

	if ($_[0] =~ m/^\-/) {
		# named-parameter style
		while (scalar(@_)>=2) {
			my ($argName, $argVal) = splice(@_,0,2);
			if ($argName =~ m/\-command$/i) {
				$command = $argVal;
			} elsif ($argName =~ m/\-changedParams$/i) {
				$changedParams = $argVal;
			} elsif ($argName =~ m/\-refType$/i) {
				$refType = $argVal;
			} elsif ($argName =~ m/\-saveTransients$/i) {
				$saveTransients = $argVal;
			} elsif ($argName =~ m/\-blastAll$/i) {
				$blastAll = $argVal;
			} elsif ($argName =~ m/\-params$/i) {
				$params = $argVal;
			} elsif ($argName =~ m/\-target$/i) {
				$target = $argVal;
			} elsif ($argName =~ m/\-noCache$/i) {
				$noCache = $argVal;
			}
		}
		if (scalar(@_)) {
			gripe('problem', "Odd number of args to makeAref()");
		}
	} else {
		$command = shift;
		$changedParams = shift || {};
								# hash ref to new params
		$refType = shift || '';
								# '' => <a href="...">
								# 'POST' => <form method='POST' ...
								# 'GET' => <form method='GET' ...
								# 'url' => just the GET url
		$saveTransients = shift || '';
								# true => don't zap the _params, since
								# they're only passing through an interposing
								# script (authentication script, for example)
		$blastAll = shift || '';
								# true => zap all params, then use
								# changedParams as only new ones.
		$params = shift if (defined($_[0]));
								# given params instead of using icky global
								# ones.
	}

	my %newParams;
	if ($blastAll) {
		%newParams = ();			# blast all existing params
	} else {
		%newParams = %{$params};
	}

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
		if (not defined($changedParams->{$i})
			or ($changedParams->{$i} eq '')) {
			delete $newParams{$i};
		} else {
			$newParams{$i} = $changedParams->{$i};
		}
	}

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

	# So why ever bother generating local references when
	# pointing at the CGI? (That's how faqomatic <= 2.605 worked.)
	# Generating absolute ones means
	# the same links work in the cache, or when the cache file
	# is copied for use elsewhere. It also means that pointing
	# at a mirror version of the CGI should be a minor tweak.

	my $cgiName = $FAQ::OMatic::dispatch::cgi->url();

	# collect args in $rt in appropriate form -- hidden fields for
	# forms, or key=value pairs for URLs.
	my $rt = "";
	foreach $i (sort keys %newParams) {
		if ($refType eq 'POST' or $refType eq 'GET') {
			# GET or POST form. stash args in hidden fields.
			$rt .= "<input type=hidden name=\"$i\" value=\""
				.$newParams{$i}."\">\n";
		} else {
			# regular GET, not <form> GET. URL-style key=val&key=val
			$rt.="&".CGI::escape($i)."=".CGI::escape($newParams{$i});
		}
	}
	if (($refType eq 'POST') or ($refType eq 'GET')) {
		return "<form action=\"".$cgiName."\" "
				."method=\"$refType\""
				." ENCTYPE=\"multipart/form-data\""
				." ENCODING>\n$rt";
	}

	$rt =~ s/^\&/\?/;	# turn initial & into ?
	my $url = $cgiName.$rt;

	# see if url can be converted to point to local cache instead of CGI.
	if (not $noCache) {
		# noCache is a special parameter really meant only to be
		# used to generate the "This document is:" line.
		$url = getCacheUrl(\%newParams, $params) || $url;
	}

	if ($refType eq 'url') {
		return $url;
	} else {
		my $targetTag = $target ? " target=\"$target\"" : '';
		return "<a href=\"$url\"$targetTag>";
	}
}

# This function examines $params and if they refer to a page that's
# statically cached, returns a ready-to-eat URL to that page.
# Otherwise it returns ''.
sub getCacheUrl {
	my $paramsForUrl = shift;
	my $paramsForMe = shift;

	if ($FAQ::OMatic::Config::cacheDir
		and (not grep {not m/^file$/} keys(%{$paramsForUrl}))
		) {
		if ($paramsForMe->{'_fromCache'}) {
			# We have a link from the cache to the cache.
			# If we let it be relative, then the cache files
			# can be picked up and taken elsewhere, and they still
			# work, even without a webserver!
			return $paramsForUrl->{'file'}
				.".html";
		} else {
			# pointer into the cache from elsewhere -- use a full URL
			# to get them to our cache.
			return ((hostAndPath())[0])
				.$FAQ::OMatic::Config::cacheURL
				.$paramsForUrl->{'file'}
				.".html";
		}
	}
	return '';
}

sub makeBagRef {
	# Not nearly as tricky as makeAref; this only returns a URL.

	my $bagName = shift;
	my $params = shift;

	if ($params->{'_fromCache'}) {
		# from cache to bags -- can use a local reference; this
		# will allow us to transplant the cache and bags directories
		# from this server to a CD or otherwise portable hierarchy.
		#
		# Notice that we rely here on bags/ and cache/ being in the
		# same parent directory. The presence of separate $bagsURL and
		# $cacheURL configuration items might seem to imply that they're
		# independent paths, but they're not.
		return "../bags/$bagName";
	} else {
		return ((hostAndPath())[0])
			.$FAQ::OMatic::Config::bagsURL
			.$bagName;
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
	my $dir = shift || $FAQ::OMatic::Config::itemDir;

	my @allfiles;

	opendir DATADIR, $dir or
		FAQ::OMatic::gripe('problem', "Can't open data directory $dir.");
	while (defined($_ = readdir DATADIR)) {
		next if (m/^\./);
		next if (not -f $dir."/".$_);
			# not sure what the above test is good for. Avoid subdirectories?
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
	my $filename= shift || 1;

	# If the user is looking for a numeric filename (i.e. supplied no
	# argument), use hint to skip forward to biggest existing file number.
	my $useHint = ($filename =~ m/^\d*$/);
	if ($useHint and
		open HINT, "<$FAQ::OMatic::Config::metaDir/biggestFileHint") {
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
	if ($useHint and
		open HINT, ">$FAQ::OMatic::Config::metaDir/biggestFileHint") {
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
	# returns true (and the untainted address)
	# if the argument looks like an email address
	my $arg = shift;
	my $cnt = ($arg =~ /^([\w-.+]+\@[\w-.+]+)$/);
	return ($cnt == 1) ? $1 : undef;
}

# sends email; returns true if there was a problem.
sub sendEmail {
	my $to = shift;		# array ref or scalar
	my $subj = shift;
	my $mesg = shift;

	# untaint $to address
	if (ref $to) {
		$to = join(" ", map {validEmail($_)} @{$to});
	} else {
		$to = validEmail($to);
	}

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

# this is a taint-safe glob. It's not as "flexible" as the real glob,
# but safer and probably anything flexible would be not as portable, since
# it would depend on csh idiosyncracies.
sub safeGlob {
	my $dir = shift;
	my $match = shift;		# perl regexp
	my @filelist = ();

	return () if (not opendir(GLOBDIR, $dir));

	@filelist = map { "$dir/$_" } (grep { m/$match/ } readdir(GLOBDIR));
	closedir GLOBDIR;

	return @filelist;
}

# for debugging -T
sub isTainted {
	my $x;
	not eval {
		$x = join("",@_), kill 0;
		1;
	};
}

# the crummy "require 'flush.pl';" is not acting reliably for me.
# this is the same routine, but copied into this package. Grr.
sub flush {
	local($old) = select(shift);
    $| = 1;
	print "";
	$| = 0;
	select($old);
}

sub canonDir {
	# canonicalize a directory path:
	# make sure dir ends with one /, and has no // sequences in it
	my $dir = shift;
	$dir =~ s#$#/#;		# add an extra / on end
	$dir =~ s#//#/#g;	# strip any //'s, including the one we possibly
						# put on the end.
	return $dir;
}

sub concatDir {
	my $dir1 = shift;
	my $dir2 = shift;

	return canonDir(canonDir($dir1).canonDir($dir2));
}

sub cardinal {
	my $num = shift;
	my %numsuffix=('0'=>'th', '1'=>'st', '2'=>'nd', '3'=>'rd', '4'=>'th',
				   '5'=>'th', '6'=>'th', '7'=>'th', '8'=>'th', '9'=>'th');
	my $suffix = ($num>=11 and $num<=19) ? 'th' : $numsuffix{substr($num,-1,1)};
	return $num."<sup>".$suffix."</sup>";
}

sub describeSize {
	my $num = shift;

	if ($num > 524288) {
		return sprintf("(%3.1f M)", $num/1048576);	# megabytess
	} elsif ($num > 512) {
		return sprintf("(%3.1f K)", $num/1024);		# kilobytes
	} else {
		return "($num bytes)";
	}
}

'true';
