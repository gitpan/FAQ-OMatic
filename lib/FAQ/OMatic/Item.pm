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
### A FAQ::OMatic::Item is a data structure that contains an entire item
### from the FAQ. (One file.)
###

package FAQ::OMatic::Item;

use FAQ::OMatic::Part;
use FAQ::OMatic;
use FAQ::OMatic::Auth;
use FAQ::OMatic::Appearance;
use FAQ::OMatic::Groups;

%itemCache = ();	# contains (filename => item ref) mappings

sub new {
	my ($class) = shift;
	my ($arg) = shift;	# what file the item data lives in
	my ($dir) = shift;	# what dir we should look in for the item data
						# (default $FAQ::OMatic::Config::metaDir)
	$item = {};
	bless $item;

	# if we have the item loaded already, use the in-core copy!
	if ($arg and (defined $itemCache{$arg})) {
		return $itemCache{$arg};
	}

	$item->{'class'} = $class;
	$item->{'Parts'} = [];

	if ($arg) {
		$item->loadFromFile($arg,$dir);
		$itemCache{$item->{'filename'}} = $item;
	} else {
		$item->{'Title'} = "New Item";
	}
	return $item;
}

sub loadFromFile {
	my $self = shift;
	my $filename = shift;
	my $dir = shift;		# optional -- almost always itemDir

	$filename =~ s#/##;		# untaint user input (so they can't express
							# a file of ../../../../../../etc/passwd)
	$dir = $FAQ::OMatic::Config::itemDir if (not $dir);

	if (not -f "$dir/$filename") {
		if ($dir eq $FAQ::OMatic::Config::itemDir) {
			# admin only cares much if an item turns up missing
			FAQ::OMatic::gripe('note',
				"FAQ::OMatic::Item::loadFromFile: $filename isn't a regular "
				."file (-f test failed).");
		}
		delete $self->{'Title'};
		return;
	}

	if (not open(FILE, "$dir/$filename")) {
		FAQ::OMatic::gripe('note',
			"FAQ::OMatic::Item::loadFromFile couldn't open $filename.");
		delete $self->{'Title'};
		return;
	}

	# take note of which file we came from
	$self->{'filename'} = $filename;

	# process item headers
	while (<FILE>) {
		chomp;
		my ($key,$value) = FAQ::OMatic::keyValue($_);
		if ($key eq 'Part') {
			my $newPart = new FAQ::OMatic::Part;
			$newPart->loadFromFile(\*FILE, $filename, $self,
					scalar @{$self->{'Parts'}});	# partnum
			push @{$self->{'Parts'}}, $newPart;
		} elsif ($key ne '') {
			$self->{$key} = $value;
		} else {
			FAQ::OMatic::gripe('problem',
				"FAQ::OMatic::Item::loadFromFile was confused by this header in file $filename: \"$_\"");
			# this marks the item "broken" so that the save routine will
			# refuse to save this corrupted file out and lose more data.
			delete $self->{'Title'};
			return;
		}
	}

	return $self;
}

sub numParts {
	my $self = shift;
	return scalar @{$self->{'Parts'}};
}

sub getPart {
	my $self = shift;
	my $num = shift;

	return $self->{'Parts'}->[$num];
}

my @monthMap =( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
				'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' );

# a human-readable date/time format. Currently used for the
# last-modified field.
sub compactDate {
	my ($forsecs) = shift;	# optional; default is now
	$forsecs = time() if (not $forsecs);
	my ($sec,$min,$hr,$day,$mo,$yr,$wday,$yday,$isdst) = localtime($forsecs);
	my $ampm = "am";
	if ($hr >= 12) {
		$hr -= 12;
		$ampm = "pm";
	}
	$hr = 12 if ($hr == 0);

	return sprintf("%04d-%03s-%02d %2d:%02d%s",
			$yr+1900, $monthMap[$mo], $day, $hr, $min, $ampm);
}

