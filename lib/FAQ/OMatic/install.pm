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

###
### install.pm
###
### This module allows the administrator to install and configure a
### Faq-O-Matic.
###

my $VERSION = undef;
# This is NOT really the version number. See FAQ/OMatic.pm.
# THANKS: "Andreas J. Koenig" <andreas.koenig@anima.de> says that I need
# THANKS: a dummy VERSION string to fix a weird interaction among MakeMaker,
# THANKS: CPAN, and FAQ-O-Matic encountered by
# THANKS: "Larry W. Virden" <lvirden@cas.org>.

package FAQ::OMatic::install;

use Config;
use CGI;
use FAQ::OMatic;
use FAQ::OMatic::Item;
use FAQ::OMatic::Part;
use FAQ::OMatic::Versions;

use vars qw($configInfo);	 # needs to be available to mirrorServer

my $cgi;
my $params;

sub main {
	$cgi = $FAQ::OMatic::dispatch::cgi;
	my $needauth=0;

	if ($FAQ::OMatic::Config::secureInstall) {
		require FAQ::OMatic::Auth;
		# make params available to FAQ::OMatic::Auth::getId
		$params = FAQ::OMatic::getParams($cgi, 'dontlog');
		my ($id,$aq) = FAQ::OMatic::Auth::getID();
		if (($id ne $FAQ::OMatic::Config::adminAuth) or ($aq<5)) {
			$needauth = 1;
		}
	}

	if ($needauth) {
		my $url = FAQ::OMatic::makeAref('authenticate',
			{'_restart' => 'install', '_reason'=>'9' },
			'url', 'saveTransients');
		print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
	} elsif (($cgi->param('step')||'') eq 'makeSecure') {
		makeSecureStep();	# don't print text/html header
	} else {
		print $cgi->header("text/html");
		print $cgi->start_html('-title'=>"Faq-O-Matic Installer",
								'-bgcolor'=>"#ffffff");
	
		doStep($cgi->param('step'));

		print $cgi->end_html();
	}
}

my %knownSteps = map {$_=>$_} qw(
	default			askMeta			configMeta		initConfig
	mainMenu		
	configItem		askConfig
	firstItem		initMetaFiles					setConfig
	maintenance		makeSecure
	colorSampler	askColor		setColor
	copyItems		configVersion
	);

sub doStep {
	my $step = shift || '';

	if ($knownSteps{$step}) {
		# look up subroutine dynamically.
		$step = $knownSteps{$step};		# untaint input
		my $expr = $step."Step()";
		eval($expr);
		if ($@) {
			displayMessage("$step failed: $@", 'default');
		}
	} elsif ($step eq '') {
		doStep('default');
	} else {
		displayMessage("Unknown step: \"$step\".", 'default');
	}
}

sub defaultStep {
	if ((-f "$FAQ::OMatic::dispatch::meta/config")
		and ($FAQ::OMatic::dispatch::meta
			ne ($FAQ::OMatic::Config::metaDir||''))) {
		# CGI stub points at a valid config file, but config hasn't
		# been updated. This happens if admin moves meta dir and
		# fixes the stub.
		displayMessage("Updating config to reflect new meta location "
			."<b>$FAQ::OMatic::dispatch::meta</b>.");
		my $map = readConfig();
		$map->{'$metaDir'} = "'$FAQ::OMatic::dispatch::meta'";
		writeConfig($map);
		rereadConfig();
		doStep('mainMenu');
		exit 0;
	}

	my $meta = $FAQ::OMatic::Config::metaDir || './';
	if (-f "$meta/config") {
		# There's a config file in the directory pointed to by the
		# CGI stub. We're can run the main menu and do everything else
		# from there now.
		doStep('mainMenu');
	} else {
		# Can't see a config file. Offer to create it for admin.
		displayMessage("(Can't find <b>config</b> in '$meta' -- assuming this is a new installation.)");
		doStep('askMeta');
	}
}

sub askMetaStep {
	my $rt = '';
	use Cwd;

	my $stubMeta = cwd();
	if ($FAQ::OMatic::dispatch::meta =~ m#^/#) {
		$stubMeta = "";			# stub meta is an absolute path
	} else {
		$stubMeta =~s#/$##;		# stub meta is relative to cwd
		$stubMeta .= "/";
	}
	$stubMeta.="<b>".$FAQ::OMatic::dispatch::meta."</b>";

	$rt.="<a href=\"".installUrl('configMeta')."\">Click here</a> "
		."to create $stubMeta.<p>\n";

	$rt.="If you want to change the CGI stub to point to another directory,"
		." edit the script and then\n";
	$rt.="<a href=\""
		.installUrl('default')
		."\">click here to use the new location</a>.<p>\n";

	$rt.=<<__EOF__;
FAQ-O-Matic stores files in two main directories.
<p>
The <b>meta/</b> directory path is encoded in your CGI stub ($0).
It contains:
<ul>
<li>the <b>config</b> file that tells FAQ-O-Matic where everything
else lives. That's why the CGI stub needs to know where meta/ is, so
it can figure out the rest of its configuration.
<li>the <b>idfile</b> file that lists user identities. Therefore, meta/
should not be accessible via the web server.
<li>the <b>RCS/</b> subdirectory that tracks revisions to FAQ items.
<li>various hint files that are used as FAQ-O-Matic runs. These can be
regenerated automatically.
</ul>
<p>
The <b>serve/</b> directory contains three subdirectories <b>item/</b>,
<b>cache/</b>, and <b>bags/</b>. These directories are created and
populated by the FAQ-O-Matic CGI, but should be directly accessible via
the web server (without invoking the CGI).
<ul>
<li>serve/item/ contains only FAQ-O-Matic formatted
source files, which encode both user-entered text and the hierarchical
structure of the answers and categories in the FAQ. These files are only
accessed through the web server (rather than the CGI) when another FAQ-O-Matic
is mirroring this one.
<li>serve/cache/ contains a cache of automatically-generated HTML versions of
FAQ answers and categories. When possible, the CGI directs users to the
cache to reduce load on the server. (CGI hits are far more expensive than
regular file loads.)
<li>serve/bags/ contains image files and other ``bags of bits.'' Bit-bags can
be linked to or inlined into FAQ items (in the case of images).
</ul>
__EOF__

	displayMessage($rt);
}

sub configMetaStep {
	my $rt.='';

	my $meta = $FAQ::OMatic::dispatch::meta;
	if (not -d "$meta/.") {
		# try mkdir
		if (not mkdir(stripSlash($meta), 0700)) {
			displayMessage("I couldn't create <b>$meta</b>: $!");
			doStep('askMeta');
			return;
		}
		displayMessage("Created <b>$meta</b>.");
	}
	if (not -w "$meta/.") {
		displayMessage("I don't have write permission to <b>$meta</b>.");
		doStep('askMeta');
		return;
	}
	my $rcsDir = FAQ::OMatic::concatDir($meta, "/RCS/");
	if (not -d $rcsDir) {
		# try mkdir
		if (not mkdir(stripSlash($rcsDir), 0700)) {
			displayMessage("I couldn't create <b>$rcsDir</b>: $!");
			doStep('askMeta');
			return;
		}
		displayMessage("Created <b>$rcsDir</b>.");
	}
	if (not -w "$rcsDir.") {
		displayMessage("I don't have write permission to <b>$rcsDir</b>.");
		doStep('askMeta');
		return;
	}
	# move meta to where other steps expect to find it:
	$FAQ::OMatic::dispatch::meta = $meta;

	doStep('initConfig');
}

