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

package FAQ::OMatic::editBag;

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
	
	my $bagName = $params->{'_target'} || '';	# no bag name => upload new.

	if ($bagName) {
		# bag exists
		my $rd = FAQ::OMatic::Auth::ensurePerm('', 'PermReplaceBag',
			FAQ::OMatic::commandName(), $cgi, 0, 'replace');
		if ($rd) { print $rd; exit 0; }
	} else {
		# new bag name
		my $rd = FAQ::OMatic::Auth::ensurePerm('', 'PermNewBag',
			FAQ::OMatic::commandName(), $cgi, 0);
		if ($rd) { print $rd; exit 0; }
	}

	my $bagDescName = $bagName.".desc";
	my $bagDesc = new FAQ::OMatic::Item($bagDescName,
			$FAQ::OMatic::Config::bagsDir);
	$bagDesc->setProperty('Title', 'Bag Description');	# if bagDesc not found
	my $sizeWidth = $bagDesc->{'SizeWidth'} || '';
	my $sizeHeight = $bagDesc->{'SizeHeight'} || '';

	if ($bagName ne '') {
		$rt .= "<h3>Replace bag <i>$bagName</i>:</h3>\n";
	} else {
		my $item = new FAQ::OMatic::Item($params->{'file'});
		my $itemTitle = $item->getTitle();
		my $partnum = $params->{'partnum'};
		$partnum = -1 if (not defined $partnum);
		$rt .= "Upload new bag to show in the "
			.FAQ::OMatic::cardinal($partnum+1)
			." part in <b>$itemTitle</b>.\n";
	}

	$rt .= "<table>\n";
	$rt .= FAQ::OMatic::makeAref('-command'=>'submitBag',
						'-params'=>$params,
						'-refType'=>'POST',
						'-saveTransients'=>1);
	if ($bagName ne '') {
		$rt .= 
		"<input type=hidden name=\"_bagName\" value=\"$bagName\" size=30>\n";
	} else {
		$rt .= "<tr><td align=right valign=top>Bag name:</td><td valign=top>"
			."<input type=text name=\"_bagName\" value=\"\" size=30>"
			."<br><i>The bag name is used as a filename, so it is restricted "
			."to only contain letters, "
            ."numbers, underscores (_), hyphens (-), and periods (.). "
			."It should also carry a meaningful extension (such as .gif) so "
			."that web browsers will know what to do with the data."
			."</td></tr>\n";
	}
	$rt .= "<tr><td align=right>Bag data:</td><td>"
			."<input type=file name=\"_bagData\">";
	if ($bagName ne '') {
			$rt .= " (Leave blank to keep original bag data and "
				."change only the associated information below.)";
	}
	$rt .= "</td></tr>\n";

	$rt .= "<tr><td colspan=2>"
		."If this bag is an image, fill in its dimensions.</td></tr>\n"
		."<td align=right>Width:</td><td align=left>"
		."<input type=text name=\"_sizeWidth\" value=\"$sizeWidth\" size=6>\n"
		."Height: "
		."<input type=text name=\"_sizeHeight\" value=\"$sizeHeight\" size=6>"
		."</td></tr>\n";

	$rt .= "<tr><td></td><td>"
			."<input type=submit name=\"_submit\" value=\"Submit Changes\">\n";
	$rt .= "<input type=reset name=\"_reset\" value=\"Revert\">\n"
			."</td></tr>\n";
	$rt .= "</form>\n";
	$rt .= "</table>\n";

	$rt .= FAQ::OMatic::pageFooter($params, ['help', 'faq']);

	print $rt;
}

1;