sub saveToFile {
	my $self = shift;
	my $filename = shift;
	my $dir = shift;		# optional -- almost always itemDir
	my $lastModified = shift;	# optional -- normally today

	$dir = $FAQ::OMatic::Config::itemDir if (not $dir);

	if ($self->isBroken()) {
		FAQ::OMatic::gripe('error', "Tried to save a broken item to $filename.");
	}

	if (not $filename) {
		$filename = $self->{'filename'};
	} else {
		# change of filename (so far, only from a new, anonymous item)
		$self->{'filename'} = $filename;
	}

	$self->{'LastModified'} = compactDate($lastModified);

	my $lock = FAQ::OMatic::lockFile("$filename");
	return if not $lock;
		
	if (not open(FILE, ">$dir/$filename")) {
		FAQ::OMatic::gripe('problem',
			"saveToFile: Couldn't write to $dir/$filename because $!");
		FAQ::OMatic::unlockFile($lock);
		return;
	}
	foreach $key (sort keys %{$self}) {
		if (($key =~ m/^[a-z]/) or ($key eq 'Parts')) {
			next;
			# some keys don't get explicitly written out.
			# These include lowercase keys (e.g. class, filename),
			# and the Parts key, which we write explicitly later.
		} else {
			print FILE "$key: $self->{$key}\n";
		}
	}
	# now save the parts out
	my $partCount = 0;
	foreach $part (@{$self->{'Parts'}}) {
		print FILE "Part: $partCount\n";
		print FILE $part->displayAsFile();
		print FILE "EndPart: $partCount\n";
		++$partCount;
	}

	close FILE;
	FAQ::OMatic::unlockFile($lock);

	# perform RCS ci so we can always get the files back in the face
	# of net-creeps. Don't do it for .smry files (which also use the
	# FAQ::OMatic::Item mechanism).
	## Tell RCS who we are
	if (not $filename =~ m#\.smry#) {
		$ENV{"USER"} = $FAQ::OMatic::Config::RCSuser;
	   	$ENV{"LOGNAME"} = $FAQ::OMatic::Config::RCSuser;
		my $cmd = "$FAQ::OMatic::Config::RCSci $FAQ::OMatic::Config::RCSargs "
				."$dir/$filename $FAQ::OMatic::Config::metaDir/RCS/$filename,v "
				."2> $FAQ::OMatic::Config::metaDir/rcserr";
		if (system($cmd)) {
			open ERRF, "<$FAQ::OMatic::Config::metaDir/rcserr";
			my @problem = <ERRF>;
			close ERRF;
			my $problem = join("", @problem);
			$problem =~ s/\n/ /gs;
			FAQ::OMatic::gripe('problem',
				"RCS \"$cmd\" failed, saying \"$problem\"");
		}
	}

	# if $lastModified was specified, correct filesystem mtime
	if ($lastModified) {
		utime(time(),$lastModified,"$dir/$filename");
	}

	# only clear hint if it's a regular item (not a .smry item)
	if ($dir eq $FAQ::OMatic::Config::itemDir) {
		unlink("$FAQ::OMatic::Config::metaDir/freshSearchDBHint");
	}
}

sub display {
	my $self = shift;
	my @keys;
	my $rt = "";	# return text

	foreach $key (sort keys %$self) {
		if ($key eq 'Parts') {
			$rt .= "<li>Parts\n";
			foreach $part (@{$self->{$key}}) {
				$rt .=  $part->display();
			}
		} else {
			$rt .= "<li>$key => $self->{$key}<br>\n";
		}
	}
	return $rt;
}

sub getTitle {
	my $self = shift;
	my $undefokay = shift;	# return undef instead of '(missing or broken...'
	my $title = $self->{'Title'};
	if ($title) {
    	$title =~ s/&/&amp;/sg;
    	$title =~ s/</&lt;/sg;
    	$title =~ s/>/&gt;/sg;
    	$title =~ s/"/&quot;/sg;
	} else {
		undef $title;
		$title = '(missing or broken file)' if (not $undefokay);
	}

	return $title;
}

sub isBroken {
	my $self = shift;
	return (not defined($self->{'Title'}));
}

sub getParent {
	my $self = shift;

	return new FAQ::OMatic::Item($self->{'Parent'});
}

sub getParentChain {
	my $self = shift;
	my @titles = ();
	my @filenames = ();
	my ($nextfile, $nextitem, $thisfile);

	$nextitem = $self;
	$nextfile = $self->{'filename'};
	do {
		push @titles, $nextitem->getTitle();
		push @filenames, $nextitem->{'filename'};
		$thisfile = $nextfile;
		$nextfile = $nextitem->{'Parent'};
		$nextitem = $nextitem->getParent();
	} while ((defined $nextitem) and (defined $nextfile)
		and ($nextfile ne $thisfile));

	return (\@titles, \@filenames);
}

# okay, I guess this displays the neightbors, too...
sub displaySiblings {
	my $self = shift;
	my $params = shift;
	my $rt = '';		# return text
	my ($titles,$filenames) = $self->getParentChain();
	my $useTable = not $params->{'simple'};

	my ($prevs,$nexts) = $self->getSiblings();
	if ($prevs) {
		my $prevItem = new FAQ::OMatic::Item($prevs);
		my $prevTitle = $prevItem->getTitle();
		if ($useTable) {
			$rt.="<tr><td valign=top align=right>\n";
		} else {
			$rt.="<br>\n";
		}
		$rt.="Previous: ";
		$rt.="</td><td valign=top align=left>\n" if $useTable;
		$rt.="<a href=\""
			.FAQ::OMatic::makeAref('faq', {"file"=>$prevs}, 'url')
			."\">$prevTitle</a>\n";
		$rt.="</td></tr>\n" if $useTable;
	}
	if ($nexts) {
		my $nextItem = new FAQ::OMatic::Item($nexts);
		my $nextTitle = $nextItem->getTitle();
		if ($useTable) {
			$rt.="<tr><td valign=top align=right>\n";
		} else {
			$rt.="<br>\n";
		}
		$rt.="Next: ";
		$rt.="</td><td valign=top align=left>\n" if $useTable;
		$rt.="<a href=\""
			.FAQ::OMatic::makeAref('faq', {"file"=>$nexts}, 'url')
			."\">$nextTitle</a>\n";
		$rt.="</td></tr>\n" if $useTable;
	}
	return $rt;
}

