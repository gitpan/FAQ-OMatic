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

package FAQ::OMatic::changePass;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;

	my $params = FAQ::OMatic::getParams($cgi);

	my $rt = FAQ::OMatic::pageHeader();
	
	my ($id,$aq) = FAQ::OMatic::Auth::getID();
	$id =~ s/^anonymous$//;

	$rt.="Please enter your username, and select a password.\n";
	$rt.="<p>Please <b>do not</b> use a password you use anywhere else,\n";
	$rt.="as it will not be transferred or stored securely!\n";

	$rt.=FAQ::OMatic::makeAref('submitPass',
			{'badPass'=>'',		# the gedID() call above may (will) set this
			'_fromChangePass'=>1}, 'POST', 'saveTransients');
	$rt.="Email: "
		."<input type=text name=\"_id\" value=\"\" size=60>\n";
	$rt.= "<br>Password: "
		."<input type=password name=\"_pass\" value=\"\" size=10>\n";
	$rt.= "<p><input type=submit name=\"_submit\" value=\"Set Password\">\n";
	$rt.= "</form>\n";

	$rt .= FAQ::OMatic::pageFooter();

	print $rt;
}

1;
