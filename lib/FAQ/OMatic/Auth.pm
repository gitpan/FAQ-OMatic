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

###
### The FaqAuth module provides identification, authentication,
### and authorization services for the Faq-O-Matic.
###
### Custom authentication schemes should
### be implemented by using the hooks in this module. (For
### now there are no hooks, but in theory there should be one
### replaceable function.) You'd rather not modify this file,
### so you can be drop-in compatible with future faqomatic
### releases.
###

package FAQ::OMatic::Auth;

use FAQ::OMatic;
use FAQ::OMatic::Item;
use FAQ::OMatic::AuthLocal;
use FAQ::OMatic::Groups;

$trustedID = undef;
						# Perm values only:
						# '7','9' -- returned by perm routines to indicate
						#		authQuality must be 5, and user must be the
						#		moderator of the item.
						# '6' -- a perm that indicates a group membership
						#		requirement. (actually "6 group_name".)
						# $authQuality's and Perm* values:
$authQuality = undef;	# '5' -- user has provided proof that ID is correct
						# '3' -- user has merely claimed this ID
						# '1' -- no ID is offered

# If anyone thinks these should be user-configurable, let me know
# and I'll move them to FaqConfig.pm in the next release. --jonh
$cookieLife = 3600;	# 60 sec * 60 min == 1 hour
$cookieExtra = 600;	# 10 extra minutes to submit forms after filling them out
					# so you don't have to worry about losing your text.
$cookieActual = $cookieLife;

sub getID {
	my $params = \%FAQ::OMatic::theParams;

	if (not defined $trustedID) {
		if (defined $params->{'auth'}) {
			# use a user-overridable auth function
			($trustedID,$authQuality) = authenticate($params);
		} elsif (defined $params->{'id'}) {
			# id without authorization
			$trustedID = $params->{'id'};
			$authQuality = 3;
		} else {
			# no authorization offered
			$trustedID = 'anonymous';
			$authQuality = 1;
		}
	}

	return ($trustedID,$authQuality);
}

# result is 'false' if user CAN edit the part, else an error message
sub checkPerm {
	my $item = shift;
	my $operation = shift;

	my ($id,$aq) = getID();
	my $whocan = getInheritedProperty($item, $operation);

	# if just some low quality of authentication is required, prove
	# user has provided it:
	if ($whocan <= 5 and $whocan <= $aq) {
		# users' ID dominates required ID
		return 0;
	}

	# prove user belongs to required group:
	if ($whocan == 6 and FAQ::OMatic::Groups::checkMembership($whocan, $id)) {
		# user belongs to the specified group
		return 0;
	}

	# prove user has at least moderator priveleges, if this is for
	# an item:
	if ($item
		and (($whocan==7) and ($aq==5))
		and (($id eq getInheritedProperty($item, 'Moderator'))
			 or ($id eq $FAQ::OMatic::Config::adminAuth)
			 or ('anybody' eq getInheritedProperty($item, 'Moderator'))
			)
		) {
		# user has proven authentication, and is the moderator of the item
		return 0;
	}

	return $whocan;
}

sub getInheritedProperty {
	my $item = shift;
	my $property = shift;
	my $depth = shift || 0;

	return "6 Administrators" if ($property eq 'PermEditGroups');

	return $item->{$property} if (defined $item->{$property});

	if (($item->getParent() eq $item) or ($depth > 80)) {
		# no-one defines it, all the way up the chain
		if ($property eq 'Moderator') {
			return 'nobody';
		} elsif ($property eq 'PermEditItem'
				or $property eq 'PermEditPart'
				or $property eq 'PermUseHTML'
				or $property eq 'PermAddPart') {
			# default: require proven authentication
			return 5;
		} elsif ($property eq 'PermModOptions') {
			return 7;
		} else {
			return undef;
		}
	} else {
		return getInheritedProperty($item->getParent(), $property, $depth+1);
	}
}

