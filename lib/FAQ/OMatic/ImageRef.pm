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
### ImageRef.pm
###
### Generates references to the images encoded in ImageData.pm
### (note this only makes sense for built-in images, not those sumbitted
### into the serve/bags/ directory.)
###

package FAQ::OMatic::ImageRef;
use FAQ::OMatic::ImageData;

%type = ();     # type of each image

sub getImage {
	my $name = shift;

	my $data = $FAQ::OMatic::ImageData::img{$name};
	return '' if (not defined $data);

	$data =~ s/\n//gs;	# get rid of line terminators
	return pack("H".length($data), $data);
}

sub getType {
	my $name = shift;

	my $typek = $type{$name};
	return '' if (not defined $typek);

	return "jpeg"	if ($typek eq 'jpg');
	return "gif"	if ($typek eq 'gif');
	return "beats-me";
}

sub getImageUrl {
	my $name = shift;
	my $type = getType($name);
	return '' if (not $type);

	my $cachedCopy = $FAQ::OMatic::Config::bagsDir."$name.$type";
	if (-f $cachedCopy) {
		return $FAQ::OMatic::Config::bagsURL."$name.$type";
	}
	# attempt to cache this image file
	if (not open(CACHEIMAGE, ">$cachedCopy")) {
		FAQ::OMatic::gripe('problem',
			"write to $cachedCopy failed: $!");
		# TODO: write to cache failed. Notify admin?
		# in the meantime, supply user with dynamically-generated image file
		return FAQ::OMatic::makeAref('-command'=>'img',
			'-blastAll'=>1,
			'-changedParams'=>{'name'=>$name},
			'-refType'=>'url');
	}
	print CACHEIMAGE getImage($name);
	close CACHEIMAGE;
	return $FAQ::OMatic::Config::bagsURL."$name.$type";
}

sub getImageRef {
	my $name = shift;
	my $imgargs = shift;

	return '&nbsp;' if (defined($FAQ::OMatic::Config::noImages));
	

	my $url = getImageUrl($name);
	return "[bad image $name]" if (not $url);
	## TODO: add size info!
	return "<img src=\"$url\" $imgargs>";
}

sub getImageRefCA {
	my $name = shift;
	my $imgargs = shift;
	my $ca = shift;	 # Category or Answer

	$name = ($ca eq 'Category' ? 'cat' : 'ans').$name;

	return getImageRef($name, $imgargs);
}

# to regenerate:
#:.,$-2!(cd ../../../img; encodeBin.pl * | grep '^$type')

$type{'ans-also'} = 'gif';
$type{'ans-del-part'} = 'gif';
$type{'ans-dup-ans'} = 'gif';
$type{'ans-dup-part'} = 'gif';
$type{'ans-edit-part'} = 'gif';
$type{'ans-ins-part'} = 'gif';
$type{'ans-opts'} = 'gif';
$type{'ans-reorder'} = 'gif';
$type{'ans-small'} = 'gif';
$type{'ans-title'} = 'gif';
$type{'ans-to-cat'} = 'gif';
$type{'ans'} = 'gif';
$type{'cat-also'} = 'gif';
$type{'cat-del-part'} = 'gif';
$type{'cat-dup-ans'} = 'gif';
$type{'cat-dup-part'} = 'gif';
$type{'cat-edit-part'} = 'gif';
$type{'cat-ins-part'} = 'gif';
$type{'cat-new-ans'} = 'gif';
$type{'cat-new-cat'} = 'gif';
$type{'cat-opts'} = 'gif';
$type{'cat-reorder'} = 'gif';
$type{'cat-small'} = 'gif';
$type{'cat-title'} = 'gif';
$type{'cat'} = 'gif';
$type{'checked'} = 'gif';
$type{'help-small'} = 'gif';
$type{'help'} = 'gif';
$type{'picker'} = 'jpg';
$type{'space'} = 'gif';
$type{'unchecked'} = 'gif';

1;
