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
### The Bags module provides services related to bit bags,
### binary files stored with and linked to by a FAQ-O-Matic.
###

package FAQ::OMatic::Bags;

use FAQ::OMatic;
use FAQ::OMatic::Item;

sub getBagDesc {
	# return an item containing descriptive properties about
	# a bag
	my $bagName = shift;

	my $bagDesc = new FAQ::OMatic::Item($bagName.".desc",
		$FAQ::OMatic::Config::bagsDir);

	# if it didn't exist before...
	$bagDesc->setProperty('Title', 'Bag Description');
	$bagDesc->setProperty('filename', $bagName.".desc");

	return $bagDesc;
}

sub getBagProperty {
	my $bagName = shift;
	my $property = shift;
	my $default = shift || '';

	my $bagDesc = getBagDesc($bagName);
	return $bagDesc->getProperty($property) || $default;
}

sub saveBagDesc {
	my $bagDesc = shift;

	$bagDesc->saveToFile('',
		$FAQ::OMatic::Config::bagsDir);
}

1;