# ensurePerm()
# Checks permissions, returns '' if okay, else returns a redirect to
# authenticate.
# In list context, returns the same value followed by a quality
# value, so if you require two ensurePerms, you return the redirect
# with the higher qualityf value (so the user gets all the authentication
# done at once). See submitMove.
# A good use is:
# my $rd = ensurePerm(...);
# if ($rd) { print $rd; exit 0; }
sub ensurePerm {
	my $item = shift;
	my $operation = shift;
	my $restart = shift;	# which program to run to restart operation
							# after user presents ID
	my $cgi = shift;
	my $extraTime = shift;	# allow slightly stale cookies, so that a
							# cookie isn't likely to time out between
							# clicking "edit" and "submit", which annoys.
	my $xreason = shift;	# an extra reason, needed to distinguish
							# two cases (modOptions) in editItem.
	my $result = '';

	$cookieActual += $cookieExtra if ($extraTime);

	my $authFailed = checkPerm($item,$operation);

	if ($authFailed) {
		my $url = FAQ::OMatic::makeAref('authenticate',
			{'_restart' => $restart, '_reason'=>$authFailed,
			 '_xreason'=>$xreason}, 'url', 'saveTransients');
		$result = $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
	}

	return wantarray	? ($result, $authFailed)
						: $result;
}

sub newCookie {
	my $id = shift;

	# Use an existing cookie if available. (why is this good? Just
	# to keep the cookies file slimmer?)
	my ($cookie,$cid,$ctime);
	($cookie,$cid,$ctime) = findCookie($id,'id');
	return $cookie if (defined $cookie);

	srand(time() ^ ($$ + ($$ << 15)) );	# camel book, 2 ed, p 223
	$cookie = "ck".getRandomHex();

	open COOKIEFILE, ">>$FAQ::OMatic::Config::metaDir/cookies";
	print COOKIEFILE "$cookie $id ".time()."\n";
	close COOKIEFILE;

	return $cookie;
}

sub getRandomHex {
	srand(time() ^ ($$ + ($$ << 15)) );	# camel book, 2 ed, p 223
	return sprintf "%04x%04x%04x", rand(1<<16), rand(1<<16), rand(1<<16);
}

sub findCookie {
	my $match = shift;
	my $by = shift;

	my ($cookie,$cid,$ctime);
	open COOKIEFILE, "<$FAQ::OMatic::Config::metaDir/cookies";
	while (<COOKIEFILE>) {
		chomp;
		($cookie,$cid,$ctime) = split(' ');

		# ignore dead cookies
		next if ((time() - $ctime) > $cookieActual);

		if (($by eq 'id') and ($cid eq $match)) {
			close COOKIEFILE;
			return ($cookie,$cid,$ctime);
		}
		if (($by eq 'cookie') and ($cookie eq $match)) {
			close COOKIEFILE;
			return ($cookie,$cid,$ctime);
		}
	}
	close COOKIEFILE;
	return undef;
}

# these functions manipulate a file that maps IDs to
# (ID,password,...) tuples. (... = future expansion)
# Right now it's a flat file, but maybe someday it should be a
# dbm file if anyone ever has zillions of authorized posters.

# given an ($id,$password,...) array, writes it into idfile
sub writeIDfile {
	my ($id,$password,@rest) = @_;

	my $lockf = FAQ::OMatic::lockFile("idfile");
	FAQ::OMatic::gripe('error', "idfile is locked.") if (not $lockf);

	if (not open(IDFILE, "<$FAQ::OMatic::Config::metaDir/idfile")) {
		FAQ::OMatic::unlockFile($lockf);
		FAQ::OMatic::gripe('abort', "FAQ::OMatic::Auth::writeIDfile: Couldn't "
				."read $FAQ::OMatic::Config::metaDir/idfile because $!");
		return;
	}

	# read id mappings in
	my %idmap;
	my ($idf,$passf,@restf);
	while (<IDFILE>) {
		chomp;
		($idf,$passf,@restf) = split(' ');
		$idmap{$idf} = $_;
	}
	close IDFILE;

	# change the mapping for id
	$idmap{$id} = join(' ', $id, $password, @rest);
	
	# write id mappings.
	if (not open(IDFILE, ">$FAQ::OMatic::Config::metaDir/idfile-new")) {
		FAQ::OMatic::unlockFile($lockf);
		FAQ::OMatic::gripe('abort', "FAQ::OMatic::Auth::writeIDfile: Couldn't "
				."write $FAQ::OMatic::Config::metaDir/idfile-new because $!");
		return;
	}

	foreach $idf (sort keys %idmap) {
		print IDFILE $idmap{$idf}."\n";
	}
	close IDFILE;

	unlink("$FAQ::OMatic::Config::metaDir/idfile") or
		FAQ::OMatic::gripe('abort', "FAQ::OMatic::Auth::writeIDfile: Couldn't "
				."unlink $FAQ::OMatic::Config::metaDir/idfile because $!");
	rename("$FAQ::OMatic::Config::metaDir/idfile-new", "$FAQ::OMatic::Config::metaDir/idfile") or
		FAQ::OMatic::gripe('abort', "FAQ::OMatic::Auth::writeIDfile: Couldn't "
				."rename $FAQ::OMatic::Config::metaDir/idfile-new to idfile because $!");
	chmod 0600, "$FAQ::OMatic::Config::metaDir/idfile" or
		FAQ::OMatic::gripe('problem', "FAQ::OMatic::Auth::writeIDfile: Couldn't "
				."chmod $FAQ::OMatic::Config::metaDir/idfile because $!");
	
	FAQ::OMatic::unlockFile($lockf);
}

