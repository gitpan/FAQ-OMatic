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

package FAQ::OMatic::submitMove;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;
use FAQ::OMatic::I18N;

sub main {
	my $cgi = FAQ::OMatic::dispatch::cgi();
	my $params = FAQ::OMatic::getParams($cgi);

	FAQ::OMatic::mirrorsCantEdit($cgi, $params);

	my $movingFilename = $params->{'file'};
	my $newParentFilename = $params->{'_newParent'};

	# load up the moving file and the new parent
	my $movingItem = new FAQ::OMatic::Item($movingFilename);
	if ($movingItem->isBroken()) {
		FAQ::OMatic::gripe('error',
			gettext("The moving file")." ($movingFilename) ".gettext("is broken or missing."));
	}
	my $newParentItem = new FAQ::OMatic::Item($newParentFilename);
	if ($newParentItem->isBroken()) {
		FAQ::OMatic::gripe('error',
			gettext("The newParent file")." ($newParentFilename) ".gettext("is broken or missing."));
	}

	# load up the old parent
	my $oldParentFilename = $movingItem->{'Parent'};
	my $oldParentItem = new FAQ::OMatic::Item($oldParentFilename);
	if ($oldParentItem->isBroken()) {
		FAQ::OMatic::gripe('error',
			gettext("The oldParent file")." ($oldParentFilename) ".gettext("is broken or missing."));
	}

	# make sure the new parent isn't the old parent or
	# the moving item itself
	if ($newParentFilename eq $oldParentFilename) {
		FAQ::OMatic::gripe('error',
			gettext("The new parent")." (".$newParentItem->getTitle()
			.") ".gettext("is the same as the old parent."));
	}
	if ($newParentFilename eq $movingFilename) {
		FAQ::OMatic::gripe('error',
			gettext("The new parent")." (".$newParentItem->getTitle()
			.") ".gettext("is the same as the item you want to move."));
	}
	
	# make sure the new parent isn't a child of movingItem
	if ($newParentItem->hasParent($movingFilename)) {
		FAQ::OMatic::gripe('error',
			gettext("The new parent")." (".$newParentItem->getTitle()
			.") ".gettext("is a child of the item being moved")." ("
			.$movingItem->getTitle().").");
	}

	if ($movingItem->{'filename'} eq '1') {
		FAQ::OMatic::gripe('error', gettext("You can't move the top item."));
	}

	# check permissions on the parents to see that the move is legal
	# we need to check more than a single permission, and want
	# to return the error corresponding to the greater of the two.
	my ($url1,$aq1) =
		FAQ::OMatic::Auth::ensurePerm($oldParentItem, 'PermEditDirectory',
		'submitMove', $cgi, 1);
	my ($url2,$aq2) =
		FAQ::OMatic::Auth::ensurePerm($newParentItem, 'PermAddItem',
		'submitMove', $cgi, 1);

	# If both ends of the move are not authorized, demand authentication
	# at the higher of the two levels
	if ($url1 and $url2) {
		FAQ::OMatic::redirect($cgi, ($aq1 > $aq2) ? $url1 : $url2 );
	} elsif ($url1) {
		FAQ::OMatic::redirect($cgi, $url1);
	} elsif ($url2) {
		FAQ::OMatic::redirect($cgi, $url2);
	}

	# don't remove an item from itself if it's a root (own parent)
	if ($oldParentItem ne $movingItem) {
		$oldParentItem->removeSubItem($movingFilename);
	}
	$newParentItem->addSubItem($movingFilename);
	$movingItem->setProperty('Parent', $newParentFilename);

	$oldParentItem->saveToFile();
	$newParentItem->saveToFile();
	$movingItem->saveToFile();

	my $oldModerator =
		FAQ::OMatic::Auth::getInheritedProperty($oldParentItem, 'Moderator');
	my $newModerator =
		FAQ::OMatic::Auth::getInheritedProperty($newParentItem, 'Moderator');
	$oldParentItem->notifyModerator($cgi, gettext("moved a sub-item to")." "
			.$newParentItem->getTitle());
	if ($newModerator ne $oldModerator) {
		$newParentItem->notifyModerator($cgi, gettext("moved a sub-item from")." "
			.$oldParentItem->getTitle());
	}

	# If user clicked "trash this item," they probably don't want
	# to go see it in the trash.
	my $target = ($newParentFilename ne 'trash')
		? $newParentFilename
		: $oldParentFilename;
	my $url = FAQ::OMatic::makeAref('faq', {'file'=>$target}, 'url');

	FAQ::OMatic::redirect($cgi, $url);
}

1;
