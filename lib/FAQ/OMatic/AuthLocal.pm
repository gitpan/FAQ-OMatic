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

### FaqLocalAuth.pm -- where you can define a local authorization
### routine. It should take parameters from 

package FAQ::OMatic::AuthLocal;

sub authenticate {
	my $params = shift;

	my $auth = $params->{'auth'};

	# if there's a cookie...
	if ($auth =~ m/^ck/) {
		my ($cookie,$cid,$ctime) = FAQ::OMatic::Auth::findCookie($auth,'cookie');
		# and it's good, then return the implied id
		return ($cid,5) if (defined $cid);
		# if it's bad, fall through and inherit anonymous auth
	}

	# if we authenticate...
	if ($params->{'auth'} eq 'pass') {
		my $id = $params->{'_pass_id'};
		my $pass = $params->{'_pass_pass'};
		my ($idf,$passf,@rest) = FAQ::OMatic::Auth::readIDfile($id);
		if ((defined $idf)
			and ($idf eq $id)
			and ($passf ne '__INVALID__')	# avoid the obvious vandal's hole...
			and FAQ::OMatic::Auth::checkCryptPass($pass, $passf)) {
			# set up a cookie to use for a shortcut later,
			# and return the authentication pair
			$params->{'auth'} = FAQ::OMatic::Auth::newCookie($id);
			return ($id,5);
		} else {
			# let authenticate know to report the bad password
			$params->{'badPass'} = 1;
			# fall through to inherit some crummier Authentication Quality
		}
	}

	if (($params->{'auth'} eq 'none')
		and (defined $params->{'_none_id'})) {
		# move id where we can pass it around
		$params->{'id'} = $params->{'_none_id'};
	}

	# default authentication: whatever id we can come up with,
	# but quality is at most 3
	my $id = $params->{'id'} || 'anonymous';
	my $aq = $params->{'id'} ? 3 : 1;
	return ($id, $aq);
}

1;
