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

package FAQ::OMatic::editPart;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $rt='';

	my $params = FAQ::OMatic::getParams($cgi);

	$rt .= FAQ::OMatic::pageHeader($params);
	
	$item = new FAQ::OMatic::Item($params->{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".$params->{'file'}
			.") doesn't exist.");
	}

	# check sequence number to prevent later confusion -- the user's
	# insert or change request came from an out-of-date page.
	$item->checkSequence($params);

	my $insertpart = $params->{'_insertpart'};

	my $partnum = $params->{'partnum'};
	my $part = undef;
	if ($partnum >= 0) {
		$part = $item->getPart($partnum);
		if (not $part) {
			FAQ::OMatic::gripe('error', "Part number $partnum in "
				.$params->{'file'}." doesn't exist.");
		}
	} else {
		$partnum = -1;
	}
	if (($partnum < 0) and (not $insertpart)) {
		FAQ::OMatic::gripe('error', "Part number \"$partnum\" in \""
			.$params->{'file'}."\" doesn't exist.");
	}

	# for inserts, create the part in our in-memory copy of the item
	# just like it would be created in submitItem, so that the
	# form-generator below can't tell the difference.

	# duplicates are exactly the same as inserts, but you copy an existing
	# part, rather than start with an empty one.
	if ($insertpart) {
		my $newpart;
		if ($cgi->param('_duplicate')) {
			# duplicate part -- the one above the insert, I guess.
			$newpart = $item->getPart($partnum)->clone();
		} else {
			# new part
			$newpart = new FAQ::OMatic::Part();
		}
		# squeeze the new part into the item's part list.
		splice @{$item->{'Parts'}}, $partnum+1, 0, $newpart;
		# inheret properties from parent part
		if ($part) {
			if ($part->{'Type'} ne 'directory') {
				$newpart->{'Type'} = $part->{'Type'};
			}
			$newpart->{'HideAttributions'} = $part->{'HideAttributions'};
		}
		$part = $newpart;
	}

	if ($part->{'Text'} =~ m/^\s*$/s) {
		# if the part starts out empty, we're as good as adding, not
		# editing existing content.
		my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermAddPart',
			FAQ::OMatic::commandName(), $cgi, 0);
		if ($rd) { print $rd; exit 0; }
	} else {
		my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermEditPart',
			FAQ::OMatic::commandName(), $cgi, 0);
		if ($rd) { print $rd; exit 0; }

		if ($part->{'Type'} eq 'html') {
			# discourage unauthorized users from editing HTML parts which
			# they won't later be able to submit.
			$rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermUseHTML',
				FAQ::OMatic::commandName(), $cgi, 0, 'useHTML');
			if ($rd) { print $rd; exit 0; }
		}
	}
	
	if ($params->{'_insertpart'}) {
		my $insertHint = $params->{'_insert'} || '';
		if ($insertHint eq 'answer') {
			$rt .= "Enter the answer to <b>".$item->getTitle()."</b>\n";
		} elsif ($insertHint eq 'category') {
			$rt .= "Enter a description for <b>".$item->getTitle()."</b>\n";
		} elsif ($params->{'_duplicate'}) {
			$rt .= "Edit duplicated text for <b>".$item->getTitle()."</b>\n";
		} else {
			$rt .= "Enter new text for <b>".$item->getTitle()."</b>\n";
		}
	} else {
		# little white lie -- user sees 1-based indices, but parts
		# are stored 0-based. Is this bad?
		$rt .= "Editing the "
			.FAQ::OMatic::cardinal($partnum+1)." text part in <b>"
			.$item->getTitle()."</b>\n";
	}
	$rt .= $part->displayPartEditor($item, $partnum, $params);

	$rt .= FAQ::OMatic::Help::helpFor($params, 'editPart', "<br>\n");
	$rt .= FAQ::OMatic::Help::helpFor($params, 'makingLinks', "<br>\n");
	$rt .= FAQ::OMatic::Help::helpFor($params, 'seeAlso', "<br>\n");

	$rt .= FAQ::OMatic::pageFooter($params, ['help','faq']);

	print $rt;
}

1;
