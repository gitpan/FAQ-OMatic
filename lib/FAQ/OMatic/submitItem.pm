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

package FAQ::OMatic::submitItem;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	FAQ::OMatic::getParams($cgi);
	my $params = \%FAQ::OMatic::theParams;

	FAQ::OMatic::mirrorsCantEdit($cgi, $params);

	my $item = new FAQ::OMatic::Item($params->{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$params->{'file'}.") doesn't exist.");
	}

	my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermEditItem', 'editItem', $cgi, 1);
	if ($rd) { print $rd; exit 0; }
	
	# verify that an evil cache hasn't truncated a POST
	if ($params->{'_zzverify'} ne 'zz') {
		FAQ::OMatic::gripe('error',
			"Your browser or WWW cache has truncated your POST.");
	}

	$item->checkSequence($params);
	$item->incrementSequence();

	if (defined $params->{'_Title'}) {
		$item->setProperty('Title', $params->{'_Title'})
	}
	if (defined $params->{'_partOrder'}) {
		# get the user's new ordering for the parts
		my @newOrder = ($params->{'_partOrder'} =~
							m/([^\s,]+)/sg);

		# verify that there are as many items in the new order as the old:
		if (scalar @newOrder != $item->numParts()) {
			FAQ::OMatic::gripe('error', "Your part order list ("
				.join(", ", @newOrder)
				.") doesn't have the same number of parts ("
				.$item->numParts()
				.") as the original item.");
		}

		# verify now that every number 0 .. numParts()-1 appears exactly
		# once in the new list.
		my %newOrderHash = map { ($_,1) } @newOrder;
		my $i;
		for ($i=0; $i<$item->numParts(); $i++) {
			if (not $newOrderHash{$i}) {
				FAQ::OMatic::gripe('error', "Your part order list ("
					.join(", ", @newOrder)
					.") doesn't say what to do with part $i.");
			}
		}

		# now we trust the @newOrder array.
		my $newPartOrder = [];	# new anonymous array
		foreach $i (@newOrder) {
			push @{$newPartOrder}, $item->getPart($i);
		}

		# install the new anonymous array
		$item->{'Parts'} = $newPartOrder;
	}

	$item->setProperty('AttributionsTogether',
		defined $params->{'_AttributionsTogether'} ? 1 : '');

# TODO: delete this block. superseded by submitAnsToCat.
#	if ($params->{'_addDirectory'}) {
#		$item->makeDirectory()->
#			setText("Subcategories:\n\nAnswers in this category:\n");
#	}

	$item->saveToFile();

	$item->notifyModerator($cgi, 'edited the item configuration');

	my $url;
	if ($params->{'_insert'}) {
		$url = FAQ::OMatic::makeAref(
			'-command'=>'editPart',
			'-params'=>$params,
			'-changedParams'=>{'_insertpart'=>1,
				'partnum'=>'-1',
				'checkSequenceNumber'=>$item->{'SequenceNumber'},
				'_insert'=>$params->{'_insert'}},
			'-refType'=>'url');
	} else {
		$url = FAQ::OMatic::makeAref(
			'-command'=>'faq',
			'-params'=>$params,
			'-changedParams'=>{'checkSequenceNumber'=>''},
			'-refType'=>'url');
	}

	print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
}

1;