sub hasParent {
	my $self = shift;
	my $parentQuery = shift;
	my ($titles,$filenames) = $self->getParentChain();

	my $i;
	foreach $i (@{$filenames}) {
		my $item = new FAQ::OMatic::Item($i);
		return 'true' if ($item->{'filename'} eq $parentQuery);
	}

	return '';
}

sub displayCoreHTML {
	my $self = shift;
	my $params = shift;	# ref to hash of display params
	my $rt = "";		# return text

	# we'll pass this to makeAref to get file param right in links
	my @fixfn = ('file',$self->{'filename'});

	$rt .= FAQ::OMatic::Appearance::itemStart($params);

	# prefix item title with a path back to the root, so that user
	# can find his way back up. (This replaces the old "Up to:" line.)
	my ($titles,$filenames) = $self->getParentChain();
	if ((@{$filenames} <= 1)
		and ($self->{'filename'} eq 'trash')) {
		# When we're in the trash, provide a way to get back to the
		# top. (There should be some less-hackish way to do this.)
		my $topitem = new FAQ::OMatic::Item('1');
		my $toptitle = $topitem->getTitle();
		push @{$titles}, $toptitle;
		push @{$filenames}, '1';
	}
	my ($thisTitle) = shift @{$titles};
	my ($thisFilename) = shift @{$filenames};
	my (@parentTitles) = reverse @{$titles};
	my (@parentFilenames) = reverse @{$filenames};
	my $i;
	for ($i=0; $i<@parentTitles; $i++) {
		$rt.=FAQ::OMatic::makeAref('faq',
			{"file"=>$parentFilenames[$i]},
			'')
			.$parentTitles[$i]
			."</a>:";
	}
	$rt.="<br>" if (@parentTitles);
	$rt.="<b>$thisTitle</b>";

	if ($params->{'showModerator'}) {
		$rt .= "<br>Moderator: "
			.FAQ::OMatic::Auth::getInheritedProperty($self, 'Moderator');
		$rt .= " <i>(inherited from parent)</i>" if (not $self->{'Moderator'});
		$rt .= "\n";
	}

	## Edit commands:
	if ($params->{'showEditCmds'}) {
		$rt .= "<br>";
		$rt .= $FAQ::OMatic::Appearance::editStart;
				#."Edit Item: ";
		my $whatAmI = $self->whatAmI();
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('editItem', {@fixfn}),
			"Edit $whatAmI Title and Options")."\n";

		# Duplicate it
		my $dupTitle = ($whatAmI eq 'Answer')
					? "Duplicate Answer"
					: "Duplicate Category as Answer";
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('addItem',
				{'_insert'=>'answer',
				 '_duplicate'=>$self->{'filename'},
				'file'=>$self->{'Parent'}}),
				$dupTitle)."\n";

		# Move it (if not at the top)
		if (($self->{'Parent'} ne $self->{'filename'})
			and ($self->{'filename'} ne '1')) {
			$rt .= FAQ::OMatic::button(
				FAQ::OMatic::makeAref('moveItem', {@fixfn}),
					"Move $whatAmI")."\n";
		}

		# Create new children
		if (defined $self->{'directoryHint'}) {
			$rt .= FAQ::OMatic::button(
				FAQ::OMatic::makeAref('addItem',
					{'_insert'=>'answer', @fixfn}),
					"New Answer")."\n";
			$rt .= FAQ::OMatic::button(
				FAQ::OMatic::makeAref('addItem',
					{'_insert'=>'category', @fixfn}),
					"New Subcategory")."\n";
		}

		$rt .= $FAQ::OMatic::Appearance::editEnd."\n";
		$needbr = 1;

		# Allow user to insert a part before any other
		$rt .= "<br>"
			.$FAQ::OMatic::Appearance::editStart
			#."Edit Part: "
			.FAQ::OMatic::button(FAQ::OMatic::makeAref('editPart',
				{'partnum'=>'-1','_insertpart'=>'1',@fixfn}),
				"Insert Text Here")
			.$FAQ::OMatic::Appearance::editEnd."\n";
	}

	my $partnum = 0;
	my @authorList = ();	# for AttributionsTogether
	foreach $part (@{$self->{'Parts'}}) {
		$rt .= $part->displayHTML($self, $partnum, $params);
		push @authorList, @{ $part->{'Author'} };
		++$partnum;
	}

	my $needbr = 1;	# this is a hack to straighten out the fact that half
					# the time I put <br>'s after stuff, and half before.
					# This is an attempt to make the spacing come out right.
					# I should probably come up with a consistent pattern,
					# if possible.

	# AttributionsTogether displays all attributions for any part in
	# this item together at the bottom of the item to reduce clutter.
	if ($self->{'AttributionsTogether'} and 
		($params->{'showAttributions'} ne 'hide') and
		($params->{'showAttributions'} ne 'all')) {
		my %authorHash = map { ($_,1) } (@authorList);
		$rt .= "<i>".join(", ",
			map { "<a href=\"mailto:$_\">$_</a>" } (sort keys %authorHash)
			)."</i><br>\n";
		$needbr = 0;
	}

	if ($params->{'showLastModified'} and $self->{'LastModified'}) {
		$rt .= "<br>" if ($needbr);
		$rt .= "<i>".$self->{'LastModified'}."</i>\n";
		$needbr = 1;
	}

	## recurse on children
	my $dirPart = $self->getDirPart();
	if ($params->{'recurse'} and defined($dirPart)) {
		my $filei;
		my $itemi;
		foreach $filei ($dirPart->getChildren()) {
			$itemi = new FAQ::OMatic::Item($filei);
			$rt .= $itemi->displayCoreHTML($params);
		}
	}

	return $rt;
}

