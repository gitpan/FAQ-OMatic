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

##
## Intl.pm
##
## This file will contain data that assists in the internationalization
## of Faq-O-Matic. That way, all the user-visible text can be translated
## in one place (here), and when you upgrade Faq-O-Matic, you don't have
## to re-translate (much).
##

package FAQ::OMatic::Intl;

use vars qw(%pageDesc);

%pageDesc = (
	'authenticate' => 'Log In',
	'changePass' => 'Change Password',
	'editItem' => 'Edit Item',
	'insertItem' => 'Insert Item',	# special case -- varies editItem
	'editPart' => 'Edit Part',
	'insertPart' => 'Insert Part',	# special case -- varies editPart
	'faq' => 'FAQ',					# special case -- insert item title
	'moveItem' => 'Move Item',
	'search' => 'Search',
	'stats' => 'Access Statistics',
	'submitPass' => 'Validate'
);

1;
