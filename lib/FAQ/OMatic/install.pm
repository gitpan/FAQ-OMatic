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

###
### install.pm
###
### This module allows the administrator to install and configure a
### Faq-O-Matic.
###

package FAQ::OMatic::install;

use CGI;
use FAQ::OMatic;
use FAQ::OMatic::Item;
use FAQ::OMatic::Part;

sub main {
	$cgi = $FAQ::OMatic::dispatch::cgi;

	if ($FAQ::OMatic::Config::secureInstall) {
		require FAQ::OMatic::Auth;
		# make params available to FAQ::OMatic::Auth::getId
		$params = FAQ::OMatic::getParams($cgi, 'dontlog');
		my ($id,$aq) = FAQ::OMatic::Auth::getID();
		if (($id ne $FAQ::OMatic::Config::adminAuth) or ($aq<5)) {
			#print $cgi->header("text/plain");
			#print "got id $id, $FAQ::OMatic::Config::adminAuth\n";
			my $url = FAQ::OMatic::makeAref('authenticate',
				{'_restart' => 'install', '_reason'=>'9' },
				'url', 'saveTransients');
			print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
		}
	}

	print $cgi->header("text/html");
	print $cgi->start_html('-title'=>"Faq-O-Matic Installer",
							'-bgcolor'=>"#ffffff");

	doStep($cgi->param('step'));

	print $cgi->end_html();
}

my %knownSteps = map {$_=>1} qw(
	default			askMeta			configMeta		initConfig
	mainMenu		askItem			configItem		askConfig
	firstItem		initMetaFiles					setConfig
	maintenance		makeSecure
	colorSampler	askColor		setColor
	);

