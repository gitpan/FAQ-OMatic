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

# use vars lets us leave these variables globally-visible (when
# fully qualified) without getting a gripe from 'use strict'.
use vars qw($VERSION $authorAddress %theParams $userGripes);

$VERSION = '2.621';

$authorAddress = 'jonh@cs.dartmouth.edu';
	# This is never used to automatically send mail to (that's authorEmail),
	# but when we need to report the author's address, we use this constant:
%theParams=();		# the parameters for this invocation (hash ref)
$userGripes = '';	# accumulated warnings and error messages

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
		if (FAQ::OMatic::Versions::getVersion('Items')) {
			# (don't gripe if FAQ not installed yet)
			FAQ::OMatic::gripe('note', "Your Faq-O-Matic would have a title "
			 ."if it had an item 1, which it will when you've run the "
			 ."installer.");
		}
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

	my $file = $params->{'file'} || '1';
	my $item = new FAQ::OMatic::Item($params->{'file'});
	my $title = $item->getTitle();
	my $whatAmI = $item->whatAmI();

	my $desc = $FAQ::OMatic::Intl::pageDesc{$cmd};
	if ($desc) {
		$rt = eval($desc);
	} else {
		$rt = "$cmd page";
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
	my $msg = shift || '[gripe with no msg: '.join(':',caller()).']';
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
		$message.="The browser was: <".($ENV{'HTTP_USER_AGENT'}||'undefined')
			.">\n";
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
		print FAQ::OMatic::pageHeader();
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

	my $sw = FAQ::OMatic::Bags::getBagProperty($filename, 'SizeWidth', '');
	$sw = " width=$sw" if ($sw ne '');
	my $sh = FAQ::OMatic::Bags::getBagProperty($filename, 'SizeHeight', '');
	$sh = " height=$sh" if ($sh ne '');

	# should point directly to bags dir
	# TODO: deal with this correctly when handling all the variations on
	# TODO: urls.
	my $bagUrl = makeBagRef($filename, $params);
	return "<img src=\"$bagUrl\"$sw$sh alt=\"($filename)\">";
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

	my $cgi = $FAQ::OMatic::dispatch::cgi;	# TODO ugly global for $cgi
	my $cgiUrl = $cgi->url();
	my ($urlRoot,$urlPath) = $cgiUrl =~ m#^(https?://[^/]+)/(.*)$#;
	if (not defined $urlRoot or not defined $urlPath) {
		if (not $cgi->protocol() =~ m/^http/i) {
			FAQ::OMatic::gripe('error', "The server protocol ("
				.$cgi->protocol()
				.") seems wrong. The author has seen this happen when "
				."broken browsers don't escape a space in the GET URL. "
				."(KDE Konqueror 1.0 is known broken; upgrade to "
				."Konquerer 1.1.) "
				."\n\n<p>\nThe URL (as CGI.pm saw it) was:\n"
				.$ENV{'QUERY_STRING'}
				."\n\n<br>The REQUEST_URI was:\n"
				.$ENV{'REQUEST_URI'}
				."\n\n<br>The SERVER_PROTOCOL was:\n"
				.$ENV{'SERVER_PROTOCOL'}
				."\n\n<br>The browser was:\n"
				.$ENV{'HTTP_USER_AGENT'}."\n"
				."\n\n<p>If you are confused, please ask "
				."$FAQ::OMatic::Config::adminEmail.\n"
			);
			# TODO: This seems to happen when you search on two words,
			# then get an <a href> with a %20 in the _highlightWords
			# field. Turns out KDE's integrated Konquerer browser
			# version 1.0 has this problem; version 1.1 fixes it.
		}
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

# THANKS: to steevATtiredDOTcom for suggesting the ability to mangle
# or disable attributions to reduce the potential for spam address harvesting.
sub mailtoReference {
	my $addr = shift || '';

	$addr =~ s/^mailto://;	# strip off mailto prefix if it's there
	$addr = entify($addr);
	my $how = $FAQ::OMatic::Config::antiSpam || 'off';

	if ($how eq 'cheesy') {
		$addr =~ s#\@#AT#g;
		$addr =~ s#\.#DOT#g;
	} elsif ($how eq 'hide') {
		$addr = 'address-suppressed';
	}
	return "<a href=\"mailto:$addr\">$addr</a>";
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
	    $arg =~ s#(https?://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
														# absolute URL
	    $arg =~ s#https?:((?!//)[^\s"]*[^\s.,)\?!])#"<a href=\"".relativeReference($params,$1)."\">$1</a>"#sge;
														# relative URL
	    $arg =~ s#(ftp://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(gopher://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(telnet://[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(news:[^\s"]*[^\s.,)\?!])#<a href=\"$1\">$1</a>#sg;
	    $arg =~ s#(mailto:\S+@\S*[^\s.,)\?!])#mailtoReference($1)#sge;
	}
	# THANKS: njl25@cam.ac.uk for pointing out the absence of the news: regex

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

# if a param is equal to the default interpretation, we can just
# delete the param. This keeps urls short, and helps us identify
# when the user can be sent over to the cache for faster service.
# TODO: implementations of these defaults are scattered all over
# the code; the various "|| 'default'" clauses should actually
# point to this hash. When that happens, there will also be a
# straightforward mechanism for letting admins change the defaults.
my $defaultParams = {
	'cmd' => 'faq',
	'render' => 'tables'
};

sub getParam {
	my $params = shift;
	my $key = shift;
	return $params->{$key} if defined($params->{$key});
	return $defaultParams->{$key} if defined($defaultParams->{$key});
	return '';
}

sub makeAref {
	my $command = 'faq';
	my $changedParams = {};
	my $refType = '';
	my $saveTransients = '';
	my $blastAll = '';
	my $params = \%theParams;	# default to global params (not preferred, tho)
	my $target = '';			# <a TARGET=""> tag
	my $thisDocIs = '';			# prevent conversion to a cache URL
	my $urlBase = '';			# use included params, but specified urlBase
	my $multipart = '';			# tell browser to reply with a multipart POST

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
			} elsif ($argName =~ m/\-thisDocIs$/i) {
				$thisDocIs = $argVal;
			} elsif ($argName =~ m/\-urlBase$/i) {
				$urlBase = $argVal;
			} elsif ($argName =~ m/\-multipart$/i) {
				$multipart = $argVal;
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
		my $i;
		foreach $i (keys %newParams) {
			delete $newParams{$i} if ($i =~ m/^_/);
		}
	}

	# change the requested parameters
	my $i;
	foreach $i (keys %{ $changedParams }) {
		if (not defined($changedParams->{$i})
			or ($changedParams->{$i} eq '')) {
			delete $newParams{$i};
		} else {
			$newParams{$i} = $changedParams->{$i};
		}
	}
	$newParams{'cmd'} = $command;

	# delete keys where values are equal to defaults
	foreach $i (sort keys %newParams) {
		if (defined($defaultParams->{$i})
			and ($newParams{$i} eq $defaultParams->{$i})) {
			delete $newParams{$i};
		}
	}

	# So why ever bother generating local references when
	# pointing at the CGI? (That's how faqomatic <= 2.605 worked.)
	# Generating absolute ones means
	# the same links work in the cache, or when the cache file
	# is copied for use elsewhere. It also means that pointing
	# at a mirror version of the CGI should be a minor tweak.
	# V2.610: Answer -- people like
	# THANKS: Mark Nagel need server-relative references, because
	# absolute references won't work -- at their site, servers are
	# accessed through a ssh forwarder. (Why not just use https?)

	my $cgiName;
	if ($urlBase ne '') {
		$cgiName = $urlBase;
	} elsif (not $thisDocIs and
		($FAQ::OMatic::Config::useServerRelativeRefs || 0)) {
		# return a server-relative path (starts with /)
		$cgiName = $FAQ::OMatic::dispatch::cgi->script_name();
	} else {
		# return an absolute URL (including protocol and server name)
		$cgiName = $FAQ::OMatic::dispatch::cgi->url();
	}

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
		my $encoding = '';
		if ($refType eq 'POST') {
			if ($multipart) {
				# THANKS: charlie buckheit <buckheit@olg.com> for discovering
				# THANKS: this bug, which only shows up in MSIE.
				$encoding = " ENCTYPE=\"multipart/form-data\""
						  	." ENCODING";
			}
		}
		return "<form action=\"".$cgiName."\" "
				."method=\"$refType\""
				."$encoding>\n$rt";
	}

	$rt =~ s/^\&/\?/;	# turn initial & into ?
	my $url = $cgiName.$rt;

	# see if url can be converted to point to local cache instead of CGI.
	if (not $thisDocIs) {
		# $thisDocIs indicates that this URL is going to appear to the
		# user in the "This document is:" line. So it should be a
		# fully-qualified URL, and it should not point to the cache.
		# Otherwise, see if the reference can be resolved in the cache to
		# save one or more future CGI accesses.
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

	# Sometimes we can do *better* than the cache -- a link
	# can point inside this very document! That's true when
	# the document is the result of a "show this entire category."
	# We require the linkee to be a child of the root of this display
	# (i.e., the linked item must appear on this page :v), and the
	# desired URL must have cmd=='' (i.e., looking at the FAQ, not
	# editing it or otherwise). Any other params I think should be
	# appearance-related, and therefore would be the same as the top
	# item being displayed.
	if ($paramsForMe->{'_recurseRoot'}
		and not defined($paramsForUrl->{'cmd'})) {
		my $linkFile = $paramsForUrl->{'file'} || '1';
		my $linkItem = new FAQ::OMatic::Item($linkFile);
		my $topFile = $paramsForMe->{'_recurseRoot'};

		if ($linkItem->hasParent($paramsForMe->{'_recurseRoot'})) {
			return "#file_".$linkFile;
		}
	}

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
			# pointer into the cache from elsewhere (the CGI) -- use a full URL
			# to get them to our cache.
			return ((hostAndPath())[0])
				.$FAQ::OMatic::Config::cacheURL
				.($paramsForUrl->{'file'}||'1')
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
	} elsif (not defined($FAQ::OMatic::Config::bagsURL)) {
		# put a bad URL in the link to make it obviously fail
		return "x:";
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
	my $image = shift || '';
	my $params = shift || {};	# needed to get correct image refs from cache

	#$label =~ s/ /\&nbsp;/g;
	if ($FAQ::OMatic::Config::showEditIcons
		and ($image ne '')) {
		if (($FAQ::OMatic::Config::showEditIcons||'') eq 'icons-only') {
			$label = '';
		} elsif ($label ne '') {
			$label = "<br>$label";
		}
		return "$ahref"
			.FAQ::OMatic::ImageRef::getImageRef($image, 'border=0', $params)
			."$label</a>\n";
	} else {
		return "[$ahref$label</a>]";
	}
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
		my @pieces = split(/$matchstr/i, $text);

		# reassemble the split pieces according to the description above
		my $i;
		$rt = '';
		for ($i=0; $i<@pieces; $i+=$numparens+1) {
			$rt .= $pieces[$i+0];
			$rt .= $pieces[$i+1] if ($i+1<@pieces);
			$rt .= $FAQ::OMatic::Appearance::highlightStart
					.$pieces[$i+4]
					.$FAQ::OMatic::Appearance::highlightEnd if ($i+4 < @pieces);
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
	$binpath = "." if (not $binpath);
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
		$to = join(" ", map {validEmail($_)||''} @{$to});
	} else {
		$to = validEmail($to)||'';
	}
	return 'problem' if ($to =~ m/^\s*$/);
		# found no valid email addresses

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

	return () if (not opendir(GLOBDIR, $dir));

	my @firstlist = map { m/^(.*)$/; $1 } readdir(GLOBDIR);
		# untaint data -- we can hopefully trust the operating system
		# to provide a valid list of files!
	my @filelist = map { "$dir/$_" } (grep { m/$match/ } @firstlist);
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
# this is the same routine [made strict], but copied into this package. Grr.
sub flush {
	my $old = select(shift);
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

# This is a variation on system().
# If it succeeds, you get an empty list ().
# If it fails (nonzero result code), you get a list containing the
# exit() value, the signal that stopped the process, the $! translation
# of the exit() value, and all of the text the child sent to stdout and
# stderr.
sub mySystem {
	my $cmd = shift;
	my $alwaysWantReply = shift || 0;

	my $count = 0;
	my $pid;

	# flush now, lest data in a buffer get flushed on close() in every stinking
	# child process.
	flush(\*STDOUT);
	flush(\*STDERR);

	pipe READPIPE, WRITEPIPE or die "getting pipes";
	# "bulletproof fork" from camel book, 2ed, page 167
	FORK: {
		$count++;
		if ($pid = fork()) {
			# parent here; child in $pid
			close WRITEPIPE;
			# (drop out of conditional to parent code below to wait for child)
		} elsif (defined $pid) {
			# child here

			# set real uid = effective uid,
			#     real gid = effective gid.
			# this keeps RCS from choking in suid situations.
			# RCS has really weird rules about how it uses real and effective
			# uids which probably make a lot of sense when multiple users
			# are competing for the same RCS store.
			$< = $>;
			$( = $);

			close READPIPE;		# close our fd to the other end of the pipe
			close STDOUT;		# redirect stderr, stdout into the pipe
			open STDOUT, ">&WRITEPIPE";
			close STDERR;
			open STDERR, ">&WRITEPIPE";
			close STDIN;		# don't let child dangle on stdin
			exec $cmd;
			die "mySystem($cmd) failed: $!\n";
			exit -1;			# be DARN sure child exits
		} elsif (($count < 5) && $! =~ /No more process/) {
			# EAGAIN, supposedly recoverable fork error
			sleep(5);
			redo FORK;
		} else {
			die "Can't fork: $! (tried $count times)\n";
		}
	}

	my @stdout = <READPIPE>;	# read child output in its entirety
	close READPIPE;
	my $stdout = join('', @stdout);
	my $wrc = waitpid($pid, 0);		# just in case

	my $statusword = $?;
	my $signal = $statusword & 0x0ff;
	my $exitstatus = ($statusword >> 8) & 0x0ff;
	if ($exitstatus == 0 and not $alwaysWantReply) {
		return ();
	} else {
		return ($exitstatus,$signal,$!,$stdout,\@stdout,"pid=$pid","wrc=$wrc");
	}
}

sub stackTrace {
	my $rt = '';
	my $i=0;
	while (my ($pack, $file, $line) = caller($i++)) {
		$rt .= "$pack $file $line\n";
	}
	return $rt;
}

sub mirrorsCantEdit {
	my $cgi = shift;
	my $params = shift;

	if ($FAQ::OMatic::Config::mirrorURL) {
		# whoah -- we're a mirror site, and the user wants to
		# edit! Send them to the original site.
		my $url = makeAref('-command' => commandName(),
			'-urlBase'=>$FAQ::OMatic::Config::mirrorURL,
			'-refType'=>'url');
		print $cgi->redirect($url);
		exit 0;
	}
}

'true';
