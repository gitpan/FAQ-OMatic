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

package FAQ::OMatic::submitCatToAns;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $removed = 0;
	
	$params = FAQ::OMatic::getParams($cgi);

	$item = new FAQ::OMatic::Item($params->{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$params->{'file'}.") doesn't exist.");
	}
	
	$item->checkSequence($params);
	$item->incrementSequence();

	FAQ::OMatic::Auth::ensurePerm($item, 'PermEditPart',
		FAQ::OMatic::commandName(), $cgi, 0);

	# users would rarely see these messages; they'd have to forge the URL.
	if (not $item->isCategory()) {
		FAQ::OMatic::gripe('error', "This isn't a category.");
	}

	if (scalar($item->getChildren())>0) {
		FAQ::OMatic::gripe('error', "This category still has children. "
			."Move them to another category before trying to convert this "
			."category into an answer.");
	}

	if ($params->{'_removePart'}) {
		# just delete the entire part outright
		$item->removeSubItem();
	} else {
		# the directory part has no faqomatic: links, so it won't hurt to
		# turn it into a regular text part.
		my $part = $item->getDirPart();
		$part->setProperty('Type', '');
		$part->setProperty('DateOfPart', FAQ::OMatic::Item::compactDate());
		delete $item->{'directoryHint'};	# probably doesn't matter, but
					# if any code beyond this point were to try to test
					# the $item for being a category, we'd want it to test
					# correctly.
	}

	# parent and any see-also linkers have changed, since their icons will
	# be wrong. This is just like changing the title, although it doesn't
	# affect siblings, but who cares; we'll just use
	# the usual dependency-update routine.)
	# TODO: maybe siblings should have icons! So should the parent chain!
	$item->setProperty('titleChanged', 1);

	$item->saveToFile();

	$item->notifyModerator($cgi, "made a category into an answer.");

	$url = FAQ::OMatic::makeAref('-command'=>'faq',
				'-params'=>$params,
				'-changedParams'=>{'checkSequenceNumber'=>''},
				'-refType'=>'url');
		# eliminate things that were in our input form that weren't
		# automatically transient (_ prefix)
	print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
}

1;
