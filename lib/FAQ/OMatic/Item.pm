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
use FAQ::OMatic::Words;
use FAQ::OMatic::Help;

%itemCache = ();	# contains (filename => item ref) mappings

sub new {
	my ($class) = shift;
	my ($arg) = shift;	# what file the item data lives in
	my ($dir) = shift;	# what dir we should look in for the item data
						# (default $FAQ::OMatic::Config::itemDir)
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
		if ($item->{'filename'}) {
			$itemCache{$item->{'filename'}} = $item;
		}
	} else {
		$item->setProperty('Title', 'New Item');
	}

	# ensure every item has a sequence number.
	# sequence numbers are used to:
	# 1. detect conflicting edits. We discard the later submission;
	# no attempt is made to prevent simultaneous edits in the first place.
	# The assumption is that simultaneous edits are uncommon, and stale
	# locks would probably be less convenient than occasional conflicts.
	# 2. incremental transfers for mirrored faqs
	$item->{'SequenceNumber'} = 0 if (not defined($item->{'SequenceNumber'}));

	return $item;
}

sub loadFromFile {
	my $self = shift;
	my $filename = shift;
	my $dir = shift;		# optional -- almost always itemDir

	# untaint user input (so they can't express
	# a file of ../../../../../../etc/passwd)
	if (not $filename =~ m/^([\w-.]*)$/) {
		# if taint check fails, just return a bad item, rather
		# than implying that there really is an item with the funny name
		# supplied.
		
		delete $self->{'Title'};
		return;
	} else {
		$filename = $1;
	}

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

	$self->loadFromFileHandle(\*FILE);

	close(FILE);

	return $self;
}

sub loadFromFileHandle {
	my $self = shift;
	my $fh = shift;

	# process item headers
	while (<$fh>) {
		chomp;
		my ($key,$value) = FAQ::OMatic::keyValue($_);
		if ($key eq 'Part') {
			my $newPart = new FAQ::OMatic::Part;
			$newPart->loadFromFile($fh, $self->{'filename'}, $self,
					scalar @{$self->{'Parts'}});	# partnum
			push @{$self->{'Parts'}}, $newPart;
		} elsif ($key eq 'LastModified') {
			# Transparently update older items with LastModified keys
			# to use new LastModifiedSecs key.
			my $secs = compactDateToSecs($value);	# turn back into seconds
			$self->{'LastModifiedSecs'} = $secs;
		} elsif ($key =~ m/-Set$/) {
			if (not defined($self->{$key})) {
				$self->{$key} = new FAQ::OMatic::Set;
			}
			$self->{$key}->insert($value);
		} elsif ($key ne '') {
			$self->setProperty($key, $value);
		} else {
			FAQ::OMatic::gripe('problem',
				"FAQ::OMatic::Item::loadFromFile was confused by this header in file $filename: \"$_\"");
			# this marks the item "broken" so that the save routine will
			# refuse to save this corrupted file out and lose more data.
			delete $self->{'Title'};
			return;
		}
	}

	# We just loaded this item from a file; the title hasn't really
	# changed. So we unset that property (that was set when we read
	# the 'Title:' header), so that we can detect when an item's title
	# actually does change.
	$self->setProperty('titleChanged', '');

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
	# TODO: should we really be storing times in GMT, since it's not
	# TODO: like time zones mean much here?
	my $ampm = "am";
	if ($hr >= 12) {
		$hr -= 12;
		$ampm = "pm";
	}
	$hr = 12 if ($hr == 0);

	return sprintf("%04d-%03s-%02d %2d:%02d%s",
			$yr+1900, $monthMap[$mo], $day, $hr, $min, $ampm);
}

# undo the previous transformation
# TODO: this is only used (I think) for updating LastModified: fields
# TODO: to LastModifiedSecs: fields. It could eventually be discarded.
sub compactDateToSecs {
	my $cd = shift;
	my ($yr,$mo,$dy,$hr,$mn,$ampm) =
		($cd =~ m/(\d+)-([a-z]+)-(\d+) +(\d+):(\d+)([ap])m/i);
	if (not defined $ampm) {
		return -1;		# can't parse string
	}
	for ($month_i=0; $month_i<12; $month_i++) {
		if ($mo eq $monthMap[$month_i]) {
			$mo = $month_i;		# notice months run 0..11
			last;
		}
	}
	if ($month_i == 12) {
		return -1;				# can't parse month
	}
	$hr = 0 if ($hr == 12);		# noon/midnight
	$hr += 12 if ($ampm eq 'p');	# am/pm
	$yr -= 1900;	 			# year is biased in struct

	require Time::Local;
	# LastModified: keys were represented in local time, not GMT.
	return Time::Local::timelocal(0, $mn, $hr, $dy, $mo, $yr);
}