sub displayHTML {
	my $self = shift;
	my $params = shift;	# ref to hash of display params
	my $rt = "";

	$rt .= $self->displayCoreHTML($params);

	$rt .= FAQ::OMatic::Appearance::itemEnd($params);


	my $useTable = not $params->{'simple'};
	$rt.="<table>\n" if $useTable;

	$rt.= $self->displaySiblings($params);

#### -- now defunct code -- from how I used to control appearance/search
#### options with a menu rather than a separate page.
#	if (0 and (not $params->{'suppressControls'})) {
#		## Searching
#		$rt.="<tr><td valign=top align=right>\n" if $useTable;
#		$rt .= FAQ::OMatic::makeAref('search', {}, 'GET');
#		$rt .= "<input type=\"submit\" name=\"_submit\" "
#			."value=\"Search for\">\n";
#		$rt.="</td><td valign=top align=left>\n" if $useTable;
#		$rt .= "<input type=\"text\" name=\"_search\"> matching\n";
#		$rt .= "<select name=\"_minMatches\">\n";
#		$rt .= "<option value=\"\">all\n";
#		$rt .= "<option value=\"1\">any\n";
#		$rt .= "<option value=\"2\">two\n";
#		$rt .= "<option value=\"3\">three\n";
#		$rt .= "<option value=\"4\">four\n";
#		$rt .= "<option value=\"5\">five\n";
#		$rt .= "</select>\n";
#		$rt .= "words.\n";
#		$rt .= "</form>\n";
#		$rt.="</td></tr>\n" if $useTable;
#	
#		## Recent documents
#		$rt.="<tr><td valign=top align=right>\n" if $useTable;
#		$rt .= FAQ::OMatic::makeAref('recent',
#				{'showLastModified'=>'1'}, 'GET');
#		$rt .= "<input type=\"submit\" name=\"_submit\" "
#			."value=\"Show documents\">\n";
#		$rt.="</td><td valign=top align=left>\n" if $useTable;
#		$rt .= " modified in the last \n";
#		$rt .= "<select name=\"_duration\">\n";
#		$rt .= "<option value=\"1\">day.\n";
#		$rt .= "<option value=\"2\">two days.\n";
#		$rt .= "<option value=\"3\">three days.\n";
#		$rt .= "<option value=\"7\" SELECTED>week.\n";
#		$rt .= "<option value=\"14\">fortnight.\n";
#		$rt .= "<option value=\"31\">month.\n";
#		$rt .= "</select>\n";
#		$rt .= "</form>\n";
#		$rt.="</td></tr>\n" if $useTable;
#	
#		## User switches:
#		$rt.="<tr><td valign=top align=right>\n" if $useTable;
#		$rt.=FAQ::OMatic::makeAref('faq', {}, 'GET')
#			."\n"
#			."<input type=submit name=\"appearance\" "
#			."value=\"Change Appearance:\">\n";
#		$rt.="</td><td valign=top align=left>\n" if $useTable;
#		$rt.="<select name=\"theChange\">\n";
#		$rt .= "<option value=\"\">( choose one )</option>\n";
#		$rt .= ($params->{'recurse'})
#			?	"<option value=\"recurseEQUALS\">"
#				."Show Only This Item</option>\n"
#			:	"<option value=\"recurseEQUALS1\">"
#				."Show All Items Below Here</option>\n";
#		$rt .= ($params->{'simple'})
#			?	"<option value=\"simpleEQUALS\">"
#				."Use Fancy HTML</option>\n"
#			:	"<option value=\"simpleEQUALS1\">"
#				."Use Simple HTML</option>\n";
#		$rt .= ($params->{'showModerator'})
#			?	"<option value=\"showModeratorEQUALS\">"
#				."Hide Moderator</option>\n"
#			:	"<option value=\"showModeratorEQUALS1\">"
#				."Show Moderator</option>\n";
#		$rt .= ($params->{'showLastModified'})
#			?	"<option value=\"showLastModifiedEQUALS\">"
#				."Hide Modification Date</option>\n"
#			:	"<option value=\"showLastModifiedEQUALS1\">"
#				."Show Modification Date</option>\n";
#		if ($params->{'showAttributions'} ne 'hide') {
#			$rt .= "<option value=\"showAttributionsEQUALShide\">"
#				."Hide Attributions</option>\n";
#		}
#		if ($params->{'showAttributions'} ne '') {
#			$rt .= "<option value=\"showAttributionsEQUALS\">"
#				."Default Attributions</option>\n";
#		}
#		if ($params->{'showAttributions'} ne 'all') {
#			$rt .= "<option value=\"showAttributionsEQUALSall\">"
#				."Show All Attributions</option>\n";
#		}
#		$rt.="</select>\n"
#			."</form>\n";
#		$rt.="</td></tr>\n" if $useTable;
#	
#		## Show Editing Commands button
#		$rt.="<tr><td valign=top align=right>\n" if $useTable;
#		$rt .= FAQ::OMatic::makeAref(FAQ::OMatic::commandName(),
#			{}, 'GET');
#		if ($params->{'showEditCmds'}) {
#			$rt.="<input type=\"submit\" name=\"appearance\" "
#				."value=\"Hide Editing Commands\">\n";
#			$rt.="<input type=\"hidden\" name=\"theChange\" "
#				."value=\"showEditCmdsEQUALS\">\n";
#		} else {
#			$rt.="<input type=\"submit\" name=\"appearance\" "
#				."value=\"Show Editing Commands\">\n";
#			$rt.="<input type=\"hidden\" name=\"theChange\" "
#				."value=\"showEditCmdsEQUALS1\">\n";
#		}
#		$rt.="</form>\n";
#		$rt.="</td><td valign=top align=left>\n" if $useTable;
#		$rt.="</td></tr>\n" if $useTable;
#	}

	$rt.="</table>\n" if $useTable;

	return $rt;
}