# given an id, returns an array starting ($id,$password,...)
sub readIDfile {
	my $id = shift;		# key to lookup on
	my $dontHideVersion = shift;
						# keep regular lookups from seeing version number
						# record. (smacks of a hack, but this is Perl!)

	return undef if (($id eq 'version') and (not $dontHideVersion));

	my $lockf = FAQ::OMatic::lockFile("idfile");
	FAQ::OMatic::gripe('error', "idfile is locked.") if (not $lockf);

	if (not open(IDFILE, "<$FAQ::OMatic::Config::metaDir/idfile")) {
		FAQ::OMatic::unlockFile($lockf);
		FAQ::OMatic::gripe('abort', "FAQ::OMatic::Auth::readIDfile: Couldn't "
				."read $FAQ::OMatic::Config::metaDir/idfile because $!");
		return undef;
	}

	my ($idf,$passf,@restf);
	while (<IDFILE>) {
		chomp;
		($idf,$passf,@restf) = split(' ');
		last if ($idf eq $id);
	}
	close IDFILE;

	FAQ::OMatic::unlockFile($lockf);

	return ($idf,$passf,@restf) if ($idf eq $id);

	return undef;
}

sub checkCryptPass {
	my ($cleartext, $crypted) = @_;
	#my $salt = substr($crypted, 0, 2);
	# specific fix from Evan Torrie <torrie@pi.pair.com>: most crypt()s
	# don't care of there's excess salt, and those with MD5 crypts use
	# more than the first two bytes as salt.
	my $salt = $crypted;
	return (crypt($cleartext, $salt) eq $crypted);
}

sub cryptPass {
	my $pass = shift;
	srand(time() ^ ($$ + ($$ << 15)) );	# camel book, 2 ed, p 223
	my $salt = pack('cc', 65+rand(16), 65+rand(16));
	#FAQ::OMatic::gripe('note', "crypt($pass,$salt) = ".crypt($pass,$salt));
	return crypt($pass,$salt);
}

sub authenticate {
	my $params = shift;

	my $auth = $params->{'auth'};

	# if there's a cookie...
	if ($auth =~ m/^ck/) {
		my ($cookie,$cid,$ctime) = findCookie($auth,'cookie');
		# and it's good, then return the implied id
		return ($cid,5) if (defined $cid);
		# if it's bad, fall through and inherit anonymous auth
	}

	# if we authenticate...
	if ($params->{'auth'} eq 'pass' or
		(($params->{'_none_id'} eq '') and ($params->{'_pass_id'} ne ''))) {
		my $id = $params->{'_pass_id'};
		my $pass = $params->{'_pass_pass'};
		if (FAQ::OMatic::AuthLocal::checkPassword($id, $pass)) {
			# set up a cookie to use for a shortcut later,
			# and return the authentication pair
			$params->{'auth'} = newCookie($id);
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

%staticErrors = (
	9 => 'the administrator of this Faq-O-Matic',
	7 => 'the moderator of the item',
	5 => 'someone who has proven their identification',
	3 => 'someone who has offered identification',
	1 => 'anybody' );

sub authError {
	my $reason = shift;

	return $staticErrors{$reason} if ($staticErrors{$reason});

	if ($reason =~ m/^6/) {
		return FAQ::OMatic::Groups::groupCodeToName($reason)." group members";
	}

	return "I don't know who";
}

1;