sub saveToFile {
	my $self = shift;
	my $filename = shift || '';
	my $dir = shift || '';			# optional -- almost always itemDir
	my $lastModified = shift || '';	# optional -- normally today.
									# 'noChange' is allowed; used when
									# regenerating files (mod date hasn't
									# really changed.).
	my $updateAllDependencies = shift || '';	# optional. only specified
						# by maintenance when regenerating all dependencies.
# TODO: I don't think maintenance.pm really needs to actually write the
# TODO: item files when regenerating dependencies/HTML cache files.
# TODO: If not, that part of saveToFile should be factored out, so we're
# TODO: not really writing out item/ files.

	$dir = $FAQ::OMatic::Config::itemDir if (not $dir);

	if ($self->isBroken()) {
		FAQ::OMatic::gripe('error', "Tried to save a broken item to $filename.");
	}

	$filename =~ m/([\w-.]*)/;	# Untaint filename
	$filename = $1;

	if (not $filename) {
		$filename = $self->{'filename'};
	} else {
		# change of filename (from a new, anonymous item)
		$self->{'filename'} = $filename;
	}

	if ($dir eq $FAQ::OMatic::Config::itemDir) {
		# compute new IDependOn-Set -- the items whose titles we depend
		# on.
		# copy old list first, so we have something to compare new list to
		$self->{'oldIDependOn-Set'} =
			$self->getSet('IDependOn-Set')->clone();
		my $newSet = new FAQ::OMatic::Set;
		# I depend on any item I link to, which includes any explicit
		# (faqomatic:...) links in the text, ...
		my $parti;
		for ($parti=0; $parti<$self->numParts(); $parti++) {
			my $part = $self->getPart($parti);
			$newSet->insert($part->getLinks());
		}
		# ...and any implicit links to my ancestors or to siblings
		my ($parentTitles,$parentNames) = $self->getParentChain();
		$newSet->insert(@{$parentNames});
		$newSet->insert(grep {defined($_)} $self->getSiblings());
		# ...and any bags.
		$newSet->insert(map { "bags.".$_ } $self->getBags());

		$self->{'IDependOn-Set'} = $newSet;
	}

	# note last modified date in item itself
	if ($lastModified ne 'noChange') {
		# Time now stored in file in Unix-style seconds.
		# (but as an ASCII integer, which isn't 31-bit limited,
		# so I'm sure you'll be pleased to note that we're
		# Y2.038K-compliant. :v)
		$lastModified = time() if ($lastModified eq '');
		$self->{'LastModifiedSecs'} = $lastModified;
		# $self->{'LastModified'} = compactDate($lastModified);
	}

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
		} elsif ($key =~ m/-Set$/) {
			my $a;
			foreach $a ($self->getSet($key)->getList()) {
				print FILE "$key: $a\n";
			}
		} else {
			my $value = $self->{$key};
			$value =~ s/[\n\r]/ /g;	# don't allow CRs in a single-line field,
									# that would corrupt the file format.
			print FILE "$key: $value\n";
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

	# For item files (not .smry files, which also use the FAQ::OMatic::Item
	# mechanism for storage), do these things:
	# 1. Perform RCS ci so we can always get the files back in the face
	#    of net-creeps.
	# 2. Clear the search hint so we know to regenerate the search index
	# 3. Rewrite the static cached HTML copy
	if ($dir eq $FAQ::OMatic::Config::itemDir) {
		## Tell RCS who we are
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
	# RCS has a habit of making item files read-only by the user -- fix that
	# (umask might also be uptight)
	if (not chmod(0644, "$dir/$filename")) {
		FAQ::OMatic::gripe('problem', "chmod($dir/$filename) failed: $!");
	}

	# if $lastModified was specified, correct filesystem mtime
	# (If not specified, the fs mtime is already set to 'now',
	# which is correct.)
	if ($lastModified) {
		utime(time(),$self->{'LastModifiedSecs'},"$dir/$filename");
	}

	# As I was saying, ...
	# 2. Clear the search hint so we know to regenerate the search index
	# 3. Rewrite the static cached HTML copy
	if ($dir eq $FAQ::OMatic::Config::itemDir) {
		unlink("$FAQ::OMatic::Config::metaDir/freshSearchDBHint");

		$self->writeCacheCopy();
		if ($self->{'titleChanged'}) {
			# this item's title has changed:
			# update the cache for any items that refer to this one (and
			# thus have this one's title in their cached HTML)
			foreach $dependent (getDependencies($self->{'filename'})) {
				my $dependentItem = new FAQ::OMatic::Item($dependent);
				$dependentItem->writeCacheCopy();
			}
		}

		# rewrite .dep files (items that contain HeDependsMe-Sets)
		my $oidos = $self->getSet('oldIDependOn-Set');
		my $nidos = $self->getSet('IDependOn-Set');
		my @removeList = ($oidos->subtract($nidos))->getList();
		my @addList;
		if ($updateAllDependencies) {
			@addList = $nidos->getList();
		} else {
			@addList = ($nidos->subtract($oidos))->getList();
		}
		my $itemName;
		foreach $itemName (@removeList) {
			adjustDependencies('remove', $itemName, $self->{'filename'});
		}
		foreach $itemName (@addList) {
			adjustDependencies('insert', $itemName, $self->{'filename'});
		}
	}
}

sub getDependencies {
	my $filename = shift;
	my $depItem = loadDepItem($filename);
	return $depItem->getSet('HeDependsOnMe-Set')->getList();
}

sub loadDepItem {
	my $itemName = shift;

	my $depFile = "$itemName.dep";
	my $depItem = new FAQ::OMatic::Item($depFile,
			$FAQ::OMatic::Config::cacheDir);
	$depItem->setProperty('Title', 'Dependency List');
			# in case $depItem was new
	return $depItem;
}

sub adjustDependencies {
	my $what = shift;		# 'insert' or 'remove'
	my $itemName = shift;
	my $targetName = shift;

	my $depItem = loadDepItem($itemName);
	my $hdos = $depItem->getSet('HeDependsOnMe-Set');
	if ($what eq 'insert') {
		$hdos->insert($targetName);
	} else {
		$hdos->remove($targetName);
	}
	$depItem->setProperty('HeDependsOnMe-Set', $hdos);
			# in case $hdos was new
	my $depFile = "$itemName.dep";
	$depItem->saveToFile($depFile,
			$FAQ::OMatic::Config::cacheDir);
}

# For explicit faqomatic: links, the dependency mechanism is automatic:
# the link can't change without the item itself changing, so when the
# item gets written out, the cache and dependencies for it are up-to-date.
#
# For parent links, the dependency mechanism still works -- if a parent
# moves or changes its name (or this item moves, which is an operation on
# its parent), the old parent had to get written, and this item knew it
# was dependent on that parent, so this item gets rewritten, too, and has
# its dependencies updated, at which point it detects any new parent.
#
# But for sibling links, this item has no way of discovering (via
# dependencies) when those links change. Whenever a category changes its
# directory part list, it has also changed the sibling links for some
# of its children. In any case like that, it's the parent's responsibility
# to rewrite all of its children, so their dependencies and caches
# can be recomputed.
sub updateAllChildren {
	my $self = shift;

	foreach $filei ($self->getChildren()) {
		$itemi = new FAQ::OMatic::Item($filei);
		$itemi->writeCacheCopy();
	}
}

sub getChildren {
	my $self = shift;

	my $dirPart = $self->getDirPart();
	if (defined($dirPart)) {
		return $dirPart->getChildren();
	}
	return ();
}

sub getBags {
	my $self = shift;

	# remove duplicates but keep order using a Set
	my $bagset = new FAQ::OMatic::Set('keepOrdered');
	my $i;
	for ($i=0; $i<$self->numParts(); $i++) {
		$bagset->insert($self->getPart($i)->getBags());
	}

	return $bagset->getList();
}

# Currently meaningful -Sets that can be in an Item:
# HeDependsOnMe-Set: list of items that depend on this item's Title property
# IDependOn-Set: list of items whose titles this item depends upon.
#	it's useful so we can revoke our membership in that item's
#	HeDependsOnMe-Set when we no longer refer to it.

sub getSet {
	my $self = shift;
	my $setName = shift;

	return $self->{$setName} || new FAQ::OMatic::Set;
}

sub writeCacheCopy {
	my $self = shift;

	my $filename = $self->{'filename'};

	if (defined($FAQ::OMatic::Config::cacheDir)
		&& (-w $FAQ::OMatic::Config::cacheDir)) {
		my $staticFilename =
			"$FAQ::OMatic::Config::cacheDir/$filename.html";
		my $params = {'file'=>$self->{'filename'},
					'_fromCache'=>1};
			# this link is coming from inside the cache, so we
			# can use relative links. That's nice if we later
			# wrap up the cache and mail it somewhere.
		my $staticHtml = FAQ::OMatic::pageHeader($params, 'suppressType')
						.$self->displayHTML($params)
						.basicURL($params)
						.FAQ::OMatic::pageFooter($params, 'all', 'isCached');
		if (not open(CACHEFILE, ">$staticFilename")) {
			FAQ::OMatic::gripe('problem',
				"Can't write $staticFilename: $!");
		} else {
			print CACHEFILE $staticHtml;
			close CACHEFILE;
			if (not chmod(0644, $staticFilename)) {
				FAQ::OMatic::gripe('problem',
					"chmod($staticFilename) failed: $!");
			}
		}
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

# returns two lists, the filenames and titles of this item's parent items.
# The list is slightly falsified in that if the topmost ancestor isn't
# '1' (such as 'trash' and 'help000'), we insert '1' as an ancestor.
# That way 'trash' and 'help000's displayed parent chains include links
# to the top of the FAQ, but are not moveable (since they still have no
# real parent, which is how moveItem.pm can tell.)
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

	if ($nextfile ne '1') {
		# insert '1' as extra 'bogus' parent
		my $item1 = new FAQ::OMatic::Item('1');
		push @titles, $item1->getTitle();
		push @filenames, $item1->{'filename'};	# I can guess what this is :v)
	}

	return (\@titles, \@filenames);
}

# same structure as above, but only used to check for a particular parent
sub hasParent {
	my $self = shift;
	my $parentFile = shift;

	my ($nextfile, $nextitem, $thisfile);

	$nextitem = $self;
	$nextfile = $self->{'filename'};
	do {
		return 1 if ($nextfile eq $parentFile);

		$thisfile = $nextfile;
		$nextfile = $nextitem->{'Parent'};
		$nextitem = $nextitem->getParent();
	} while ((defined $nextitem) and (defined $nextfile)
		and ($nextfile ne $thisfile));
	
	return 0;
}

# okay, I guess this displays the neighbors, too...
sub displaySiblings {
	my $self = shift;
	my $params = shift;
	my $rt = '';		# return text
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
		$rt.=FAQ::OMatic::makeAref('-command'=>'faq',
							'-params'=>$params,
							'-changedParams'=>{"file"=>$prevs})
			.FAQ::OMatic::ImageRef::getImageRefCA('-small',
				'border=0', $prevItem->isCategory(), $params)
			."$prevTitle</a>\n";
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
		$rt.=FAQ::OMatic::makeAref('-command'=>'faq',
							'-params'=>$params,
							'-changedParams'=>{"file"=>$nexts})
			.FAQ::OMatic::ImageRef::getImageRefCA('-small',
				'border=0', $nextItem->isCategory(), $params)
			."$nextTitle</a>\n";
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
	my $whatAmI = $self->whatAmI();

	# we'll pass this to makeAref to get file param right in links
	my @fixfn =('file'=>$self->{'filename'});

	$rt .= FAQ::OMatic::Appearance::itemStart($params, $self);

	my $titlebox = "\n\n";	# visual separation for Page Source view
	$titlebox .= "<a name=\"file_"
			.$self->{'filename'}."\">\n";	# link for internal refs

	# prefix item title with a path back to the root, so that user
	# can find his way back up. (This replaces the old "Up to:" line.)
	my ($titles,$filenames) = $self->getParentChain();
	my ($thisTitle) = shift @{$titles};
	my ($thisFilename) = shift @{$filenames};
	my (@parentTitles) = reverse @{$titles};
	my (@parentFilenames) = reverse @{$filenames};
	my $i;
	for ($i=0; $i<@parentTitles; $i++) {
		# all parent icons are necessarily categories, duh. :v)
		$titlebox.=
			FAQ::OMatic::makeAref('-command'=>'faq',
				'-params'=>$params,
				'-changedParams'=>{"file"=>$parentFilenames[$i]})
			.FAQ::OMatic::ImageRef::getImageRef('cat-small',
				'border=0', $params)
			.$parentTitles[$i]
			."</a>:";
	}
	$titlebox.="<br>" if (@parentTitles);
	$titlebox.="<b>$thisTitle</b>";

	$rt.=$titlebox;

	if ($params->{'showModerator'}) {
		my $mod = FAQ::OMatic::Auth::getInheritedProperty($self, 'Moderator');
		$rt .= "<br>Moderator: <a href=\"mailto:$mod\">$mod</a>";
		$rt .= " <i>(inherited from parent)</i>" if (not $self->{'Moderator'});
		$rt .= "\n";
	}

	## Edit commands:
	if ($params->{'showEditCmds'}) {
		$rt .= "<br>";
		$rt .= $FAQ::OMatic::Appearance::editStart;
				#."Edit Item: ";
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'editItem',
					'-params'=>$params,
					'-changedParams'=>{@fixfn}),
			"Edit $whatAmI Title and Options")."\n";

		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'editModOptions',
					'-params'=>$params,
					'-changedParams'=>{@fixfn}),
			"Edit $whatAmI Permissions")."\n";

		# These don't make sense if we're in a special-case item file, such
		# as 'trash'. We'll assume here that items whose file names end in
		# a digit are 'incrementable' and can thus have children.
		# TODO: default system should ship with help000 having moderator-only
		# TODO: permissions to discourage the public from modifying the
		# TODO: help system. This will matter more when the help system
		# TODO: is implemented. :v)
		# THANKS: to Doug Becker <becker@foxvalley.net> for
		# accidentally making a 'trasi' item (perl incremented 'trash' :v)
		# and discovering this problem.
		if ($self->ordinaryItem()) {
			# Duplicate it
			my $dupTitle = ($whatAmI eq 'Answer')
						? "Duplicate Answer"
						: "Duplicate Category as Answer";
			$rt .= FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'addItem',
						'-params'=>$params,
						'-changedParams'=>{'_insert'=>'answer',
					 			'_duplicate'=>$self->{'filename'},
								'file'=>$self->{'Parent'}}
					),
					$dupTitle)."\n";
	
			# Move it (if not at the top)
			if ($self->{'Parent'} ne $self->{'filename'}) {
				$rt .= FAQ::OMatic::button(
						FAQ::OMatic::makeAref('-command'=>'moveItem',
							'-params'=>$params,
							'-changedParams'=>{@fixfn}),
						"Move $whatAmI")."\n";
	
				# Trash it (same rules as for moving)
				$rt .= FAQ::OMatic::button(
						FAQ::OMatic::makeAref('-command'=>'submitMove',
							'-params'=>$params,
							'-changedParams'=>{@fixfn,
								'_newParent'=>'trash'}),
						"Trash $whatAmI")."\n";
			}
	
			# Convert category to answer / answer to category
			# THANKS: to Steve Herber for suggesting pulling this out of
			# THANKS: editPart and putting it here as a distinct command
			# THANKS: for clarity.
			if ($self->isCategory()
					and scalar($self->getChildren())==0) {
				$rt .= FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'submitCatToAns',
							'-params'=>$params,
							'-changedParams'=>{
							  'checkSequenceNumber'=>$self->{'SequenceNumber'},
							  @fixfn}),
						"Convert to Answer")."\n";
			} elsif (not $self->isCategory()) {
				$rt .= FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'submitAnsToCat',
							'-params'=>$params,
							'-changedParams'=>{
							  'checkSequenceNumber'=>$self->{'SequenceNumber'},
							  @fixfn}),
						"Convert to Category")."\n";
			}
	
			# Create new children
			if ($self->isCategory()) {
				# suggestion of adding cat title to reduce confusion is from
				# THANKS: pauljohn@ukans.edu
				my $title = $self->getTitle();
				if (length($title) > 15) {
					$title = substr($title, 0, 12)."...";
				}
				$rt .= FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'addItem',
							'-params'=>$params,
							'-changedParams'=>{'_insert'=>'answer', @fixfn}),
						"New Answer in \"$title\"")."\n";
				$rt .= FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'addItem',
							'-params'=>$params,
							'-changedParams'=>{'_insert'=>'category', @fixfn}),
						"New Subcategory of \"$title\"")."\n";
			}
		}

		$rt .= $FAQ::OMatic::Appearance::editEnd."\n";
		$needbr = 1;

		# Allow user to insert a part before any other
		if ($self->ordinaryItem()) {
			$rt .= "<br>"
				.$FAQ::OMatic::Appearance::editStart
				#."Edit Part: "
				.FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'editPart',
						'-params'=>$params,
						'-changedParams'=>{'partnum'=>'-1',
							'_insertpart'=>'1',
							'checkSequenceNumber'=>$self->{'SequenceNumber'},
							@fixfn}
						),
					"Insert Text Here")
				.$FAQ::OMatic::Appearance::editEnd."\n";
		}
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
	my $attributionsTogether = $self->{'AttributionsTogether'} || '';
	my $showAttributions = $params->{'showAttributions'} || '';
	if ($attributionsTogether and 
		($showAttributions ne 'hide') and
		($showAttributions ne 'all')) {
		my %authorHash = map { ($_,1) } (@authorList);
		$rt .= "<i>".join(", ",
			map { "<a href=\"mailto:$_\">$_</a>" } (sort keys %authorHash)
			)."</i><br>\n";
		$needbr = 0;
	}

	my $showLastModified = $params->{'showLastModified'};
	my $lastModified = $self->{'LastModifiedSecs'};
	# THANKS: Config::showLastModifiedAlways feature was requested by
	# THANKS: parker@austx.tandem.com
	if ($lastModified and
		($showLastModified or $FAQ::OMatic::Config::showLastModifiedAlways)) {
		$rt .= "<br>" if ($needbr);
		$rt .= "<i>".compactDate($self->{'LastModifiedSecs'})."</i>\n";
		$needbr = 1;
	}

	## recurse on children
	if ($params->{'recurse'} or $params->{'_recurse'}) {
		my $filei;
		my $itemi;
		foreach $filei ($self->getChildren()) {
			$itemi = new FAQ::OMatic::Item($filei);
			$rt .= $itemi->displayCoreHTML($params);
		}
	}

	return $rt;
}

