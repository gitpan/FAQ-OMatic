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

### Words.pm
###
### Support for extracting "words" from strings
###
### To change these routines to support other character sets,
### copy this file to a location outside of the FAQ::OMatic tree and
### add the following lines to the start of your cgi-bin/fom file:
###	use lib '/Whatever/your/directory/path/is';
###	require Words;
###	#existing use lib line
###	use FAQ::OMatic::Words
### This will override the definitions in this file.


package FAQ::OMatic::Words;

sub cannonical {
    my $string = shift;

    # convert the input string into cannonical form.
    #
    # The default is to strip parenthesis and apostrophies, and
    # convert to ASCII lower case.
    #
    # If you use another character set (e.g. ISO-8859-?), you'll want
    # to override to do correct lower case handling.
    #
    # This routine is called both when the indicies are created and
    # when the search pattern is formed, so things will be done
    # consistantly.

    # convert
    #	timer(s) to timers
    #   timer's to timers
    #   e-mail  to email
    $string =~ s/[()'-]//g;
    $string =~ tr/A-Z/a-z/;  # 7-bit ASCII

#    # for ISO-8859-1 char set, add
#    $string =~ tr/\300-\326/\340-\366/; # from &Agrave; through &Ouml;
#					# into &agrave; through &ouml;
#    $string =~ tr/\330-\336/\370-\376/; # from &Oslash; through &THORN;
#					# into &oslash; through &thorn;

    $string;
}

sub getWords {
	my $string = shift;

	# given a user-input string, we break it into "legal" words
	# and return an array of them
	
	$string = cannonical( $string );

	my $wordPattern = '[A-Za-z0-9\-]';
	# for ISO-8859-1 char set, try
	#my $wordPattern = '[A-Za-z0-9\-\300-\326\330-\366\370-\377]';
	my @words = ($string =~ m/($wordPattern+)/gso);

	@words;
}

sub getPrefixes {
    my $word = shift;

    # given a word, return an array of prefixes which should be
    # indexed.
    #
    # default routine returns all substrings
    my @prefix;
    my $i = length( $word );
    while( $i ) {
        push @prefix, substr( $word, 0, $i-- );
    }

    @prefix;
}

'true';
