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

package FAQ::OMatic::authenticate;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;
use FAQ::OMatic::Help;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	my $rt = FAQ::OMatic::pageHeader();
	
	FAQ::OMatic::getParams($cgi);
	my $params = \%FAQ::OMatic::theParams;

	my $what = $params->{'_restart'};
	my $why = FAQ::OMatic::Auth::authError($params->{'_reason'});

	# Give them the option of setting up a new password
	# Creating a login is the same thing
	$newPassButton .= FAQ::OMatic::button(FAQ::OMatic::makeAref('changePass',
			{'_pass_pass' => '',
			 '_pass_id' => '' }, '', 'saveTransients'), "Set a New Password");
	$newLoginButton .= FAQ::OMatic::button(FAQ::OMatic::makeAref('changePass',
			{'_pass_pass' => '',
			 '_pass_id' => '' }, '', 'saveTransients'), "Create a New Login");

	if ($params->{'badPass'}) {
		$rt.="That password is invalid. If you've forgotten your old "
			."password, you can $newPassButton.\n";

		delete $params->{'badPass'};
		# We had to use a nontransient param because the func that sets
		# the badPass flag (FAQ::OMatic::AuthLocal::authenticate()) doesn't directly
		# generate a URL, and of course stuffing a transient param
		# into the param list won't make it to the URL.
		#
		# You're probably worried the param could live on too long (I was).
		# Say you fill in the authentication dialog with a bad password.
		# You get a badPass param, but say the script checking your
		# authentication decides to accept the 'anonymous' $aq==1
		# authentication that results. But wait -- the reason you were
		# asked to authenticate in the first place was that your previous
		# auth wasn't good enough for that script. And aq=1 is certainly
		# no better.
	} else {
		if ($what eq 'addItem') {
			$rt.="New items can only be added by $why.";
		} elsif ($what eq 'addPart') {
			$rt.="New text parts can only be added by $why.";
		} elsif ($what eq 'delPart') {
			$rt.="Text parts can only be removed by $why.";
		} elsif ($what eq 'editPart' or $what eq 'submitPart') {
			if ($params->{'_insertpart'}) {
				$rt.="Text parts can only be added by $why.";
			} else {
				$rt.="Text parts can only be edited by $why.";
			}
		} elsif ($what eq 'editItem' or $what eq 'submitItem') {
			my $xreason = $params->{'_xreason'} || '';

			if ($xreason eq 'modOptions') {
				$rt.="The moderator options can only be edited by $why.";
			} else {
				$rt.="The title and options for this item can only "
					."be edited by $why.";
			}
		} elsif ($what eq 'moveItem' or $what eq 'submitMove') {
			if ($why =~ m/moderator/) {
				$rt.="This item can only be moved by someone who can edit both "
					."the source and destination parent items.";
			} else {
				$rt.="This item can only be moved by $why.";
			}
		} elsif ($what eq 'install') {
			$rt.="The FAQ-O-Matic can only be configured by $why.";
		} else {
			$rt.="The operation you attempted ($what) can "
				."only be done by $why.";
		}
	
		$rt .= "<ul><li>If you have never established a password to use with "
			."FAQ-O-Matic, you can $newLoginButton.\n";
		$rt .= "<li>If you have forgotten your password, "
			."you can $newPassButton.\n";
		$rt .= "<li>If you have already logged in earlier today, it may be "
			."that the token I use to identify you has expired. "
			."Please log in again.\n";
		$rt .= "</ul>\n";
	}

	$rt .= FAQ::OMatic::makeAref($params->{'_restart'},
			{ 'id' => '', 'auth' => '',
				'_pass_id'=>'',		# since we saveTransients, our own
				'_pass_pass'=>'',	# transients must be explicitly killed
				'_none_id'=>'' },
			'POST', 'saveTransients');

	if ($params->{'_reason'} <= 3) {
		$rt .= "<p>"
			."Please offer one of the following forms of identification:\n";
	
		$rt .= "<p><input type=radio name=\"auth\" value=\"none\" checked>\n";
		$rt .= " No authentication, but my email address is:\n";
		$rt .= "<br>Email: "
			."<input type=text name=\"_none_id\" value=\"\" size=60>\n";
	}

	$rt .= "<p><input type=radio name=\"auth\" value=\"pass\"";
	$rt .= " checked" if ($params->{'_reason'} > 3);
	$rt .= ">\n";
	$rt .= " Authenticated login:\n";
	$rt .= "<br>Email: <input type=text name=\"_pass_id\" value=\"\" size=60>\n";
	$rt .= "<br>Password: <input type=password name=\"_pass_pass\" value=\"\" size=10>\n";

	$rt .= "<p><input type=submit name=\"_submit\" value=\"Login\">\n";
	$rt .= "</form>\n";

	# Give them the option of leaving whatever authentication they
	# used to have intact, and giving up on "better" auth.
#	$rt .= FAQ::OMatic::button(FAQ::OMatic::makeAref(
#				'-command'=>'faq',
#				'-params'=>$params,
#				'-changedParams'=>{'partnum'=>'',
#					'checkSequenceNumber'=>''}
#				),
#			"Cancel and Return to FAQ");

	$rt.=FAQ::OMatic::Help::helpFor($params, 'authenticate');

	$rt .= FAQ::OMatic::pageFooter($params, ['help', 'faq']);

	print $rt;
}

1;