sub ordinaryItem {
	my $self = shift;
	return ($self->{'filename'} =~ m/\d$/);
}

sub displayHTML {
	my $self = shift;
	my $params = shift;	# ref to hash of display params
	my $rt = "";

	# signal to aref generator that some internal links are
	# possible. (only signal this when recursing to save effort otherwise)
	if ($params->{'recurse'} or $params->{'_recurse'}) {
		$params->{'_recurseRoot'} = $self->{'filename'};
	}

	$rt .= $self->displayCoreHTML($params);

	# turn #internal links off after the items are displayed.
	# Otherwise they mess up the bottom link bar.
	# (is there a general way to solve that problem?)
	delete $params->{'_recurseRoot'};

	$rt .= FAQ::OMatic::Appearance::itemEnd($params);


	my $useTable = not $params->{'simple'};
	$rt.="<table>\n" if $useTable;

	$rt.= $self->displaySiblings($params);

	$rt.="</table>\n" if $useTable;

	$rt.=FAQ::OMatic::Help::helpFor($params,
		'How can I contribute to this FAQ?', "<br>");

	return $rt;
}

sub basicURL {
	my $params = shift;

	return '' if ($params->{'file'} =~ m/^help/);
	
	my %killParams = %{$params};
	delete $killParams{'file'};
	delete $killParams{'recurse'} if ($params->{'recurse'});
	my $i; foreach $i (keys %killParams) { $killParams{$i} = ''; }

	# TODO: We have always had the "This document is:"
	# TODO: refer to the CGI. I liked that because it let me fiddle
	# TODO: with the cache layout (after all, it changed in 2.604.)
	# TODO: But others have asked to totally hide the presence of the CGI,
	# TODO: in which case we should *only* display cache URLs here.
	# TODO: Or leave this line out altogether.

	my $url = FAQ::OMatic::makeAref('-command'=>'faq',
				'-params' => $params,
				'-changedParams'=>\%killParams,
				'-thisDocIs'=>1,
				'-refType'=>'url');

	return "This document is: <i>$url</i><br>\n";
}

