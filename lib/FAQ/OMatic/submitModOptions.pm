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

package FAQ::OMatic::submitModOptions;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	my $params = FAQ::OMatic::getParams($cgi);

	FAQ::OMatic::mirrorsCantEdit($cgi, $params);

	my $item = new FAQ::OMatic::Item($params->{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$params->{'file'}.") doesn't exist.");
	}

	my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermModOptions',
		'editModOptions', $cgi, 1);
	if ($rd) { print $rd; exit 0; }
	
	# verify that an evil cache hasn't truncated a POST
	if ($params->{'_zzverify'} ne 'zz') {
		FAQ::OMatic::gripe('error',
			"Your browser or WWW cache has truncated your POST.");
	}

	$item->checkSequence($params);
	$item->incrementSequence();

	$item->setProperty('AttributionsTogether',
		defined $params->{'_AttributionsTogether'} ? 1 : '');

	if (defined $params->{'_Moderator'}) {
		$item->setProperty('Moderator', $params->{'_Moderator'});
	}
	if (defined $params->{'_MailModerator'}) {
		$item->setProperty('MailModerator', $params->{'_MailModerator'});
	}
	if (defined $params->{'_PermAddPart'}) {
		$item->setProperty('PermAddPart', $params->{'_PermAddPart'});
	}
	if (defined $params->{'_PermUseHTML'}) {
		$item->setProperty('PermUseHTML', $params->{'_PermUseHTML'});
	}
	if (defined $params->{'_PermEditPart'}) {
		$item->setProperty('PermEditPart', $params->{'_PermEditPart'});
	}
	if (defined $params->{'_PermEditItem'}) {
		$item->setProperty('PermEditItem', $params->{'_PermEditItem'});
	}
	if (defined $params->{'_PermModOptions'}) {
		$item->setProperty('PermModOptions', $params->{'_PermModOptions'});
	}
	if (defined $params->{'_PermNewBag'}) {
		$item->setProperty('PermNewBag', $params->{'_PermNewBag'});
	}
	if (defined $params->{'_PermReplaceBag'}) {
		$item->setProperty('PermReplaceBag', $params->{'_PermReplaceBag'});
	}
	if (defined $params->{'_PermEditGroups'}) {
		$item->setProperty('PermEditGroups', $params->{'_PermEditGroups'});
	}

	$item->saveToFile();

	$item->notifyModerator($cgi, 'edited the moderator options');

	my $url = FAQ::OMatic::makeAref(
		'-command'=>'faq',
		'-params'=>$params,
		'-changedParams'=>{'checkSequenceNumber'=>''},
		'-refType'=>'url');

	print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
}

1;