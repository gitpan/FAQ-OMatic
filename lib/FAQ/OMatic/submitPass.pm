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

package FAQ::OMatic::submitPass;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Auth;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	my $params = FAQ::OMatic::getParams($cgi);

	if ($params->{'_fromChangePass'} or $params->{'_badSecret'}) {
		# this is the user coming from changePass; send the secret
		# in email, and put up a page explaining what to do.
		my $id = $params->{'_id'};
		if (not FAQ::OMatic::validEmail($id)) {
			FAQ::OMatic::gripe('error', "An email address must look like "
				."'name\@some.domain'. If yours ($id) does and I keep "
				."rejecting it, "
				."please mail $FAQ::OMatic::authorAddress and tell him "
				."what's happening.");
		}
		my $pass = $params->{'_pass'};
		if (not ($pass =~ m/^\S*$/)) {
			FAQ::OMatic::gripe('error', "Your password may not contain spaces "
				."or carriage returns.");
		}

		# Only create a secret if user is coming straight from changePass.
		# Don't create ANOTHER secret if this is just the user
		# looping back around after entering a bad secret.
		if ($params->{'_fromChangePass'}) {
			my $secret = FAQ::OMatic::Auth::getRandomHex();
			my $restart = $params->{'_restart'} ||
				FAQ::OMatic::makeAref('faq', {}, 'url', 0, 'blastAll');
			my $saveurl = FAQ::OMatic::makeAref($restart,
				{'auth'=>'','pass'=>'','id'=>''}, 'url', 'saveTransients');
	
			# put the secret in the IDfile, but don't put in the new
			# password yet, or we'll have circumvented the whole secret
			# thing.
			my ($idf,$passf,$secretf,$saveurlf,@rest)=FAQ::OMatic::Auth::readIDfile($id);
			if ((not defined $passf)
				or (not defined $idf)
				or ($idf ne $id)) {
				$passf = '__INVALID__';
			}
			FAQ::OMatic::Auth::writeIDfile($id,$passf,$secret,$saveurl,@rest);
	
			# mail the user the secret url
			my $secreturl = FAQ::OMatic::urlBase($cgi)
							.FAQ::OMatic::makeAref('submitPass',
								{	'_id'=>$id,
									'_pass'=>$pass,
									'_secret'=>$secret	},
								'url', 0, 'blastAll');
			#my $secreturl = FAQ::OMatic::urlBase($cgi)
			#	."submitPass?_id=$id&_pass=$pass&_secret=$secret";
			my $subj = "Your Faq-O-Matic authentication secret";
			my $mesg = <<__EOF__;
To validate your Faq-O-Matic password, you may either enter
this secret into the Validation form:

     Secret: $secret

Or access the following URL. Be careful when you copy and
paste the URL that the line-break doesn't cut the URL short.

$secreturl

Thank you for using Faq-O-Matic.

(Note: if you did not sign up to use the Faq-O-Matic,
someone else has attempted to log in using your name.
Do not access the URL above; it will validate the password
that user has supplied. Instead, send mail to
	$FAQ::OMatic::Config::adminEmail
and I will look into the matter.)
__EOF__
			if (FAQ::OMatic::sendEmail($id, $subj, $mesg)) {
				FAQ::OMatic::gripe('error',
					"I couldn't mail the authentication"
					." secret to \"$id\", and I'm not sure why.");
			}
		}

		# now tell the user what's going on
		my $rt = '';

		$rt .= FAQ::OMatic::pageHeader($params);

		if ($params->{'_badSecret'}) {
			$rt .= "The secret you entered is not correct.\n";
			$rt .= "Did you copy and paste the secret or the URL "
				."completely?\n<p>\n"
		}

		$rt .= "I sent email to you at \"$id\". It should arrive\n";
		$rt .= "soon, containing a URL. Either open the URL directly,\n";
		$rt .= "or paste the secret into the form below and click Validate.\n";
		$rt .= "<p>Thank you for taking the time to sign up.\n";

		$rt.= FAQ::OMatic::makeAref('submitPass',
					{	'_id'=>$id,
						'_pass'=>$pass },
					'POST', 0, 'blastAll');
		#$rt.="<form action=\"submitPass\" method=POST>\n";
		$rt.= "Secret: \n";
		$rt.= "<input type=input name=\"_secret\" value=\"\" size=14>\n";
		$rt.= "<p><input type=submit name=\"_submit\" value=\"Validate\">\n";
		$rt.= "</form>\n";

		$rt .= FAQ::OMatic::pageFooter($params);
		print $rt;
	} else {
		# this is the user presenting his secret received via email
		my $id = $params->{'_id'};
		my $pass = $params->{'_pass'};	# what user wants password to become
		my $secret = $params->{'_secret'};
		my ($idf,$passf,$secretf,$saveurl,@rest) = FAQ::OMatic::Auth::readIDfile($id);
		if (not defined($idf)
			or not ($idf eq $id)
			or not ($secret eq $secretf)) {
			# if we get the wrong secret, send the user back
			# around to the page with the Validate button (the top case
			# in this file) to give them another chance to enter the secret.
			my $url = FAQ::OMatic::makeAref('submitPass',
				{ '_badSecret'=>1, '_id'=>$id, '_pass'=>$pass }, 'url');
			print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
			exit 0;
		}
		FAQ::OMatic::Auth::writeIDfile($idf,FAQ::OMatic::Auth::cryptPass($pass));
			# no secret necessary anymore

		# append auth info to url, so you're automatically logged in
		my $newauth = "&auth=pass&_pass_id=".CGI::escape($idf)
				."&_pass_pass=".CGI::escape($pass);
		print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$saveurl.$newauth);
	}
}

1;