sub initConfigStep {
	if (not -f "$FAQ::OMatic::dispatch::meta/config") {
		my $cgiDfl = $cgi->url();
		$cgiDfl = ($cgi->url() =~ m#([^/]*)$#)[0];
		my $metaDfl = $FAQ::OMatic::dispatch::meta;
		$metaDfl .= "/" if (not $metaDfl =~ m#/$#);
		my $itemDfl = $metaDfl."item/";
		my $mailDfl = which("sendmail") || which("mailx");
	
		if (($mailDfl=~m/mailx/) and (`uname -s` =~ m/Linux/i)) {
			# linux mailx doesn't work like we'd hope. Let's go for
			# /bin/mail (which takes -s on linux), and if that fails,
			# leave it blank and hold out hope that the admin will supply
			# a path to sendmail.
			$mailDfl = which("mail");
		}
	
		my $ciDfl = which("ci");
		my $userDfl = 'getpwuid($>)';
	
		my $map = {
			'$adminAuth'		=> "''",
			'$adminEmail'		=> "\$adminAuth",
			'$metaDir'			=> "'$metaDfl'",
			'$authorEmail'		=> "''",
			'$maintSendErrors'	=> "'true'",
			'$mailCommand'		=> "'$mailDfl'",
			'$RCSci'			=> "'$ciDfl'",
			'$RCSargs'			=> "'-l -mnull -t-null'",
			'$RCSuser'			=> "$userDfl",
			'$statUniqueHosts'	=> "'true'",
			'$itemBarColor'		=> "'#606060'",
			'$directoryPartColor'=> "'#80d080'",
			'$regularPartColor'	=> "'#d0d0d0'",
			'$highlightColor'	=> "'#d00050'",
			'$backgroundColor'	=> "'#ffffff'",
			'$textColor'		=> "'#000000'",
			'$linkColor'		=> "'#3030c0'",
			'$vlinkColor'		=> "'#3030c0'",
			'$version'			=> "'$FAQ::OMatic::VERSION'",
			'$serveDir'			=> "''",
			'$serveURL'			=> "''"
		};

		# THANKS: to Jim Adler <jima@sr.hp.com> for this fix that
		# keeps HP-UX's RCS happy. (I'd recommend just installing
		# GNU RCS, but this will be convenient for some.)
		if ($Config{osname} eq 'hpux' and
			($ciDfl eq '/usr/bin/ci' or $ciDfl eq '/bin/ci')) {
			$map->{'$RCSargs'} = "'-l -mnull'";
		}
	
		writeConfig($map);
		displayMessage("Created new config file.");
	}

	doStep('initMetaFiles');
}

sub initMetaFilesStep {
	if (not open(IDFILE, ">>$FAQ::OMatic::dispatch::meta/idfile")) {
		displayMessage("Couldn't create "
			."<b>$FAQ::OMatic::dispatch::meta/idfile</b>: $!", 'askMeta');
		return;
	}
	close IDFILE;
	displayMessage("The idfile exists.");

	doStep('default');
}

sub which {
	my $prog = shift;
	foreach my $path (split(':', $ENV{'PATH'})) {
		if (-x "$path/$prog") {
			return "$path/$prog";
		}
	}
	return '';
}

sub rereadConfig {
	# reread config if available, so that we immediately reflect
	# any changes.
	if (-f "$FAQ::OMatic::dispatch::meta/config") {
		open IN, "$FAQ::OMatic::dispatch::meta/config";
		my @cfg = <IN>;
		close IN;
		my $cfg = join('', @cfg);

		$cfg =~ m/^(.*)$/s;	 # untaint (since data is from a file)
		$cfg = $1;

		{
			no strict 'vars';
				# config file is not written in 'strict' form (vars are
				# not declared/imported).
			local $SIG{'__WARN__'} = sub { die $_[0] };
				# ensure we can see any warnings that come from the eval
			eval($cfg);
			die $@ if ($@);
		}
	}
}

sub mainMenuStep {
	my $rt='';

	rereadConfig();

	my $maintenanceSecret = $FAQ::OMatic::Config::maintenanceSecret || '';
	my $mirror = ($FAQ::OMatic::Config::mirrorURL||'') ne '';

	my $par = "";	# "<p>" for more space between items

	$rt.="<h3>Configuration Main Menu (install module)</h3>\n";
	$rt.="<ol>Perform these tasks in order to prepare your FAQ-O-Matic version $FAQ::OMatic::VERSION:\n";
	$rt.="$par<li><a href=\"".installUrl('askConfig')."\">"
			.checkBoxFor('askConfig')
			."Define configuration parameters.</a>\n";
	if (not $FAQ::OMatic::Config::secureInstall) {
		if ($FAQ::OMatic::Config::mailCommand and $FAQ::OMatic::Config::adminAuth) {
			$rt.="$par<li><a href=\"".installUrl('makeSecure')."\">"
				.checkBoxFor('makeSecure')
				."Set your password and turn on installer security.</a>\n";
		} else {
			$rt.="$par<li>"
				.checkBoxFor('makeSecure')
				."Set your password and turn on installer security "
				."(Need to configure "
				."\$mailCommand and \$adminAuth).\n";
		}
	} else {
		$rt.="$par<li>"
			.checkBoxFor('makeSecure')
			."(Installer security is on.)\n";
	}
	$rt.="$par<li><a href=\"".installUrl('configItem')."\">"
			.checkBoxFor('configItem')
			."Create item, cache, and bags directories in serve dir.</a>\n";

	if (not $mirror) {
		if (defined($FAQ::OMatic::Config::itemDir_Old)) {
			$rt.="$par<li>"
				."<a href=\"".installUrl('copyItems')."\">"
				.checkBoxFor('copyItems')
				."Copy old items</a> from "
				."<tt>$FAQ::OMatic::Config::itemDir_Old</tt> "
				."to <tt>$FAQ::OMatic::Config::itemDir</tt>.\n";
			$rt.="$par<li>"
				."<a href=\"".installUrl('firstItem')."\">"
				.checkBoxFor('firstItem')
				."Install any new items that come with the system.</a>\n"
		} else {
			$rt.="$par<li><a href=\"".installUrl('firstItem')."\">"
				.checkBoxFor('firstItem')
				."Create system default items.</a>\n";
		}

		$rt.="$par<li>"
			.checkBoxFor('rebuildCache')
			."<a href=\"".installUrl('', 'url', 'maintenance')
			."&secret=$maintenanceSecret&tasks=rebuildCache\">"
			."Rebuild the cache and dependency files.</a>\n";
	
		$rt.="$par<li>"
			.checkBoxFor('systemBags')
			."<a href=\"".installUrl('', 'url', 'maintenance')
			."&secret=$maintenanceSecret&tasks=bagAllImages\">"
			."Install system images and icons.</a>\n";
	} else {
		# mirror sites should update now
		$rt.="$par<li>"
			.checkBoxFor('nothing')
			."<a href=\"".installUrl('', 'url', 'maintenance')
			."&secret=$maintenanceSecret&tasks=mirrorClient\">"
			."Update mirror from master now. (this can be slow!)</a>\n";
	}

	$rt.="$par<li><a href=\"".installUrl('maintenance')."\">"
			.checkBoxFor('maintenance')
			."Set up the maintenance cron job</a>\n";
	if ($maintenanceSecret) {
		$rt.="$par<li><a href=\"".installUrl('', 'url', 'maintenance')
				."&secret=$maintenanceSecret\">"
				.checkBoxFor('manualMaintenance')
				."Run maintenance script manually now.</a>\n";
	} else {
			$rt.="$par<li>"
				.checkBoxFor('manualMaintenance')
				."Run maintenance script manually now (Need to set up "
				."the maintenance cron job first).\n";
	}

	$rt.="$par<li><a href=\"".installUrl('configVersion')."\">"
		.checkBoxFor('configVersion')
		."Mark the config file as upgraded to Version "
		."$FAQ::OMatic::VERSION</a>\n";

	$rt.="$par<li><a href=\"".installUrl('colorSampler')."\">"
			.checkBoxFor('customColors')
			."Select custom colors for your Faq-O-Matic</a> (optional).\n";
	$rt.="$par<li><a href=\"".installUrl('', 'url', 'editGroups')."\">"
			.checkBoxFor('customGroups')
			."Define groups</a> (optional).\n";

	# THANKS: to John Goerzen for discovering the CGI.pm/bags bug
	$rt.="$par<li>"
			.checkBoxFor('CGIversion')
			."Upgrade to CGI.pm version 2.49 or newer. "
			.($CGI::VERSION >= 2.49
				? ''
				: "(optional; older versions have bugs that affect bags).\n" )
			."You are using version $CGI::VERSION now.\n";

	$rt.="$par<li>".checkBoxFor('nothing')
			."<a href=\"".installUrl('mainMenu')."\">"
			."Bookmark this link to be able to return to this menu.</a>\n";
	if ($FAQ::OMatic::Config::secureInstall) {
		$rt.="$par<li>".checkBoxFor('nothing')
				."<a href=\"".installUrl('', 'url', 'faq')."\">"
				."Go to the Faq-O-Matic.</a>\n";
	} else {
		$rt.="$par<li>".checkBoxFor('nothing')
			."Go to the Faq-O-Matic (need to turn on installer security)";
	}
	$rt.="</ol>\n";
	$rt.="<ul><u>Other available tasks:</u>\n";
	$rt.="$par<li>"
			.checkBoxFor('nothing')
			."<a href=\"".installUrl('','url','stats')."\">"
			."See access statistics.</a>\n";
	$rt.="$par<li>"
			.checkBoxFor('nothing')
			."<a href=\"".installUrl('','url','selectBag')."\">"
			."Examine all bags.</a>\n";
	$rt.="$par<li>"
		.checkBoxFor('nothing')
		."<a href=\"".installUrl('', 'url', 'maintenance')
		."&secret=$maintenanceSecret&tasks=expireBags\">"
		."Check for unreferenced bags (not linked by any FAQ item).</a>\n";
	# rebuildCache shows up again at the end, because it doesn't show
	# up in the numbered list if this is a mirror site.
	$rt.="$par<li>"
		.checkBoxFor('nothing')
		."<a href=\"".installUrl('', 'url', 'maintenance')
		."&secret=$maintenanceSecret&tasks=rebuildCache\">"
		."Rebuild the cache and dependency files.</a>\n";
	
	$rt.="</ul>\n";

	$rt.="The Faq-O-Matic modules are version $FAQ::OMatic::VERSION.\n";
	#$rt.="The config file is at version $FAQ::OMatic::Config::version.\n";

	displayMessage($rt);
}

sub isDone {
	my $thing = shift;

	return 1 if (($thing eq 'askConfig')
		&& ($FAQ::OMatic::Config::adminAuth)
		&& not undefinedConfigsExist());
	return 1 if (($thing eq 'configItem')
		&& (($FAQ::OMatic::Config::itemDir||'') ne '')
		&& (-d "$FAQ::OMatic::Config::itemDir/.")
		&& (($FAQ::OMatic::Config::cacheDir||'') ne '')
		&& (-d "$FAQ::OMatic::Config::cacheDir/.")
		&& (($FAQ::OMatic::Config::bagsDir||'') ne '')
		&& (-d "$FAQ::OMatic::Config::bagsDir/."));
	return 1 if (($thing eq 'firstItem')
		&& FAQ::OMatic::Versions::getVersion('Items') eq $FAQ::OMatic::VERSION);
		# The above test ensures that the "create initial items" routine
		# has been run once by this version of the faq. That way as new
		# default initial items are supplied, upgraders don't get a checkbox
		# until they're installed.
	return 1
		if (($thing eq 'maintenance')
					&& ($FAQ::OMatic::Config::maintenanceSecret));
	return 1 if (($thing eq 'makeSecure') && ($FAQ::OMatic::Config::secureInstall));
	return 1 if (($thing eq 'manualMaintenance')
					&& (-f "$FAQ::OMatic::Config::metaDir/lastMaintenance")
					&& (FAQ::OMatic::Versions::getVersion('MaintenanceInvoked')
						eq $FAQ::OMatic::VERSION));
	return 1 if (($thing eq 'customColors')
					&& FAQ::OMatic::Versions::getVersion('CustomColors'));
	return 1 if (($thing eq 'rebuildCache')
					&& (FAQ::OMatic::Versions::getVersion('CacheRebuild')
						eq $FAQ::OMatic::VERSION));
	return 1 if (($thing eq 'customGroups')
					&& FAQ::OMatic::Versions::getVersion('CustomGroups'));
	return 1 if (($thing eq 'systemBags')
					&& (FAQ::OMatic::Versions::getVersion('SystemBags')
						eq $FAQ::OMatic::VERSION));
	return 1 if (($thing eq 'CGIversion')
					&& ($CGI::VERSION >= 2.49));
	return 1 if (($thing eq 'copyItems')
					&& (-f "$FAQ::OMatic::Config::itemDir/1"));
	return 1 if (($thing eq 'configVersion')
					&& ($FAQ::OMatic::Config::version
						eq $FAQ::OMatic::VERSION));

	return 0;
}

sub checkBoxFor {
	my $thing = shift;
	my $done = isDone($thing);

	my $rt = "<img border=0 src=\"";
	if ($thing eq 'nothing') {
		$rt.=installUrl('', 'url', 'img', 'space');
	} elsif ($done) {
		$rt.=installUrl('', 'url', 'img', 'checked');
	} else {
		$rt.=installUrl('', 'url', 'img', 'unchecked');
	}
	$rt.="\"> ";
	return $rt;
}

# sub askItemStep {
# 	my $rt = '';
# 
# 	my $dflItem = stripQuotes(readConfig()->{'$itemDir'});
# 
# 	$rt.="Faq-O-Matic needs a writable directory in which to store\n";
# 	$rt.="FAQ item data. Frequently, this is just a subdirectory of\n";
# 	$rt.="the <b>meta/</b> directory. If you have an existing Faq-O-Matic 2\n";
# 	$rt.="installation, you can enter the path to its <b>item/</b> here,\n";
# 	$rt.="and this installation will use those existing items.\n";
# 	$rt.=installUrl('configItem', 'GET');
# 	$rt.="<input type=input size=60 name=item value=\"$dflItem\">\n";
# 	$rt.="<input type=submit name=junk value=\"Define\">\n";
# 	$rt.="</form>\n";
# 	displayMessage($rt);
# }

sub configItemStep {
	my $rt.='';

	# create item, cache, and bags directories.
	createDir('$item',	'/item/');
	createDir('$cache', '/cache/');
	createDir('$bags',	'/bags/');

	doStep('mainMenu');
}

sub createDir {
	my $dirSymbol = shift;
	my $dirSuffix = shift;

	my $dirPath =
		FAQ::OMatic::concatDir($FAQ::OMatic::Config::serveDir, $dirSuffix);
	my $dirUrl =
		FAQ::OMatic::concatDir($FAQ::OMatic::Config::serveURL, $dirSuffix);

	if (not -d $dirPath) {
		if (not mkdir(stripSlash($dirPath), 0700)) {
			dirFail("I couldn't create $dirSymbol"."Dir = <b>$dirPath</b>: $!");
			return;
		}
		displayMessage("Created <b>$dirPath</b>.");
	}
	if (not -w "$dirPath/.") {
		dirFail("I don't have write permission to <b>$dirPath</b>.");
		return;
	}
	if (not chmod 0755, $dirPath) {
		dirFail("I wasn't able to change the permissions on <b>$dirPath</b> "
			."to 755 (readable/searchable by all).");
		return;
	}

	my $map = readConfig();
	if (defined $map->{$dirSymbol."Dir"}
		and ($map->{$dirSymbol."Dir"} ne "''")) {
		# copy the prior definition. Used so we know where the old
		# $itemDir was after we've created the new one.
		$map->{$dirSymbol."Dir_Old"} = $map->{$dirSymbol."Dir"};
	}
	$map->{$dirSymbol."Dir"} = "'".$dirPath."'";
	$map->{$dirSymbol."URL"} = "'".$dirUrl."'";
	writeConfig($map);
	displayMessage("updated config file: $dirSymbol"."Dir = <b>$dirPath</b>"
		."<br>updated config file: $dirSymbol"."URL = <b>$dirUrl</b>");
}

sub dirFail {
	my $message = shift;

	displayMessage($message
		."<p>Redefine configuration parameters to ensure that "
		.'<b>$serveDir</b> is valid.');
	doStep('mainMenu');
}

# lets me succinctly define configInfo entries
sub ci {
	my $key = shift;
	my $mymap = {};
	my $property;
	while ($property = shift(@_)) {
		if (not $property=~m/^-/) {
			FAQ::OMatic::gripe('error',
				"Jon made a mistake here; key=$key, property=$property.")
		}
		my $val = 1;
		if (scalar(@_) and not $_[0]=~m/^-/) {
			$val = shift(@_);	# shift an argument on, if possible
		}
		$mymap->{$property} = $val;
	}
	return ($key,$mymap);
}

$configInfo = {
#	config var => [ 'sortOrder|hide', 'description',
#					['unquoted values'], free-input-okay, is-a-command ]
# -desc=>'...'	-- description of variable
# -choices=>[]	-- list of potential choices
# -free			-- provide a free-form input field
# -hide			-- hide variable from define page
# -sort=key		-- variable sorts in this order on define page
# -cmd			-- variable is a Unix command string
# -mirror		-- variable should be mirrored from server

	ci('sep_a', '-sort'=>'a--sep', '-separator', '-desc'=>
		'Mandatory configurations... these must be correct'),
	ci('adminAuth',	'-sort'=>'a-a1', '-free', '-desc'=>
		'Identity of local FAQ-O-Matic administrator (an email address)'),
	ci('mailCommand',	'-sort'=>'a-m1', '-free', '-cmd', '-desc' =>
		'A command FAQ-O-Matic can use to send mail. It must either be '
		.'sendmail, or it must understand the -s (Subject) switch.'),
	ci('RCSci',		'-sort'=>'a-r1', '-free', '-cmd', '-desc'=>
		'RCS ci command.'),

	ci('sep_c', '-sort'=>'c--sep', '-separator', '-desc'=>
		'Server Directory Configuration'),
	ci('serveDir', '-sort'=>'c-c1', '-free', '-desc'=>
		'Filesystem directory where FAQ-O-Matic will keep item files, '
		.'image and other bit-bag files, and a cache of generated HTML files. '
		.'This directory must be accesible directly via the http server. '
		.'It might be something like /home/faqomatic/public_html/fom-serve/.'),
	ci('serveURL', '-sort'=>'c-c2', '-free', '-desc'=>
		'The URL prefix needed to access files in <b>$serveDir</b>. '
		.'It should be relative to the root of the server '
		.'(omit http://hostname:port, but include a leading /). '
		.'It should also end with a /.'),

	ci('sep_e', '-sort'=>'e--sep', '-separator', '-desc'=>
		'Optional configurations... defaults are pretty good.'),
	ci('mirrorURL',		'-sort'=>'k-m1', '-free', '-choices'=>[ "''"], '-desc'=>
		'If this parameter is set, this FAQ will become a mirror of the '
		.'one at the given URL. The URL should be the base name of '
		.'the CGI script of the master FAQ-O-Matic.'),
	ci('pageHeader',	'-sort'=>'m-p1', '-free', '-mirror', '-desc'=>
		'An HTML fragment inserted at the top of each page. '
		.'You might use this to place a corporate logo.'),
	ci('pageFooter',	'-sort'=>'m-p2', '-free', '-mirror', '-desc'=>
		'An HTML fragment appended to the bottom of each page. '
		.'You might use this to identify the webmaster for this site.'),
	ci('adminEmail','-sort'=>'n-e2', '-free', '-choices'=>[ '$adminAuth' ],
		'-desc'=> 'Where FAQ-O-Matic should send email when it wants to '
		.'alert the administrator (usually same as $adminAuth)'),
	ci('maintSendErrors',	'-sort'=>'n-m2', '-choices'=>[ "'true'", "''" ],
		'-desc'=> 'If true, FAQ-O-Matic will mail the log file to the '
		.'administrator whenever it is truncated.'),
	ci('RCSuser',	'-sort'=>'r-r3', '-free', '-choices'=>['getpwuid($>)'],
		'-desc'=> 'User to use for RCS ci command (default is process UID)'),
	ci('useServerRelativeRefs', '-sort'=>'r-s1',
		'-choices'=>[ "'true'", "''" ], '-desc'=>
		'Links from cache to CGI are relative to the server root, rather than '
		.'absolute URLs including hostname:'),
	ci('showLastModifiedAlways', '-sort'=>'r-s2', '-mirror',
		'-choices'=>[ "'true'", "''" ], '-desc'=>
		'Items always display their last-modified dates.'),
	ci('antiSpam', '-sort'=>'r-s7', '-mirror',
		'-choices'=>[ "'off'", "'cheesy'", "'hide'" ], '-desc'=>
		'mailto: links can be rewritten such as '
		.'jonhATdartmouthDOTedu (cheesy), '
		.'or e-mail addresses suppressed entirely (hide).'),
	ci('cookieLife', '-sort'=>'r-s8', '-free',
		'-choices'=>[ "'3600'" ],
		'-desc'=> 'Number of seconds that authentication cookies remain '
		.'valid. These cookies are stored in URLs, and so can be retrieved '
		.'from a browser history file. Hence they should usually time-out '
		.'fairly quickly.'),

	ci('sep_s', '-sort'=>'s--sep', '-separator', '-desc'=>
			'These options fine-tune the appearance of editing features.'),
	ci('showEditOnFaq', '-sort'=>'s-s3', '-mirror',
		'-choices'=>[ "'true'", "''" ], '-desc'=>
		'The old [Show Edit Commands] button appears in footer of FAQ pages.'),
	ci('hideEasyEdits', '-sort'=>'s-s4', '-mirror',
		'-choices'=>[ "'true'", "''" ], '-desc'=>
		'Hide [Append to This Answer] and [Add New Answer in ...] buttons.'),
#	ci('compactEditCmds', '-sort'=>'s-s5', '-mirror',
#		'-choices'=>[ "'true'", "''" ], '-desc'=>
#		'Expert editing commands appear below rather than beside their parts.'),
	ci('showEditIcons', '-sort'=>'s-s6', '-mirror',
		'-choices'=>[ "'icons-and-label'", "'icons-only'", "''" ], '-desc'=>
		'Editing commands appear with neat-o icons rather than [In Brackets].'),

	ci('sep_z', '-sort'=>'z--sep', '-separator', '-desc'=>
			'Other configurations that you should probably ignore if present.'),


	ci('RCSargs',	'-hide', '-free', '-desc'=>
		'Arguments to make ci quietly log changes (default is probably fine)'),
	ci('authorEmail', '-hide'),
	ci('backgroundColor', '-hide', '-mirror'),
	ci('bagsDir', '-hide'),
	ci('bagsURL', '-hide'),
	ci('cacheDir', '-hide'),
	ci('cacheURL', '-hide'),
	ci('directoryPartColor', '-hide', '-mirror'),
	ci('highlightColor', '-hide', '-mirror'),
	ci('itemBarColor', '-hide', '-mirror'),
	ci('itemDir', '-hide'),
	ci('itemURL', '-hide'),
	ci('linkColor', '-hide', '-mirror'),
	ci('maintenanceSecret', '-hide'),
	ci('metaDir', '-hide'),
	ci('regularPartColor', '-hide', '-mirror'),
	ci('secureInstall', '-hide'),
	ci('statUniqueHosts', '-hide'),
	ci('textColor', '-hide', '-mirror'),
	ci('version', '-hide'),
	ci('vlinkColor', '-hide', '-mirror'),
};
# THANKS: John Goerzen and someone else (sorry I forgot who since I
# THANKS: fixed it!) pointed out that the serveURL (then the cacheURL) needs
# THANKS: a leading slash to avoid picking up a prefix like cgi-bin/.

sub getPotentialConfig {
	# gets the current config, plus empty strings for any expected but
	# nonexistant keys (probably because the modules have been upgraded to
	# a new version)
	my $map = readConfig();

	# Provide defaults for any new options not present in config file
	my $ckey;
	foreach $ckey (sort keys %{$configInfo}) {
		next if defined($map->{'$'.$ckey});
		next if $configInfo->{$ckey}->{'-separator'};
		$map->{'$'.$ckey} = "''";		# provide a null default
	}

	return $map;
}

sub undefinedConfigsExist {
	my $map = readConfig();
	my $ckey;
	foreach $ckey (sort keys %{$configInfo}) {
		if (not defined($map->{'$'.$ckey})
			and not $configInfo->{$ckey}->{'-separator'}) {
			FAQ::OMatic::gripe('debug', "not defined: $ckey");
			return 1;
		}
	}
	return 0;
}

sub askConfigStep {
	my $rt = '';
	my ($left, $right);

	$rt.="<table>\n";
	$rt.=installUrl('setConfig', 'GET');

	# Read current configuration
	my $map = getPotentialConfig();

	my $widgets = {};	# collect widgets here for sorting later
	# want to list any widget that either in the existing $map, or
	# in the list of possible configs ($configInfo); but of course
	# any given widget should appear only once (hence the hash).
	my %keylist = map {$_=>$_}
						((keys %{$map}),
						(map {'$'.$_} keys %{$configInfo}));
	foreach $left (sort keys %keylist) {
		$right = $map->{$left} || '';
		my $aleft = $left;
		$aleft =~ s/^\$//;
		my $isLegacy = not $right=~m/^'/;	# if value isn't a free input
		my $aright = stripQuotes($right);
		my ($sort,$desc,$choices,$free,$cmd,$separator,$mirror);
		my $ch = $configInfo->{$aleft} || {'-free'=>1};
		if (defined $ch) {
			$sort		= $ch->{'-sort'} || 'zzzz';
			$desc		= $ch->{'-desc'} || '(no description)';
			$choices	= $ch->{'-choices'} || [];
			$free		= $ch->{'-free'} || 0;
			$cmd		= $ch->{'-cmd'} || 0;
			$separator	= $ch->{'-separator'} || 0;
			$mirror	= $ch->{'-mirror'} || 0;
			$sort = 'hide' if ($ch->{'-hide'});
			$desc.="<br>This is a command, so only letters, hyphens, and"
				." slashes are allowed." if ($cmd);
		}
		if ($separator) {
			$widgets->{$sort} =
			"<tr><td colspan=2>\n<hr>$desc<hr>\n</td></tr>\n";
		} elsif ($sort eq 'hide') {
			# don't show hidden widgets
		} elsif ((($FAQ::OMatic::Config::mirrorURL||'') ne '') and $mirror) {
			# don't show mirrorable widgets if this is a mirror site --
			# they'll get automatically defined at mirroring time.
		} else {
			my $wd = '';
			$wd.="<tr><td align=right valign=top><b>$left</b></td>"
				."<td align=left valign=top>\n";
			$wd.="$desc<br>\n";
			my $selected = 0;		# don't show $right in free field if
									# it was available by a select button
			if (scalar(@{$choices})) {
				foreach my $choice (@{$choices}) {
					$wd.="<input type=radio name=\"$left-select\" "
						.($right eq $choice ? ' checked' : '')
						." value=\"$choice\"> $choice<br>\n";
					$selected = 1 if ($right eq $choice);
				}
				if ($selected == 0 and $isLegacy) {
					# there is an unquoted value that's no longer
					# a given choice, but can't go in the free field
					# (because otherwise it'll pick up quotes.)
					$wd.="<input type=radio name=\"$left-select\" "
						."checked value=\"$right\"> $right "
						."<i><font color=red>This is no longer a "
						."recommended selection.</font></i><br>\n";
					$selected = 1;
				}
				if ($free) {
					$wd.="<input type=radio name=\"$left-select\" "
						.($selected ? '' : ' checked')
						." value=\"free\">\n";
				}
			} else {
				$wd.="<input type=hidden name=$left-select value=\"free\">\n";
			}
			if ($free) {
				$wd.="<input type=text size=40 name=\"$left-free\" "
					."value=\""
					.($selected ? '' : FAQ::OMatic::entify($aright))
					."\">\n";
			}
			$wd.="</td></tr>\n";
			$widgets->{$sort} .= $wd;
		}
	}

	# insert separator widgets
#	$widgets->{'a--separator'} = "<tr><td colspan=2>"
#			."<hr>Mandatory configurations... these must be correct<hr>"
#			."</td></tr>\n";
#	$widgets->{'c--separator'} = "<tr><td colspan=2>"
#			."<hr>Server Directory Configuration<hr>"
#			."</td></tr>\n";
#	$widgets->{'e--separator'} = "<tr><td colspan=2>"
#			."<hr>Optional configurations... defaults are pretty good.<hr>"
#			."</td></tr>\n";
#	$widgets->{'z--separator'} = "<tr><td colspan=2>"
#			."<hr>Other configurations that you should probably "
#			."ignore if present.<hr>"
#			."</td></tr>\n";
#			# ...because install doesn't have any docs on them, so they're
#			# probably obsolete anyway.

	# now display the widgets in sorted order
	$rt.= join('', map {$widgets->{$_}} sort(keys %{$widgets}));
	$rt.="<tr><td></td><td>"
		."<input type=submit name=junk value=\"Define\"></td></tr>\n";
	$rt.="</form>\n";
	$rt.="</table>\n";

	displayMessage($rt);
}

sub setConfigStep {
	my $warnings = '';
	my $notices = '';	#nonproblems
	my ($left, $right);
	my $map = getPotentialConfig();
	foreach $left (sort keys %{$map}) {
		$right = $map->{$left};
		my $selected = $cgi->param($left."-select") || '';
		if ($selected eq 'free') {
			$map->{$left} = "'".$cgi->param($left."-free")."'";
		} elsif ($selected ne '') {
			$map->{$left} = $selected;
		}
		$map->{$left} =~ s/\n//gs;	# don't let weirdo newlines through
		my $aleft = $left;
		$aleft =~ s/^\$//;
		if ($configInfo->{$aleft}->{'-cmd'}) {	# it represents a command...
			$map->{$left} =~ s#[^\w/'-]##gs;	# be very restrictive
		}
		my ($warn,$howbad) = checkConfig($left, \$map->{$left});
		if ($howbad eq 'ok') {
			$notices .= "<li>$warn";
		} elsif ($warn) {
			$warnings .= "<li>$warn";
		}
	}
	writeConfig($map);
	if ($notices) {
		$notices = "<ul>$notices</ul>\n";
	}
	if ($warnings) {
		$warnings = "<p><b>Warnings: <ul>$warnings</ul>"
				."You should "
				."<a href=\"".installUrl('askConfig')."\">go back</a>"
				." and fix these configurations.</b>";
	}
	displayMessage("Rewrote configuration file.\n$notices\n$warnings");
	doStep('mainMenu');
}

sub checkConfig {
	my $left = shift;
	my $rightref = shift;
	my $right = ${$rightref};
	my $aright = stripQuotes($right);
	if ($left eq '$adminAuth') {
		if (not FAQ::OMatic::validEmail($aright)) {
			return ("$left ($right) doesn't look like an email address.",
				'fix');
		}
	}
	if ($left eq '$adminEmail' and $right ne '$adminAuth') {
		if (not FAQ::OMatic::validEmail($aright)) {
			return ("$left ($right) doesn't look like an email address.",
				'fix');
		}
	}
	if ($left eq '$mailCommand') {
		if (not -x $aright) {
			return ("$left ($right) isn't executable.", 'fix');
		}
	}
	if ($left eq '$RCSci') {
		if (not -x $aright) {
			return ("$left ($right) isn't executable.", 'fix');
		}
	}
	if ($left eq '$serveDir') {
		if ($aright eq '') {
			return ("$left undefined. You must define a directory readable "
				."by the web server from which to serve data. If you are "
				."upgrading, I recommend creating a new directory in the "
				."appropriate place in your filesystem, and copying in "
				."your old items later. The installer checklist will tell you "
				."when to do the copy.",
				'fix');
		}
		$aright = FAQ::OMatic::canonDir($aright);
		if (not -d $aright) {
			my $dirname = stripSlash($aright);
			if (scalar($dirname =~ m#^([/\w\.\-_]+)$#)==0) {
				FAQ::OMatic::gripe('error', "$dirname has funny characters");
			}
			$dirname = $1;
			if (not mkdir($dirname, 0755)) {
				return ("$left ($right) can't be created.", 'fix');
			} else {
				chmod(0755,$dirname);
				return ("$left: Created directory $right.", 'ok');
			}
		}
	}
	if ($left eq '$cookieLife') {
		if ($aright < 1) {
			$$rightref = "'3600'";
			return ("$left was nonpositive; I set it to '3600' (one hour).",
				'ok');
			# simply disallow unreasonable numbers. I can't imagine a
			# scenario where someone would want a 0 cookieLife (uttering
			# those words, of course, will cause such a scenario to
			# spring into existence), and this will save a lot of grief
			# for most people upgrading.
		}
	}
	return ('','');
}

sub firstItemStep {
	if (not -f "$FAQ::OMatic::Config::itemDir/1") {
		my $item = new FAQ::OMatic::Item();
		$item->setProperty('Title', 'Untitled Faq-O-Matic');
		$item->setProperty('Parent', '1');
		$item->setProperty('Moderator', $FAQ::OMatic::Config::adminAuth);

		# tell the user how to name his FAQ
		my $helpPart = new FAQ::OMatic::Part();
		$helpPart->{'Text'} = 'To name your FAQ-O-Matic, click on '
			.'[Show Editing Commands], then on '
			.'[Edit Category Title and Options].';
		push @{$item->{'Parts'}}, $helpPart;

		# prevent user from feeling dumb because he can't find
		# the [New Answer] button by making the initial item as a
		# category (giving it a directory).
		$item->makeDirectory()->
			setText("Subcategories:\n\n\nAnswers in this category:\n");

		$item->saveToFile('1');
		displayMessage("Created an initial category (file=1).");
	} else {
		displayMessage("<b>$FAQ::OMatic::Config::itemDir</b> already "
				."contains a file '1'.");
	}
	if (not -f "$FAQ::OMatic::Config::itemDir/trash") {
		my $item = new FAQ::OMatic::Item();
		$item->setProperty('Title', 'Trash');
		$item->setProperty('Parent', 'trash');
		$item->setProperty('Moderator', $FAQ::OMatic::Config::adminAuth);
		$item->makeDirectory();
		$item->saveToFile('trash');
		displayMessage("Created a trash category.");
	} else {
		displayMessage("<b>$FAQ::OMatic::Config::itemDir</b> already "
				."contains a 'trash' file.");
	}
	if (not -f "$FAQ::OMatic::Config::itemDir/help000") {
		my $item = new FAQ::OMatic::Item();
		$item->setProperty('Title', 'Help');
		$item->setProperty('Parent', 'help000');
		$item->setProperty('Moderator', $FAQ::OMatic::Config::adminAuth);
		$item->makeDirectory();
		$item->saveToFile('help000');
		displayMessage("Created a help category.");
	} else {
		displayMessage("<b>$FAQ::OMatic::Config::itemDir</b> already "
				."contains a 'help000' file.");
	}

	# The reason for an Items version field is to ensure that
	# all of the items that come with a default FOM of a given
	# version are now installed. Old items are not replaced...
	FAQ::OMatic::Versions::setVersion('Items');

	# set itemDir_Old to current itemDir, since that's now the
	# working directory. That way if it ever moves again (oh man
	# I hope not), we'll know where to copy from. Ugh.
	my $map = readConfig();
	delete $map->{'$itemDir_Old'};
	writeConfig($map);

	doStep('mainMenu');
}

sub copyItemsStep {
	my $oldDir = $FAQ::OMatic::Config::itemDir_Old;
	my $newDir = $FAQ::OMatic::Config::itemDir;
	
	my @oldList = FAQ::OMatic::getAllItemNames($oldDir);
	my $file;
	foreach $file (@oldList) {
		my $item = new FAQ::OMatic::Item($file, $oldDir);
		$item->saveToFile('', $newDir, 'noChange');
	}
	my @newList = FAQ::OMatic::getAllItemNames($newDir);

	if (scalar(@oldList) ne scalar(@newList)) {
		displayMessage("I'm vaguely concerned that $oldDir contained "
			.scalar(@oldList)." items, but (after copying) $newDir has "
			.scalar(@newList)." items. I don't plan on doing anything "
			."about this, though. How about you check? :v)");
	} else {
		displayMessage("Copied ".scalar(@newList)." items from "
			."<tt>$oldDir</tt> to <tt>$newDir</tt>.");
	}
	doStep('mainMenu');
}

sub maintenanceStep {
	require FAQ::OMatic::Auth;
	my $rt = '';
	my $secret = FAQ::OMatic::Auth::getRandomHex();

	# The parameters we'll be passing to the maintenance module
	# via the CGI dispatch mechanism:
	my $host = $cgi->server_name();
	my $port = $cgi->server_port();
	my $path = $cgi->script_name();
	my $req = $path."?cmd=maintenance&secret=$secret";

	# Figure out a suitable -I include path in case we're picking up FAQ-O-Matic
	# modules relative to . (current working dir)
	my $idir;
	my $incBase='';
	my $incOption='';
	foreach $idir (@INC) {
		if (-d "$idir/FAQ/OMatic") {
			$incBase = $idir;
			last;
		}
	}

	if (not $incBase) {
		displayMessage("I can't figure out where the Faq-O-Matic modules live, "
			."so the cron job may not work.");
	}

	# No way to know if path is a Perl default or if it was supplied
	# with the #! (shebang) line of the CGI, so we always include it just
	# to be sure the cron job will work.
	if (not $incBase =~ m#^/#) {	# convert relative INC to absolute
		my $cwd = getcwd();
		$cwd =~ s#/$##;
		$incOption = "use lib \"$cwd/$incBase\"";
	} else {
		$incOption = "use lib \"$incBase\"";
	}

	# THANKS: John Goerzen pointed out that I wasn't putting a full path
	# THANKS: to perl in the cron job, which on some systems picks up the
	# THANKS: wrong Perl. (Perl 4, for example.)
	my $perlbin = $Config{'perlpath'};
	my $cronCmd = "$perlbin -e '$incOption; use FAQ::OMatic::maintenance; "
		."FAQ::OMatic::maintenance::invoke(\"$host\", "
		."$port, \"$req\");'";
	my $cronLine = sprintf("%d * * * * %s\n", (rand(1<<16)%60), $cronCmd);

	# display what we're planning to do, so that resourceful admins
	# can still install even if our heuristics fail and we have to abort.
	displayMessage("Attempting to install cron job:\n"
			."<pre><font size=-1>$cronLine</font></pre>\n");

	my @oldTab = getCurrentCrontab();
	my @oldUnrelated = grep {not m/$path/} @oldTab;
	my @oldReplacing = grep {m/$path/} @oldTab;

	if (scalar(@oldReplacing)>1) {
		displayMessage("Wait: more than one old crontab entry looks like\n"
			."mine (path matches <b>$path</b>). "
			."I'm not going to touch them. You'd better add\n"
			."the above line\n"
			."to some crontab yourself with <b><tt>crontab -e</tt></b>.\n",
			'default', 'abort');
	}

	open(CRONTAB, ">$FAQ::OMatic::Config::metaDir/cronfile") ||
		displayMessage("Can't write to $FAQ::OMatic::Config::metaDir/cronfile."
			." No crontab entry added.", 'default', 'abort');
	# preserve existing entries
	print CRONTAB join('', @oldUnrelated);
	# and add our new one.
	print CRONTAB $cronLine;
	close CRONTAB;
	
	# TODO: let user provide a path to crontab
	my $crontabbin = which('crontab');
	my $cmd = "$crontabbin $FAQ::OMatic::Config::metaDir/cronfile";
	my @msrc = FAQ::OMatic::mySystem($cmd);
	if (scalar(@msrc)) {
		$rt.="'$cmd' failed: ".join('', @msrc)."\n";
	}

	my $map = readConfig();
	$map->{'$maintenanceSecret'} = "'$secret'";
	writeConfig($map);

	if (@oldReplacing) {
		$rt.="I replaced this old crontab line, which appears to be an "
			."older one for this same FAQ:\n<tt><p><font size=-1>\n"
			.$oldReplacing[0]
			."</font></tt>\n";
	}

	# perform a simple test to verify our cron line got installed
	my @newTab = getCurrentCrontab();
	if (scalar(grep {m/$path/} @newTab) != 1
		or scalar(grep {m/$secret/} @newTab) != 1) {
		displayMessage("I thought I installed a new cron job, but it didn't\n"
			."appear to take.\n"
			."tab".join("<br>\n",@newTab)
			."You better add\n"
			."<pre><font size=-1>$cronLine</font></pre>\n"
			."to some crontab yourself with <b><tt>crontab -e</tt></b>.\n",
			'default', 'abort');
	}

	FAQ::OMatic::Versions::setVersion('MaintenanceCronJob');
	$rt.="<p>Cron job installed. The maintenance script should run hourly.\n";
	displayMessage($rt);
	doStep('default');
}

sub getCurrentCrontab {
	my $crontabbin = which('crontab');
	if (not $crontabbin) {
		displayMessage("I can't find a suitable crontab program in "
			.$ENV{'PATH'}.".", 'default', 'abort');
	}

	my $cmd = "$crontabbin -l";
	my @systemrc = FAQ::OMatic::mySystem($cmd, 'alwaysWantReply');
	my @oldTab;
	if ($systemrc[0]==1) {
		if ($systemrc[3]=~m/open.*crontab/i
			or $systemrc[3]=~m/no crontab for /i) {
			# looks like the "error" you get if you don't have a crontab.
			# THANKS: to Hal Wine <hal@dtor.com> for supplying the
			# second pattern to match vixie-cron's error message
			@oldTab = ();
			$systemrc[0] = 0;
		}
	}
	if ($systemrc[0] != 0) {
		displayMessage("crontab -l failed: "
			.join(',', @systemrc)
			."<p>Please report this problem to $FAQ::OMatic::authorAddress",
			'default', 'abort');
	} else {
		@oldTab = @{$systemrc[4]};
	}

	if ((scalar(@oldTab)==1) and (not $oldTab[0] =~ m/^\s*[0-9*#]/)) {
		# crontab returned one line, and it doesn't look like a
		# cron comment or command line. It's probably the error
		# message you get if you don't already have a crontab.
		# (Unfortunately, the text of the message varies across versions.)
		@oldTab = ();
	}

	return @oldTab;
}

sub makeSecureStep {
	my $map = readConfig();
	$map->{'$secureInstall'} = "'true'";
	writeConfig($map);

	# send admin straight through to changePass, since he can't
	# have a password yet
	my $url = FAQ::OMatic::makeAref('changePass',
			{'_restart'=>'install', '_admin'=>1}, 'url');
	print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
}

sub colorSamplerStep {
	my $rt = '';
	my $button = "*";

	$rt.="Use the <u>$button</u> links to change the color of a feature.\n";

	# an outer table provides the background (page) color
	$rt.="<table bgcolor=$FAQ::OMatic::Config::backgroundColor width=\"100%\">\n";
	$rt.="<tr><td>\n";

	$rt.="<table width=\"100%\">\n";
	$rt.="<tr><td rowspan=5 bgcolor=".$FAQ::OMatic::Config::itemBarColor
		." width=20 valign=bottom>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$itemBarColor\">"
		."$button</a>\n";
	$rt.="</td>\n";
	$rt.="<td bgcolor=$FAQ::OMatic::Config::backgroundColor>\n";
	$rt.="<b><font color=$FAQ::OMatic::Config::textColor>An Item Title</font></b>\n";
	$rt.="</td></tr>\n";

	$rt.="<tr><td bgcolor=$FAQ::OMatic::Config::regularPartColor>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$regularPartColor\">"
		."$button</a><p>\n";
	$rt.="<font color=$FAQ::OMatic::Config::textColor>"
		."A regular part is how most of your content will appear. The text "
		."colors should be most pleasantly readable on this background."
		."</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::linkColor>A new link</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::vlinkColor>A visited link</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::highlightColor><b>"
		."A search hit</b></font>\n";
	$rt.="</td></tr>\n";

	$rt.="<tr><td bgcolor=$FAQ::OMatic::Config::directoryPartColor>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$directoryPartColor\">"
		."$button</a><p>\n";
	$rt.="<font color=$FAQ::OMatic::Config::textColor>"
		."A directory part should stand out</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::linkColor>A new link</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::vlinkColor>A visited link</font>\n";
	$rt.="<br><font color=$FAQ::OMatic::Config::highlightColor><b>"
		."A search hit</b></font>\n";
	$rt.="</td></tr>\n";

	$rt.="<tr><td bgcolor=$FAQ::OMatic::Config::regularPartColor>\n";
	$rt.="&nbsp;<p>\n";
	$rt.="</td></tr>\n";

	$rt.="<tr><td bgcolor=$FAQ::OMatic::Config::regularPartColor>\n";
	$rt.="&nbsp;<p>\n";
	$rt.="</td></tr>\n";

	$rt.="<tr><td colspan=2 bgcolor=$FAQ::OMatic::Config::backgroundColor>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$backgroundColor\">"
		."$button</a>\n";
	#$rt.="<font color=$FAQ::OMatic::Config::textColor>Page background color</font>";
	$rt.="<p>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$textColor\">"
		."$button</a>\n";
	$rt.="<font color=$FAQ::OMatic::Config::textColor>Regular text color</font><br>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$linkColor\">"
		."$button</a>\n";
	$rt.="<font color=$FAQ::OMatic::Config::linkColor>Link color</font><br>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$vlinkColor\">"
		."$button</a>\n";
	$rt.="<font color=$FAQ::OMatic::Config::vlinkColor>Visited link color</font><br>\n";
	$rt.="<a href=\""
		.installUrl('askColor', 'url')."&whichColor=\$highlightColor\">"
		."$button</a>\n";
	$rt.="<font color=$FAQ::OMatic::Config::highlightColor><b>"
		."A search hit</b></font>\n";
	$rt.="</td></tr>\n";

	$rt.="</table>\n";

	$rt.="</td></tr></table>\n";
	displayMessage($rt, 'mainMenu');
}

sub askColorStep {
	my $rt = '';
	my $which = $params->{'whichColor'};
	$rt.="Select a color for $which:<p>\n";
	$rt.="<a href=\""
		.installUrl('setColor', 'url')
		."&whichColor=$which&color=\"><img src=\""
		.installUrl('', 'url', 'img', 'picker')
		."\" border=1 ismap width=256 height=128></a>\n";

	my $map = readConfig();
	my $oldval = stripQuotes($map->{$which});
	$rt.="<p>".installUrl('setColor', 'GET');
	$rt.="Or enter an HTML color specification manually:<br>\n";
	$rt.="<input type=hidden name=\"whichColor\" value=\"$which\">\n"
		."<input type=text name=\"color\" value=\"$oldval\">\n"
		."<input type=submit name=\"_junk\" value=\"Select\">\n"
		."</form>\n";

	displayMessage($rt);
}

sub setColorStep {
	require FAQ::OMatic::ColorPicker;
	my $which = $params->{'whichColor'};
	if (not $which =~ m/Color$/) {
		displayMessage("Unrecognized config parameter ($which).", 'default');
		return;
	}
	my $color = $params->{'color'}||'';
	my $colorSpec;
	if ($color =~ m/,/) {
		my ($c,$r) = ($color =~ m/\?(\d+),(\d+)/);
		if (not defined $c or not defined $r) {
			displayMessage("color parameter ($color) not received", 'default');
			return;
		}
		my ($red,$green,$blue) = FAQ::OMatic::ColorPicker::findRGB($c/255, $r/127);
		$colorSpec = sprintf("'#%02x%02x%02x'",
			$red*255, $green*255, $blue*255);
	} else {
		$colorSpec = "'$color'";
	}

	# update config file
	my $map = readConfig();
	$map->{$which} = $colorSpec;
	writeConfig($map);

	FAQ::OMatic::Versions::setVersion('CustomColors');

	rereadConfig();

	doStep('colorSampler');
}

sub configVersionStep {
	my $map = readConfig();
	$map->{'$version'} = "'$FAQ::OMatic::VERSION'";
	writeConfig($map);
	
	doStep('mainMenu');
}

sub displayMessage {
	my $msg = shift;
	my $whereNext = shift;
	my $abort = shift;

	my $rt = '';
	$rt .= "\n$msg<p>\n";

	if ($whereNext) {
		my $url = installUrl($whereNext);
		$rt .= "<a href=\"$url\">Click here</a> "
			."to proceed to the \"$whereNext\" step.\n";
	}
	print $rt;

	exit(0) if ($abort);
}

sub installUrl {
	# can't necessarily use makeAref yet, because we're not configured.
	my $step = shift;
	my $reftype = shift || 'url';	# 'url', 'GET' supported
	my $cmd = shift || 'install';	# for images, need to specify cmd
	my $name = shift || '';			# for images, need to specify name

	my $imarg = ($name) ? ("&name=$name") : '';

	if ($FAQ::OMatic::Config::secureInstall) {
		return FAQ::OMatic::makeAref($cmd,
			{'step'=>$step,
			'name'=>$name,
			'auth'=>$params->{'auth'}	# preserve only the cookie
			},
			$reftype, 0, 'blastAll');
	}

	my $url = $cgi->url();
	$url =~ s/\?[^\?]*$//;	# strip args
	if ($reftype eq 'GET') {
		return "<form action=\"$url\" method=\"GET\">\n"
			."<input type=hidden name=cmd value=install>\n"
			."<input type=hidden name=step value=$step>\n";
	} else {
		return "$url?cmd=$cmd&step=$step$imarg";
	}
}

sub readConfig {
	if (not open(CONFIG, "<$FAQ::OMatic::dispatch::meta/config")) {
		displayMessage("Can't read config file \"$FAQ::OMatic::dispatch::meta/config\""
			." because: $!", 'default');
		return;
	}

	my $map = {};
	while (<CONFIG>) {
		chomp;
		next if (not m/=/);
		my ($left,$right) = m/(\S+)\s*=\s*(\S+.*);$/;
		if (defined $left and defined $right) {
			$map->{$left} = $right;
		}
	}
	close CONFIG;

	return $map;
}

sub writeConfig {
	my $map = shift;

	if (not open(CONFIG, ">$FAQ::OMatic::dispatch::meta/config")) {
		displayMessage("Can't write config file \"$FAQ::OMatic::dispatch::meta/config\""
			." because: $!", 'default', 'abort');
	}

	print CONFIG "package FAQ::OMatic::Config;\n";
	my ($left, $right);
	foreach $left (sort keys %{$map}) {
		$right = $map->{$left};
		print CONFIG $left." = ".$right.";\n";
	}
	print CONFIG "1;\n";	# modules have to return true
	close CONFIG;

	return;
}

sub stripQuotes {
	my $arg = shift;
	$arg =~ s/^'//;
	$arg =~ s/'$//;
	return $arg;
}

# some mkdir()s don't like to create a dir if the argument path has a
# trailing slash. (John Goerzen says this is true of BSDI.) So although
# canonically store directories with trailing slashes (to prevent
# concatenating together a path and forgetting an intervening slash),
# we need to strip the slash before calling mkdir().
# THANKS: John Goerzen
sub stripSlash {
	my $arg = shift;

	$arg =~ s#/+$##;
	return $arg;
}

1;