sub permissionBox {
	my $self = shift;
	my $perm = shift;

	my $rt = "<select name=\"_$perm\">\n";
	my $i;

	my @permNum = (7);
	push @permNum, FAQ::OMatic::Groups::getGroupCodeList();
	push @permNum, (5, 3);

	my @permDesc = map { nameForPerm($_); } @permNum;

	push @permNum, ('');
	if ($self->{'filename'} eq '1') {
		push @permDesc, '(System default) '
			.nameForPerm(FAQ::OMatic::Auth::getDefaultProperty($perm));
	} else {
		push @permDesc, 'Whoever can for my parent,';
	}

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

sub nameForPerm {
	# this is a lot like Auth::authError, but with more concise descriptions
	my $perm = shift;

	if ($perm =~ m/^6 (.*)$/) {
		return "Group $1";
	}

	my %map = (
		'3' => 'Users giving their names',
		'5' => 'Authenticated users',
		'7' => 'The moderator',
	);

	return $map{$perm};
}

sub displayItemEditor {
	my $self = shift;
	my $params = shift;
	my $cgi = shift;
	my $rt = ""; 	# return text

	my $insertHint = $params->{'_insert'} || '';
	if ($insertHint eq 'category') {
		$rt .= "New Category\n";
	} elsif ($insertHint eq 'answer') {
		$rt .= "New Answer\n";
	} else {
		$rt .= "Editing ".$self->whatAmI()." <b>".$self->getTitle()."</b>\n";
	}
	$rt .= FAQ::OMatic::makeAref('-command'=>'submitItem',
			'-params'=>$params,
			'-changedParams'=>{'_insert'=>$params->{'_insert'}},
			'-refType'=>POST);

	# SequenceNumber protects the database from race conditions --
	# if person A gets this form,
	# then person B gets this form,
	# then person A returns the form (incrementing the sequence number),
	# then person B returns the form, the sequence number won't match,
	# so B will be turned back, so he can't mistakenly overwrite A's changes.
	# (it doesn't help for race conditions involving two simultaneously-
	# running CGIs, only with the simultaneity of two people typing into
	# browser forms at once.
	# TODO: Lock files are supposed to help with two CGIs, but their
	# TODO: implementation isn't right. They only protect during the
	# TODO: actual write (which keeps the item files consistent). But
	# TODO: data can get lost in a race, since two CGIs can still
	# TODO: run in the classic A:read-B:read-A:modify,write-B:modify,write
	# TODO: race condition.
	$rt .= "<input type=hidden name=\"checkSequenceNumber\" value=\""
			.$self->{'SequenceNumber'}."\">\n";

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
	$rt .= " CHECKED" if $self->{'AttributionsTogether'};
	$rt .= "> Show attributions from all parts together at bottom\n";

# TODO: delete this block. superseded by submitAnsToCat
#	if ((not defined $self->{'directoryHint'})
#		and (not $params->{'_insert'})) {
#		# we hide this on initial inserts, because it serves to confuse, and
#		# they can always come back here.
#		$rt .= "<p><input type=checkbox name=\"_addDirectory\">"
#			." Add a directory part to turn this answer item into "
#			."a category item.\n";
#	}

	# Submit
	$rt .="<br><input type=submit name=\"_submit\" value=\"Submit Changes\">\n";
	$rt .= "<input type=reset name=\"_reset\" value=\"Revert\">\n";
	$rt .= "<input type=hidden name=\"_zzverify\" value=\"zz\">\n";
		# this lets the submit script check that the whole POST was
		# received.
	$rt .= "</form>\n";
#	$rt .= FAQ::OMatic::button(
#			FAQ::OMatic::makeAref('-command'=>'faq',
#				'-params'=>$params,
#				'-changedParams'=>{'checkSequenceNumber'=>''}),
#			"Cancel and return to FAQ");

	$rt .= FAQ::OMatic::Help::helpFor($params, 'editItem', "<br>\n");
	if ($showModOptions) {
		$rt .= FAQ::OMatic::Help::helpFor($params, 'moderatorOptions',
			"<br>\n");
	}

	return $rt;
}

sub displayModOptionsEditor {
	my $self = shift;
	my $params = shift;
	my $cgi = shift;
	my $rt = ""; 	# return text

	$rt .= "Moderator options for "
			.$self->whatAmI()." <b>".$self->getTitle()."</b>:\n"
			."<p>\n";

	$rt .= FAQ::OMatic::makeAref('-command'=>'submitModOptions',
			'-params'=>$params,
			'-changedParams'=>{'_insert'=>$params->{'_insert'}},
			'-refType'=>POST);

	$rt .= "<input type=hidden name=\"checkSequenceNumber\" value=\""
			.$self->{'SequenceNumber'}."\">\n";

	# Moderator
	$rt .= "<p>Moderator: <i>(leave blank to inherit from parent item)</i>"
			."<br><input type=text name=\"_Moderator\" value=\""
			.($self->{'Moderator'}||'')."\" size=60>\n";

	$rt .= "<br>Send mail to the moderator "
			."<select name=\"_MailModerator\">\n";
	$rt .= "<option value=\"1\"";
	$rt .= " SELECTED" if (defined($self->{'MailModerator'})
							and ($self->{'MailModerator'} eq '1'));
	$rt .= "> whenever someone modifies this item.\n";
	$rt .= "<option value=\"0\"";
	$rt .= " SELECTED" if (defined($self->{'MailModerator'})
							and ($self->{'MailModerator'} eq '0'));
	$rt .= "> never.\n";
	$rt .= "<option value=\"\"";
	$rt .= " SELECTED" if (not defined $self->{'MailModerator'});
	if ($self->{'filename'} eq '1') {
		$rt .= "> (System default) "
			.(FAQ::OMatic::Auth::getDefaultProperty('MailModerator')
				? "whenever someone modifies this item."
				: "never")
			.".\n";
	} else {
		$rt .= "> whenever my parent would.\n";
	}
	$rt .= "</select>\n";

	# Permission info
	$rt .= "<p>Permissions:";

	$rt .= "<br>";
	$rt .= $self->permissionBox('PermAddPart');
	$rt .= " may add new text parts to this page.\n";

	$rt .= "<br>";
	$rt .= $self->permissionBox('PermUseHTML');
	$rt .= " may use HTML in my parts.\n";

	$rt .= "<br>";
	$rt .= $self->permissionBox('PermEditPart');
	$rt .= " may edit and delete existing parts from this page.\n";

	$rt .= "<br>";
	$rt .= $self->permissionBox('PermEditItem');
	$rt .= " may edit my item configuration, "
		."including adding and moving answers and subcategories.\n";

	$rt .= "<br>";
	$rt .= $self->permissionBox('PermModOptions');
	$rt .= " may edit these Moderator options.\n";

	if ($self->{'filename'} eq '1') {
		$rt .= "<p>System-wide moderator options:\n";

		$rt .= "<br>";
		$rt .= $self->permissionBox('PermNewBag');
		$rt .= " may upload new bags.\n";

		$rt .= "<br>";
		$rt .= $self->permissionBox('PermReplaceBag');
		$rt .= " replace the contents of existing bags.\n";

		$rt .= "<br>";
		$rt .= $self->permissionBox('PermEditGroups');
		$rt .= " can change group memberships.\n";
		# TODO: These global permissions should probably appear
		# TODO: on a different page. As-is, the administrator must
		# TODO: give away control over these permissions to give
		# TODO: away moderatorship of the root item.
	}

	$rt .="<p><input type=submit name=\"_submit\" value=\"Submit Changes\">\n";
	$rt .= "<input type=reset name=\"_reset\" value=\"Revert\">\n";
	$rt .= "<input type=hidden name=\"_zzverify\" value=\"zz\">\n";
		# this lets the submit script check that the whole POST was
		# received.
	$rt .= "</form>\n";

	$rt .= FAQ::OMatic::Help::helpFor($params, 'editModOptions', "<br>\n");

	return $rt;
}

sub setProperty {
	my $self = shift;
	my $property = shift;
	my $value = shift;

	if (defined($value) and ($value ne '')) {
		$self->{$property} = $value;
		if ($property eq 'Title') {
			# keep track if title changes after file is loaded;
			# used to update items whose cached representations
			# depend on this item's title (because those items have
			# embedded faqomatic: references to this one).
			$self->{'titleChanged'} = 1;
		}
	} else {
		delete $self->{$property};
	}
}

sub getProperty {
	my $self = shift;
	my $property = shift;

	return $self->{$property};
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

	# all the children in the list may now have different siblings,
	# which means we need to recompute their dependencies and
	# regenerate their cached html.
	$self->updateAllChildren();

	$self->incrementSequence();
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

		# all the children in the list may now have different siblings,
		# which means we need to recompute their dependencies and
		# regenerate their cached html.
		$self->updateAllChildren();
	}

# I'm not sure why I thought automatically converting categories to answers
# when their directories become empty was a good idea. When the trash is
# emptied, it becomes an answer. If you empty a category, and expect
# to refill it with moves, you won't see your category in the (default)
# move target list anymore. That would be confusing. Hmmm.
#	if ($dirPart->{'Text'} =~ m/^\s*$/s) {
#		splice @{$self->{'Parts'}}, $self->{'directoryHint'}, 1;
#		delete $self->{'directoryHint'};
#	}

	$self->incrementSequence();
}

