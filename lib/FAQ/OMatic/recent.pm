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

package FAQ::OMatic::recent;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Search;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	FAQ::OMatic::getParams($cgi);
	my $params = \%FAQ::OMatic::theParams;

	# Get the names of the recent files
	my $matchset = FAQ::OMatic::Search::getRecentSet($params);
	
	my $rt = FAQ::OMatic::pageHeader($params);
	if (scalar(@{$matchset})==0) {
		$rt.="No items were modified in the last ".$params->{'_duration'}
			." days.\n<br>\n";
	} else {
		$rt.="Items modified in the last ".$params->{'_duration'}
			." days:\n<p>\n";

		my ($file, $item);
		foreach $file (@{$matchset}) {
			$item = new FAQ::OMatic::Item($file);
			$rt .= FAQ::OMatic::Appearance::itemStart($params, $item);
				# goes before & between display item's title
			$rt .= FAQ::OMatic::makeAref("faq",
					{ 'file'	=>	$item->{'filename'} })
					.$item->getTitle()."</a>";
			$rt .= "<br>".$item->{'LastModified'}."\n";
		}
		$rt .= FAQ::OMatic::Appearance::itemEnd($params);		# goes after items
	}
	
	$rt.=FAQ::OMatic::button(
		FAQ::OMatic::makeAref('faq', {}),
		'Return to FAQ');

	$rt .= FAQ::OMatic::pageFooter($params);

	print $rt;

	FAQ::OMatic::Search::closeWordDB();
}

1;