sub permissionBox {
	my $self = shift;
	my $perm = shift;
	my $rt = "<select name=\"_$perm\">\n";
	my $i;

	my @permDesc = ('The moderator');
	push @permDesc, FAQ::OMatic::Groups::getGroupNameList();
	push @permDesc,
				('Authenticated users',
				'Users giving their names', 
				'Whoever can for my parent,');
	my @permNum = (7);
	push @permNum, FAQ::OMatic::Groups::getGroupCodeList();
	push @permNum, (5, 3, '');
	#'Because I never ask, people are anonymous when they',
	# mode 1 (allowing anonymous) always succeeds, and therefore never
	# even prompts the user for an ID (to bump them at least to level 3),
	# so there's no way for a user to offer their ID at all! (Unless they
	# try to do some more-protected thing first.) Therefore, I've hidden
	# that option, since it almost never makes sense (unless your site
	# would rather not have to even ask, at the expense of any useful
	# info in the attributions fields.)

	for ($i=0; $i<@permNum; $i++) {
		$rt .= "<option value=\"$permNum[$i]\"";
		$rt .= " SELECTED" if ($self->{$perm} eq $permNum[$i]);
		$rt .= ">$permDesc[$i]\n";
	}
	$rt .= "</select>\n";
	return $rt;
}

