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

package FAQ::OMatic::editModOptions;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $rt = '';
	
	my $params = FAQ::OMatic::getParams($cgi);

	FAQ::OMatic::mirrorsCantEdit($cgi, $params);
	
	$rt = FAQ::OMatic::pageHeader($params);
	
	my $item = new FAQ::OMatic::Item($FAQ::OMatic::theParams{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$FAQ::OMatic::theParams{'file'}.") doesn't exist.");
	}

	my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermModOptions',
		FAQ::OMatic::commandName(), $cgi, 0);
	if ($rd) { print $rd; exit 0; }

	$rt .= $item->displayModOptionsEditor(\%FAQ::OMatic::theParams, $cgi);

	$rt .= FAQ::OMatic::pageFooter($params, ['help', 'faq']);

	print $rt;
}

1;