sub doStep {
	my $step = shift;

	if ($knownSteps{$step}) {
		# look up subroutine dynamically.
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
		and ($FAQ::OMatic::dispatch::meta ne $FAQ::OMatic::Config::metaDir)) {
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

	if (-f "$FAQ::OMatic::Config::metaDir/config") {
		# There's a config file in the directory pointed to by the
		# CGI stub. We're can run the main menu and do everything else
		# from there now.
		doStep('mainMenu');
	} else {
		# Can't see a config file. Offer to create it for admin.
		displayMessage("(Can't find <b>config</b> in '$FAQ::OMatic::Config::metaDir' -- assuming this is a new installation.)");
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

	$rt.="Starting a new FAQ in $stubMeta.\n";
	$rt.="<a href=\""
		.installUrl('configMeta')."\">Click here to continue</a>.<p>\n";

	$rt.="If you want to change the CGI stub to point to another directory,"
		." edit the script and then\n";
	$rt.="<a href=\""
		.installUrl('default')
		."\">click here to use the new location</a>.<p>\n";

	displayMessage($rt);
}

sub configMetaStep {
	my $rt.='';

	$meta = $FAQ::OMatic::dispatch::meta;
	if (not -d "$meta/.") {
		# try mkdir
		if (not mkdir($meta, 0700)) {
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
	if (not -d "$meta"."RCS/.") {
		# try mkdir
		if (not mkdir("$meta/RCS", 0700)) {
			displayMessage("I couldn't create <b>$meta"."RCS/</b>: $!");
			doStep('askMeta');
			return;
		}
		displayMessage("Created <b>$meta/RCS/</b>.");
	}
	if (not -w "$meta"."RCS/.") {
		displayMessage("I don't have write permission to <b>$meta"."RCS/</b>.");
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
		my $userDfl = 'getpwuid($<)';
	
		my $map = {
			'$adminAuth'		=> "''",
			'$adminEmail'		=> "\$adminAuth",
			'$metaDir'			=> "'$metaDfl'",
			'$itemDir'			=> "'$itemDfl'",
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
			'$version'			=> "'$FAQ::OMatic::VERSION'"
		};
	
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
	foreach $path (split(':', $ENV{'PATH'})) {
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
		eval(join('', @cfg));
	}
}

sub mainMenuStep {
	my $rt='';

	rereadConfig();

	$rt.="<h3>Configuration Main Menu (install module)</h3>\n";
	$rt.="<ol>\n";
	$rt.="<li><a href=\"".installUrl('askItem')."\">"
			.checkBoxFor('askItem')
			."Define item directory.</a>\n";
	$rt.="<li><a href=\"".installUrl('askConfig')."\">"
			.checkBoxFor('askConfig')
			."Define other configuration parameters.</a>\n";
	$rt.="<li><a href=\"".installUrl('firstItem')."\">"
			.checkBoxFor('firstItem')
			."Create an initial category and a trash can.</a>\n";
	$rt.="<li><a href=\"".installUrl('maintenance')."\">"
			.checkBoxFor('maintenance')
			."Set up the maintenance cron job</a>\n";
	$rt.="<li><a href=\"".installUrl('', 'url', 'maintenance')
			."&secret=$FAQ::OMatic::Config::maintenanceSecret\">"
			.checkBoxFor('manualMaintenance')
			."Run maintenance script manually now.</a>\n";
	if (not $FAQ::OMatic::Config::secureInstall) {
		if ($FAQ::OMatic::Config::mailCommand and $FAQ::OMatic::Config::adminAuth) {
			$rt.="<li><a href=\"".installUrl('makeSecure')."\">"
				.checkBoxFor('makeSecure')
				."Turn on installer security.</a>\n";
		} else {
			$rt.="<li>"
				.checkBoxFor('makeSecure')
				."Turn on installer security (Need to configure "
				."\$mailCommand and \$adminAuth).\n";
		}
	} else {
		$rt.="<li>"
			.checkBoxFor('makeSecure')
			."(Installer security is on.)\n";
	}
	$rt.="<li>".checkBoxFor('nothing')
			."<a href=\"".installUrl('', 'url', 'editGroups')."\">"
			."Define groups</a> (optional).\n";
	$rt.="<li>".checkBoxFor('nothing')
			."<a href=\"".installUrl('colorSampler')."\">"
			."Select colors for your Faq-O-Matic</a> (optional).\n";
	$rt.="<li>".checkBoxFor('nothing')
			."<a href=\"".installUrl('mainMenu')."\">"
			."Bookmark this link to be able to return to this menu.</a>\n";
	$rt.="<li>".checkBoxFor('nothing')
			."<a href=\"".installUrl('','url','stats')."\">"
			."Bookmark this link to the statistics page.</a>\n";
	if ($FAQ::OMatic::Config::secureInstall) {
		$rt.="<li>".checkBoxFor('nothing')
				."<a href=\"".installUrl('', 'url', 'faq')."\">"
				."Go to the Faq-O-Matic.</a>\n";
	} else {
		$rt.="<li>".checkBoxFor('nothing')
			."Go to the Faq-O-Matic (need to turn on installer security)";
	}
	$rt.="</ol>\n";

	$rt.="The Faq-O-Matic modules are version $FAQ::OMatic::VERSION.\n";
	#$rt.="The config file is at version $FAQ::OMatic::Config::version.\n";

	displayMessage($rt);
}

sub checkBoxFor {
	my $thing = shift;
	my $done = '';

	my $rt = "<img border=0 src=\"";
	$done = 1 if (($thing eq 'askItem') && (-d "$FAQ::OMatic::Config::itemDir/."));
	$done = 1 if (($thing eq 'askConfig') && ($FAQ::OMatic::Config::adminAuth));
	$done = 1 if (($thing eq 'firstItem') && (-f "$FAQ::OMatic::Config::itemDir/1"));
	$done = 1
		if (($thing eq 'maintenance') && ($FAQ::OMatic::Config::maintenanceSecret));
	$done = 1 if (($thing eq 'makeSecure') && ($FAQ::OMatic::Config::secureInstall));
	$done = 1 if (($thing eq 'manualMaintenance')
					&& (-f "$FAQ::OMatic::Config::metaDir/lastMaintenance"));

	if ($thing eq 'nothing') {
		$rt.=installUrl('', 'url', 'spaceImage');
	} elsif ($done) {
		$rt.=installUrl('', 'url', 'checkedImage');
	} else {
		$rt.=installUrl('', 'url', 'uncheckedImage');
	}
	$rt.="\"> ";
	return $rt;
}

sub askItemStep {
	my $rt = '';

	my $dflItem = stripQuotes(readConfig()->{'$itemDir'});

	$rt.="Faq-O-Matic needs a writable directory in which to store\n";
	$rt.="FAQ item data. Frequently, this is just a subdirectory of\n";
	$rt.="the <b>meta/</b> directory. If you have an existing Faq-O-Matic 2\n";
	$rt.="installation, you can enter the path to its <b>item/</b> here,\n";
	$rt.="and this installation will use those existing items.\n";
	$rt.=installUrl('configItem', 'GET');
	$rt.="<input type=input size=60 name=item value=\"$dflItem\">\n";
	$rt.="<input type=submit name=junk value=\"Define\">\n";
	$rt.="</form>\n";
	displayMessage($rt);
}

sub configItemStep {
	my $rt.='';

	$item = $cgi->param('item');
	if (not -d "$item/.") {
		if (not mkdir($item, 0700)) {
			displayMessage("I couldn't create <b>$item</b>: $!");
			doStep('askItem');
			return;
		}
		displayMessage("Created <b>$item</b>.");
	}
	if (not -w "$item/.") {
		displayMessage("I don't have write permission to <b>$item</b>.");
		doStep('askItem');
		return;
	}

	my $map = readConfig();
	$map->{'$itemDir'} = "'".$item."'";
	writeConfig($map);
	displayMessage("updated config file: \$itemDir = <b>$item</b>");

	doStep('mainMenu');
}

$configInfo = {
#	config var => [ 'sortOrder|hide', 'description',
#					['unquoted values'], free-input-okay, is-a-command ]
	'RCSargs' =>	[ 'hide',
		'Arguments to make ci quietly log changes (default is probably fine)',
		[], 1 ],
	'RCSci' =>		[ 'a-r1',
		'RCS ci command',
		[], 1, 'isCommand' ],
	'RCSuser' =>	[ 'y-r3',
		'User to use for RCS ci command (default is probably fine)',
		['getpwuid($<)'], 1 ],
	'adminAuth' =>	[ 'a-a1',
		'Identity of local FAQ-O-Matic administrator (an email address)',
		[], 1 ],
	'adminEmail' =>	[ 'n-a2',
		'Where FAQ-O-Matic should send email when it wants to alert the administrator'
		.' (usually same as $adminAuth)',
		[ '$adminAuth' ], 1 ],
# Disabled -- I don't think I care anymore about everybody's install problems.
# It's popular enough now that folks can probably bear to email me
# themselves if things go south.
#	'authorEmail'=>	[ 'n-a3',
#		'Where FAQ-O-Matic should send email when it wants to alert its author about'
#		.' bugs (use \'\' to disable emailing the author)',
#		[ "'jonh\@cs.dartmouth.edu'", "''" ], 0 ],
	'itemDir' =>	[ 'hide' ],
	'authorEmail' =>[ 'hide' ],
	'mailCommand'=>	[ 'a-m1',
		'A command FAQ-O-Matic can use to send mail. It must understand the -s '
		.'(Subject) switch.',
		[], 1, 'isCommand' ],
	'maintSendErrors'=>[ 'n-m2',
		'If true, FAQ-O-Matic will mail the log file to the administrator whenever'
		.' it is truncated.',
		[ "'true'", "''" ], 0 ],
	'metaDir' =>	[ 'hide' ],
	'statUniqueHosts'=>[ 'hide' ],
	'backgroundColor'=>['hide'],
	'directoryPartColor'=>['hide'],
	'highlightColor'=>['hide'],
	'itemBarColor'=>['hide'],
	'linkColor'=>['hide'],
	'regularPartColor'=>['hide'],
	'textColor'=>['hide'],
	'vlinkColor'=>['hide'],
	'secureInstall'=>[ 'hide' ],
	'version'=>[ 'hide' ],
	'maintenanceSecret'=>[ 'hide' ]
};

sub askConfigStep {
	my $rt = '';
	my $map = readConfig();
	my ($left, $right);

	$rt.="<table>\n";
	$rt.=installUrl('setConfig', 'GET');

	my $widgets = {};	# collect widgets here for sorting later
	foreach $left (sort keys %{$map}) {
		$right = $map->{$left};
		my $aleft = $left;
		$aleft =~ s/^\$//;
		my $aright = stripQuotes($right);
		my ($sort,$desc,$fopts,$freeok,$isCmd);
		if ($configInfo->{$aleft}) {
			($sort,$desc,$fopts,$freeok,$isCmd) = @{$configInfo->{$aleft}};
			$desc.="<br>This is a command, so only letters, hyphens, and"
				." slashes are allowed." if ($isCmd);
		} else {
			$sort = 'zzzz';
			$desc = '(no description)';
			$fopts = [];
			$freeok = 1;
			$isCmd = 0;
		}
		if ($sort ne 'hide') {
			my $wd = '';
			$wd.="<tr><td align=right valign=top><b>$left</b></td>"
				."<td align=left valign=top>\n";
			$wd.="$desc<br>\n";
			#$wd.="/$aleft/".join(",", @{$fopts})."/free=".$freeok."/<br>";
			my $selected = 0;		# don't show $right in free field if
									# it was available by a select button
			if (scalar(@{$fopts})) {
				foreach $choice (@{$fopts}) {
					$wd.="<input type=radio name=\"$left-select\" "
						.($right eq $choice ? ' checked' : '')
						." value=\"$choice\"> $choice<br>\n";
					$selected = 1 if ($right eq $choice);
				}
				if ($freeok) {
					$wd.="<input type=radio name=\"$left-select\" "
						.($selected ? '' : ' checked')
						." value=\"free\">\n";
				}
			} else {
				$wd.="<input type=hidden name=$left-select value=\"free\">\n";
			}
			if ($freeok) {
				$wd.="<input type=text size=40 name=\"$left-free\" "
					."value=\""
					.($selected ? '' : $aright)
					."\">\n";
			}
			$wd.="</td></tr>\n";
			$widgets->{$sort} .= $wd;
		}
	}

	# insert separator widgets
	$widgets->{'a--separator'} = "<tr><td colspan=2>"
			."<hr>Mandatory configurations... these must be correct<hr>"
			."</td></tr>\n";
	$widgets->{'b-separator'} = "<tr><td colspan=2>"
			."<hr>Optional configurations... defaults are pretty good.<hr>"
			."</td></tr>\n";

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
	my ($left, $right);
	my $map = readConfig();
	foreach $left (sort keys %{$map}) {
		$right = $map->{$left};
		my $selected = $cgi->param($left."-select");
		if ($selected eq 'free') {
			$map->{$left} = "'".$cgi->param($left."-free")."'";
		} elsif ($selected ne '') {
			$map->{$left} = $selected;
		}
		my $aleft = $left;
		$aleft =~ s/^\$//;
		if ($configInfo->{$aleft}->[4]) {	# it represents a command...
			$map->{$left} =~ s#[^\w/'-]##gs;	# be very restrictive
		}
		my $warn = checkConfig($left, $map->{$left});
		$warnings .= "<li>$warn" if ($warn);
	}
	writeConfig($map);
	$warnings = "<p><b>Warnings: <ul>$warnings</ul>"
				."You should "
				."<a href=\"".installUrl('askConfig')."\">go back</a>"
				." and fix these configurations.</b>"
			if ($warnings);
	displayMessage("Rewrote configuration file.\n$warnings");
	doStep('mainMenu');
}

sub checkConfig {
	my $left = shift;
	my $right = shift;
	my $aright = stripQuotes($right);
	if ($left eq '$adminAuth') {
		if (not FAQ::OMatic::validEmail($aright)) {
			return "$left ($right) doesn't look like an email address.";
		}
		return '';
	}
	if ($left eq '$adminEmail' and $right ne '$adminAuth') {
		if (not FAQ::OMatic::validEmail($aright)) {
			return "$left ($right) doesn't look like an email address.";
		}
		return '';
	}
	if ($left eq '$mailCommand') {
		if (not -x $aright) {
			return "$left ($right) isn't executable.";
		}
		return '';
	}
	if ($left eq '$RCSci') {
		if (not -x $aright) {
			return "$left ($right) isn't executable.";
		}
		return '';
	}
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
			setText("Subcategories:\n\nAnswers in this category:\n");

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
	doStep('mainMenu');
}

sub maintenanceStep {
	require FAQ::OMatic::Auth;
	my $secret = FAQ::OMatic::Auth::getRandomHex();

	my $crontab = which('crontab');
	if (not $crontab) {
		displayMessage("I can't find a suitable crontab program in "
			.$ENV{'PATH'}.".", 'default');
		return;
	}
	open(CRONTAB, "$crontab -l 2>&1 |");
	my @oldTab = <CRONTAB>;
	close CRONTAB;

	if ((scalar(@oldTab)==1) and ($oldTab[0] =~ m/^crontab/)) {
		# this looks like an error message, the one you get
		# if you don't already have a crontab.
		@oldTab = ();
	}

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

	my $cronCmd = "perl -e '$incOption; use FAQ::OMatic::maintenance; "
		."FAQ::OMatic::maintenance::invoke(\"$host\", "
		."$port, \"$req\");'";
	my $cronLine = sprintf("%d * * * * %s\n", (rand(1<<16)%60), $cronCmd);

	my @oldUnrelated = grep {not m/$path/} @oldTab;
	my @oldReplacing = grep {m/$path/} @oldTab;

	if (scalar(@oldReplacing)>1) {
		displayMessage("Wait: more than one old crontab entry looks like"
			."mine (path matches <b>$path</b>). "
			."I'm not going to touch them. You better add\n"
			."<pre><font size=-1>$cronLine</font></pre>\n"
			."to some crontab yourself with <b><tt>crotab -e</tt></b>.\n",
			'default');
	}

	open(CRONTAB, "|crontab");
	# preserve existing entries
	print CRONTAB join('', @oldUnrelated);
	# and add our new one.
	print CRONTAB $cronLine;
	close CRONTAB;

	my $map = readConfig();
	$map->{'$maintenanceSecret'} = "'$secret'";
	writeConfig($map);

	my $rt ='';
	if (@oldReplacing) {
		$rt.="I replaced this old crontab line, which appears to be an "
			."older one for this same FAQ:\n<pre><font size=-1>\n"
			.$oldReplacing[0]
			."</font></pre>\n";
	}
	$rt.="<p>Cron job installed. The maintenance script should run hourly.\n";
	displayMessage($rt);
	doStep('default');
}

sub makeSecureStep {
	my $map = readConfig();
	$map->{'$secureInstall'} = "'true'";
	writeConfig($map);
	displayMessage("Installer now requires authentication. You will need "
		."to log in to continue.", 'default');
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
		.installUrl('', 'url', 'pickerImage')
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
	my $color = $params->{'color'};
	my $colorSpec;
	if ($color =~ m/,/) {
		my ($c,$r) = ($color =~ m/\?(\d+),(\d+)/);
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

	rereadConfig();

	doStep('colorSampler');
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

	if ($FAQ::OMatic::Config::secureInstall) {
		return FAQ::OMatic::makeAref($cmd,
			{'step'=>$step,
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
		return "$url?cmd=$cmd&step=$step";
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
		$map->{$left} = $right;
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

1;