sub displayItemEditor {
	my $self = shift;
	my $params = shift;
	my $cgi = shift;
	my $rt = ""; 	# return text

	if ($params->{'_insert'} eq 'category') {
		$rt .= "New Category\n";
	} elsif ($params->{'_insert'} eq 'answer') {
		$rt .= "New Answer\n";
	} else {
		$rt .= "Editing item <b>".$self->getTitle()."</b>\n";
	}
	$rt .= FAQ::OMatic::makeAref('submitItem',
		{'_insert'=>$params->{'_insert'}}, POST);

	# Title
	$rt .= "<br>Title:<br><input type=text name=\"_Title\" value=\""
			.$self->getTitle()."\" size=60>\n";

	# Reorder parts
	if ($self->numParts() > 1) {
		$rt .= "<p>New Order for Text Parts:";
		$rt .= "<br><input type=text name=\"_partOrder\" value=\"";
		my $i;
		for ($i=0; $i<$self->numParts(); $i++) {
			$rt .= "$i ";
		}
		$rt .= "\" size=60>\n";
	}

	# AttributionsTogether
	$rt .= "<p><input type=checkbox name=\"_AttributionsTogether\"";
	$rt .= "CHECKED" if $self->{'AttributionsTogether'};
	$rt .= "> Show attributions from all parts together at bottom\n";

	if ((not defined $self->{'directoryHint'})
		and (not $params->{'_insert'})) {
		# we hide this on initial inserts, because it serves to confuse, and
		# they can always come back here.
		$rt .= "<p><input type=checkbox name=\"_addDirectory\">"
			." Add a directory part to turn this answer item into "
			."a category item.\n";
	}

	my $showModOptions = 0;
	if ($params->{'modOptions'}) {
		# don't show moderator options unless user can see them.
		# check nicely first so we can turn off modOptions flag
		# to avoid locking the user out of the edit screen.
		if (FAQ::OMatic::Auth::checkPerm($self, 'PermModOptions')) {
			delete $params->{'modOptions'};	# avoid lock-out,
				# which would happen if user couldn't authenticate
				# as the moderator, but had this flag following him around.
				# Downside is that user will have to click "show mod opts"
				# again after auth to see them. Wah.
			if ($params->{'_fromEdit'}) {
				# if user is coming from edit page already, offer him
				# the chance to upgrade his permissions. Otherwise,
				# silently hide the mod options, and he can click
				# to try getting them back.
				my $rd = FAQ::OMatic::Auth::ensurePerm($self, 'PermModOptions',
					FAQ::OMatic::commandName(), $cgi, 0, 'modOptions');
				if ($rd) { print $rd; exit 0; }
			}
		} else {
			$showModOptions = 1;
		}
	}

	if ($showModOptions) {
		# Moderator
		$rt .= "<p>Moderator: <i>(leave blank to inherit from parent item)</i>"
				."<br><input type=text name=\"_Moderator\" value=\""
				.($self->{'Moderator'}||'')."\" size=60>\n";
	
		$rt .= "<br>Send mail to the moderator "
				."<select name=\"_MailModerator\">\n";
		$rt .= "<option value=\"1\"";
		$rt .= " SELECTED" if ($self->{'MailModerator'} eq '1');
		$rt .= "> whenever someone modifies this item.\n";
		$rt .= "<option value=\"0\"";
		$rt .= " SELECTED" if ($self->{'MailModerator'} eq '0');
		$rt .= "> never.\n";
		$rt .= "<option value=\"\"";
		$rt .= " SELECTED" if (not defined $self->{'MailModerator'});
		$rt .= "> whenever my parent would.\n";
		$rt .= "</select>\n";
	
		# Permission info
		$rt .= "<br>";
		$rt .= $self->permissionBox('PermAddPart');
		$rt .= " may add new parts to me.\n";
	
		$rt .= "<br>";
		$rt .= $self->permissionBox('PermEditPart');
		$rt .= " may edit and delete existing parts from me.\n";
	
		$rt .= "<br>";
		$rt .= $self->permissionBox('PermEditItem');
		$rt .= " may edit my item configuration, "
			."including adding and moving subitems.\n";

		$rt .= "<br>";
		$rt .= $self->permissionBox('PermModOptions');
		$rt .= " may edit these Moderator options.\n";

		$rt .= "<p>".FAQ::OMatic::button(
			FAQ::OMatic::makeAref(FAQ::OMatic::commandName(),
				{'modOptions'=>''}), "Hide Moderator Options")."\n";
	} else {
		$rt .= "<p>".FAQ::OMatic::button(
			FAQ::OMatic::makeAref(FAQ::OMatic::commandName(),
					{'modOptions'=>'1', '_fromEdit'=>1}),
				"Show Moderator Options")."\n";
	}

	# Submit
	$rt .="<br><input type=submit name=\"_submit\" value=\"Submit Changes\">\n";
	$rt .= "<input type=reset name=\"_reset\" value=\"Revert\">\n";
	$rt .= "<input type=hidden name=\"_zzverify\" value=\"zz\">\n";
		# this lets the submit script check that the whole POST was
		# received.
	$rt .= "</form>\n";
	$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('faq', {}),
			"Cancel and return to FAQ");

	return $rt;
}

sub setProperty {
	my $self = shift;
	my $property = shift;
	my $value = shift;

	if ($value) {
		$self->{$property} = $value;
	} else {
		delete $self->{$property};
	}
}

sub getDirPart {
	my $self = shift;

	if (defined $self->{'directoryHint'}) {
		return $self->{'Parts'}->[$self->{'directoryHint'}];
	} else {
		return undef;
	}
}

