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

package FAQ::OMatic::buildSearchDB;

use FAQ::OMatic::Item;
use FAQ::OMatic;

sub build {
	my $words = {};

	# Notice we don't bother doing this recursively -- faqs
	# can be in a state where not everybody shares a common root.
	# (This does search the trash, however, which is not necessarily
	# what you want.)
	# Mental note: If I switch back to recursive search from a common
	# root, I should remember to turn the recursion back on in
	# FAQ::OMatic::Item::extractWords.
	my @allItems = FAQ::OMatic::getAllItemNames();
	my $filename;
	my $item;
	foreach $filename (@allItems) {
		$item = new FAQ::OMatic::Item($filename);
		$item->extractWords($words);
	}

	my @wordlist = sort keys %{$words};

	## Build the files in temporaries, so searching still works during the
	## re-extraction. In fact, a running search process will continue to
	## use the old ones (and not get confused when we mv in the new ones)
	## because of Unix' cool file semantics.

	dbmopen %wordsdb, "$FAQ::OMatic::Config::metaDir/search$$", 600;
	open INDEXFILE, ">$FAQ::OMatic::Config::metaDir/search$$.index" or die ".index $!";
	open WORDSFILE, ">$FAQ::OMatic::Config::metaDir/search$$.words" or die ".words $!";

	foreach $i (@wordlist) {
		## Write down in the hash the file pointer where we can find
		## this entry:
		$wordsdb{$i} = (tell INDEXFILE)." ".(tell WORDSFILE);
		## Then dump out all the items with this word in them:
		my @list = sort keys %{ $words->{$i} };
		foreach $j (@list) {
			print INDEXFILE "$j\n";
		}
		## And append the word to the words file
		print WORDSFILE "$i\n";
		## terminate the list
		print INDEXFILE "END\n";
	}
	dbmclose %wordsdb;
	close INDEXFILE;
	close WORDSFILE;

	## make sure the files are readable
	# Using wildcards lets us remain ignorant of dbm's extension(s), which
	# vary machine to machine.
	my @searchfiles = FAQ::OMatic::safeGlob($FAQ::OMatic::Config::metaDir,
						"^search$$");

	foreach $i (@searchfiles) {
		chmod 0644, $i;
	}

	foreach $i (@searchfiles) {
		my $j = $i;
		$j =~ s/$$//;
		rename($i,$j) or FAQ::OMatic::gripe('debug', "rename($i,$j) failed");
	}

	# create a freshSearchDBHint to let me know I don't need to do
	# this again any time soon.
	open SEARCHHINT, ">$FAQ::OMatic::Config::metaDir/freshSearchDBHint";
	close SEARCHHINT;
}

1;
