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

package FAQ::OMatic::delPart;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	my $params = FAQ::OMatic::getParams($cgi);

	FAQ::OMatic::mirrorsCantEdit($cgi, $params);

	my $item = new FAQ::OMatic::Item($FAQ::OMatic::theParams{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$FAQ::OMatic::theParams{'file'}.") doesn't exist.");
	}

	my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermEditPart',
		FAQ::OMatic::commandName(), $cgi, 0);
	if ($rd) { print $rd; exit 0; }

	$item->checkSequence($params);
	$item->incrementSequence();
	
	my $partnum = $FAQ::OMatic::theParams{'partnum'};
	my $part = $item->getPart($partnum);
	if (not $part) {
		FAQ::OMatic::gripe('error', "Part number $partnum in "
			.$FAQ::OMatic::theParams{'file'}." doesn't exist.");
	}

	if ($part->{'Type'} eq 'directory') {
		FAQ::OMatic::gripe('error', "Part number $partnum in "
			.$FAQ::OMatic::theParams{'file'}." can't be deleted.");
	}

	my $oldtext = $item->getPart($partnum)->{'Text'};

	# delete the part
	splice @{$item->{'Parts'}}, $partnum, 1;

	$item->saveToFile();

	$oldtext =~ s/^/> /mg;
	$item->notifyModerator($cgi,
		"deleted a part, which used to say:\n\n$oldtext\n");

	# send user to item page to see the results of the delete
	my $url = FAQ::OMatic::makeAref('-command'=>'faq',
				'-params'=>$params,
				'-changedParams'=>{'partnum' => '', 'checkSequenceNumber'=>''},
				'-refType'=>'url');
	print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
}

1;