sub makeDirectory {
	# This sub guarantees that this item contains a directory part,
	# creating an empty one if there wasn't already one.
	# It returns the dirpart.
	my $self = shift;

	return $self->getDirPart() if $self->getDirPart();

	my $dirPart = new FAQ::OMatic::Part();
	# should set author for $newPart to user doing this action
	$dirPart->{'Type'} = 'directory';
	$dirPart->{'Text'} = '';
	$dirPart->{'HideAttributions'} = 1;	# directories prefer to have
										# attributions hidden.
	$self->{'directoryHint'} = scalar @{$self->{'Parts'}};
	push @{$self->{'Parts'}}, $dirPart;

	return $dirPart;
}

sub addSubItem {
	my $self = shift;
	my $subfilename = shift;
	my $dirPart;

	my $subitem = new FAQ::OMatic::Item($subfilename);
	if ($subitem->isBroken()) {
		FAQ::OMatic::gripe('problem', "File $subfilename seems broken.");
	}

	$self->makeDirectory()->mergeDirectory($subfilename);
}

sub removeSubItem {
	my $self = shift;
	my $subfilename = shift; # if omitted, this just removes an empty
							 # directory part.

	my $dirPart = $self->getDirPart();
	if (not defined $dirPart) {
		FAQ::OMatic::gripe('panic', "FAQ::OMatic::Item::removeSubItem(): I ("
			.$self->{'filename'}
			.") don't have a directoryHint! How did that happen?");
	}
	if ($subfilename) {
		$dirPart->unmergeDirectory($subfilename);
	}
	if ($dirPart->{'Text'} =~ m/^\s*$/s) {
		splice @{$self->{'Parts'}}, $self->{'directoryHint'}, 1;
		delete $self->{'directoryHint'};
	}
}

sub extractWordsFromString {
	my $string = shift;
	my $filename = shift;
	my $words = shift;

	$string =~ s/'//g;			# apostrophes are not word breaks
	$string =~ tr/[A-Z]/[a-z]/;	# searches are case-insensitive
	my @wordlist = ($string =~ m/($FAQ::OMatic::Intl::wordchars+)/gso);

	# Associate words with this file in index
	my $i;
	foreach $i (@wordlist) {
		# do it for every prefix, too
		while ($i) {
			$words->{$i}{$filename} = 1;
			$i = substr($i, 0, length($i)-1);
		}
	}
}

sub extractWords {
	my $self = shift;
	my $words = shift;

	extractWordsFromString($self->getTitle(), $self->{'filename'}, $words);

	my $part;
	foreach $part (@{$self->{'Parts'}}) {
		extractWordsFromString($part->{'Text'}, $self->{'filename'}, $words);
	}
	
	# recurse (turned off -- see buildSearchDB)
	# my $dirPart = $self->getDirPart();
	# if (defined $dirPart) {
	# 	my $filei;
	# 	my $itemi;
	# 	foreach $filei ($dirPart->getChildren()) {
	# 		$itemi = new FAQ::OMatic::Item($filei);
	# 		$itemi->extractWords($words);
	# 	}
	# }
}

sub rightEnd {
	my $string = shift;
	my $amount = shift;
	if ($amount >= length($string)) {
		return $string;
	} else {
		return substr($string,length($string)-$amount,$amount);
	}
}

sub displaySearchContext {
	my $self = shift;
	my $params = shift;
	my $rt = "";
	my $text = "";
	my $context = "";
	my @pieces=(), @parts=();
	my @hw;
	my $wordmatch;
	my $i;
	my $count;

	# start with a title that's a link
	$rt = FAQ::OMatic::makeAref("faq",
		{	'file'				=>	$self->{'filename'},
			'_highlightWords'	=>	join(' ', @{$params->{'_searchArray'}})
		}
	)
			.FAQ::OMatic::highlightWords($self->getTitle(),$params)."</a>";

	# add some context
	# get all of my parts' text
	$text = join(" ",
		map { $_->{'Text'} } @{$self->{'Parts'}});

	# contstruct the wordmatch regular expression that matches any
	# of the search words, with apostrophes interspersed.
	@hw = @{ $params->{'_searchArray'} };
	@hw = map { FAQ::OMatic::lotsOfApostrophes($_) } @hw;
	$wordmatch = '(\W'.join(')|(',@hw).')';

	$text = ' '.$text;	# ensure we match at beginning of text (because of \s)

	@pieces = split(/$wordmatch/gis, $text);	# break into pieces
	# save only the defined parts, so it alternates between match and nonmatch
	foreach $i (@pieces) {
		if (defined $i) {
			push @parts, $i;
		}
	}

	# now all even @parts are non-match, all odd are matches
	# whenever an even part is shorter than 20 characters, merge
	# it and its neighbors.
	for ($i=2; ($i<scalar(@parts)-1); $i+=2) {
		if (length($parts[$i]) < 20) {
			splice(@parts, $i-1, 3, $parts[$i-1].$parts[$i].$parts[$i+1]);
			$i = $i - 2;
		}
	}

	for ($i=1, $count=0; $i<scalar @parts and $count<4; $i+=2, $count++) {
		my $ls = ($i-1 >= 0) ? $parts[$i-1] : '';
		my $rs = ($i+1 < scalar(@parts)) ? $parts[$i+1] : '';
		my $ltrunc = (($i>1) or length($ls)>40);
		my $rtrunc = (($i<scalar(@parts)-2) or length($rs)>40);
		$context.='<br>'
			.FAQ::OMatic::entify(
				($ltrunc ? '...' : '')
				.rightEnd($ls,40)
				.' '
				.$parts[$i]
				.substr($rs,0,40)
				.($rtrunc ? '...' : ''));
	}

	# highlight the matching words
	$rt .= "<br>".FAQ::OMatic::highlightWords($context,$params);

	return $rt;
}