sub extractWordsFromString {
	my $string = shift;
	my $filename = shift;
	my $words = shift;

	my @wordlist = FAQ::OMatic::Words::getWords( $string );

	# Associate words with this file in index
	my $i;
	foreach $i (@wordlist) {
		# do it for every prefix, too
		my $prefix;
		foreach $prefix ( FAQ::OMatic::Words::getPrefixes( $i ) ) {
			$words->{$prefix}{$filename} = 1;
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
	$rt = FAQ::OMatic::makeAref('-command'=>'faq',
		'-params'=>$params,
		'-changedParams'=>
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

	my $mail = FAQ::OMatic::Auth::getInheritedProperty($self, 'MailModerator')
				|| '';
	return if ($mail ne '1');	# didn't want mail anyway

	my $moderator = FAQ::OMatic::Auth::getInheritedProperty($self, 'Moderator');
	return if (not $moderator =~ m/\@/);	# some non-address

	my $msg = '';
	my ($id,$aq) = FAQ::OMatic::Auth::getID();

	$msg .= "[This is a message about the Faq-O-Matic items you moderate.]\n\n";
	$msg .= "Who:      $id\n";
	$msg .= "Item:     ".$self->getTitle()."\n";
	$msg .= "File:     ".$self->{'filename'}."\n";
	my $url = FAQ::OMatic::makeAref('-command'=>'faq',
			# sleazy hack that will bite me later -- go ahead and use
			# global params, because that's always "okay" here.
			#'-params'=>$params,
			'-changedParams'=>{'file'=>$self->{'filename'}},
			'-reftype'=>'url',
			'-blastAll'=>1);
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
	my @siblings = $parent->getChildren();
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

sub isCategory {
	my $self = shift;
	return (defined $self->{'directoryHint'}) ? 1 : 0;
}

sub whatAmI {
	my $self = shift;
	return ($self->isCategory())
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
		if ($key =~ m/-Set$/) {
			$newitem->{$key} = $self->{$key}->clone();
		} elsif (ref $self->{$key}) {
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

sub checkSequence {
	my $self = shift;
	my $params = shift;

	my $checkSequenceNumber =
		defined($params->{'checkSequenceNumber'})
		? $params->{'checkSequenceNumber'}
		: -1;
	if ($checkSequenceNumber ne $self->{'SequenceNumber'}) {
		my $button = FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'faq',
				'-params'=>$params,
				'-changedParams'=>{'partnum'=>'', 'checkSequenceNumber'=>''}
			),
			"Return to the FAQ");
		FAQ::OMatic::gripe('error',
			"Either someone has changed the answer or category you were "
			."editing since you received the editing form, or you submitted "
			."the same form twice.\n"
			."<p>Please $button and "
			."start again to make sure no changes are lost. Sorry for "
			."the inconvenience."
			."<p>(Sequence number in form: $checkSequenceNumber; in item: "
			.$self->{'SequenceNumber'}.")"
			);
	}
}

sub incrementSequence {
	my $self = shift;

	$self->setProperty('SequenceNumber', $self->{'SequenceNumber'}+1);
}

1;
