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

package FAQ::OMatic::searchForm;

use CGI;
use FAQ::OMatic;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	my $params = FAQ::OMatic::getParams($cgi);

	my $page = '';

	$page.=FAQ::OMatic::pageHeader();

	my $useTable = not $params->{'simple'};

	$page.="<table>\n" if $useTable;
	$page.="<tr><td valign=top align=right>\n" if $useTable;
	$page .= FAQ::OMatic::makeAref('search', {}, 'GET');
	$page .= "<input type=\"submit\" name=\"_submit\" "
		."value=\"Search for\">\n";
	$page.="</td><td valign=top align=left>\n" if $useTable;
	$page .= "<input type=\"text\" name=\"_search\"> matching\n";
	$page .= "<select name=\"_minMatches\">\n";
	$page .= "<option value=\"\">all\n";
	$page .= "<option value=\"1\">any\n";
	$page .= "<option value=\"2\">two\n";
	$page .= "<option value=\"3\">three\n";
	$page .= "<option value=\"4\">four\n";
	$page .= "<option value=\"5\">five\n";
	$page .= "</select>\n";
	$page .= "words.\n";
	$page .= "</form>\n";
	$page.="</td></tr>\n" if $useTable;

	## Recent documents
	$page.="<tr><td valign=top align=right>\n" if $useTable;
	$page .= FAQ::OMatic::makeAref('recent',
			{'showLastModified'=>'1'}, 'GET');
	$page .= "<input type=\"submit\" name=\"_submit\" "
		."value=\"Show documents\">\n";
	$page.="</td><td valign=top align=left>\n" if $useTable;
	$page .= " modified in the last \n";
	$page .= "<select name=\"_duration\">\n";
	$page .= "<option value=\"1\">day.\n";
	$page .= "<option value=\"2\">two days.\n";
	$page .= "<option value=\"3\">three days.\n";
	$page .= "<option value=\"7\" SELECTED>week.\n";
	$page .= "<option value=\"14\">fortnight.\n";
	$page .= "<option value=\"31\">month.\n";
	$page .= "</select>\n";
	$page .= "</form>\n";
	$page.="</td></tr></table>\n" if $useTable;

#	$page.=FAQ::OMatic::button(
#		FAQ::OMatic::makeAref('-command'=>''),
#		'Return to FAQ')."<br>\n";

	$page.=FAQ::OMatic::Help::helpFor($params,
		'Search Tips', "<br>");

	$page.= FAQ::OMatic::pageFooter($params, ['help','faq']);

	print $page;
}

1;