sub notifyModerator {
	my $self = shift;
	my $cgi = shift;
	my $didWhat = shift;
	my $changedPart = shift;

	my $mail = FAQ::OMatic::Auth::getInheritedProperty($self, 'MailModerator');
	return if ($mail ne '1');	# didn't want mail anyway

	my $moderator = FAQ::OMatic::Auth::getInheritedProperty($self, 'Moderator');
	return if (not $moderator =~ m/\@/);	# some non-address

	my $msg = '';
	my ($id,$aq) = FAQ::OMatic::Auth::getID();

	$msg .= "[This is a message about the Faq-O-Matic items you moderate.]\n\n";
	$msg .= "Who:      $id\n";
	$msg .= "Item:     ".$self->getTitle()."\n";
	$msg .= "File:     ".$self->{'filename'}."\n";
	my $url = FAQ::OMatic::makeAref('faq', {'file'=>$self->{'filename'}},
						'url', 0, 'blastAll');
	$msg .= "URL:      ".$url."\n";
	$msg .= "What:     ".$didWhat."\n";

	if (defined $changedPart) {
		$msg .= "New text:\n";
		my $newtext = $self->getPart($changedPart)->{'Text'};
		$newtext =~ s/^/> /mg;
		$msg .= "$newtext\n";
	}

	$msg .= "\nAs always, thanks for your help maintaining the FAQ.\n";

	# make sure $moderator isn't a trick string
	$moderator =~ /([\w-.]+\@[\w-.]+)/;

	# send the mail to the moderator
	FAQ::OMatic::sendEmail($moderator, "Faq-O-Matic Moderator Mail", $msg);
}

# returns (prev,next) -- handles to FAQ::OMatic::Items, one before and one after this
# item in the parent's list
sub getSiblings {
	my $self = shift;
	my ($prev, $next);

	my $parent = $self->getParent();
	return (undef,undef) if (not $parent);
	my $pdpart = $parent->getDirPart();
	return (undef,undef) if (not $pdpart);
	my @siblings = $pdpart->getChildren();
	my $i;
	for ($i=0; $i<@siblings; $i++) {
		if ($siblings[$i] eq $self->{'filename'}) {
			$prev = ($i>0) ? $siblings[$i-1] : undef;
			$next = ($i<@siblings-1) ? $siblings[$i+1] : undef;
			return ($prev,$next);
		}
	}
	return (undef,undef);
}

sub whatAmI {
	my $self = shift;
	return (defined $self->{'directoryHint'})
			? 'Category'
			: 'Answer';
}

sub updateDirectoryHint {
	my $self = shift;

	my $i;
	for ($i=0; $i<$self->numParts(); $i++) {
		if ($self->getPart($i)->{'Type'} eq 'directory') {
			$self->{'directoryHint'} = $i;
			return;
		}
	}
	delete $self->{'directoryHint'};
}

sub clone {
	# return a deep-copy of myself
	my $self = shift;

	my $newitem = new FAQ::OMatic::Item();

	# copy all of prototype's attributes
	my $key;
	foreach $key (keys %{$self}) {
		next if ($key eq 'Parts');
		if (ref $self->{$key}) {
			# guarantee this is a deep copy -- if we missed
			# a ref, complain.
			FAQ::OMatic::gripe('error', "clone: prototype has key '$key' "
				."that is a reference (".$self->{$key}.").");
		}
		$newitem->{$key} = $self->{$key};
	}

	# copy all the parts...
	my $i;
	for ($i=0; $i<$self->numParts(); $i++) {
		push(@{$newitem->{'Parts'}}, $self->getPart($i)->clone());
	}

	$newitem->updateDirectoryHint();

	return $newitem;
}

'true';
