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

### FaqSearch.pm
###
### Support for search functions
###

package FAQ::OMatic::Search;

use FAQ::OMatic::Item;
use FAQ::OMatic;

my %wordDB;

sub openWordDB {
	return if (defined %wordDB);
	if (not dbmopen (%wordDB, "$FAQ::OMatic::Config::metaDir/search", 400)) {
		FAQ::OMatic::gripe('abort', "Can't open dbm search database. "
			."Have you run buildSearchDB? (Should I?)");
	}
	if (not open(WORDSFILE, "<$FAQ::OMatic::Config::metaDir/search.words")) {
		FAQ::OMatic::gripe('abort', "Can't open search.words. "
			."Have you run buildSearchDB? (Should I?)");
	}
	if (not open(INDEXFILE, "<$FAQ::OMatic::Config::metaDir/search.index")) {
		FAQ::OMatic::gripe('abort', "Can't open search.index. "
			."Have you run buildSearchDB? (Should I?)");
	}
}

sub closeWordDB {
	dbmclose %wordDB;
	undef %wordDB;
	close WORDSFILE;
	close INDEXFILE;
}

sub getIndices {
	my $word = shift;
	return split(' ', $wordDB{$word});
	# returns indexseek,wordseek pair
}

sub getWordClass {
	my $word = shift;
	my @wordclass = ();

	openWordDB();
	
	my ($indexseek, $wordseek) = getIndices($word);

	#grab all words in wordsfile with $word as a prefix
	seek WORDSFILE, $wordseek, 0;
	while (<WORDSFILE>) {
		chomp;
		if (m/^$word/) {
			push @wordclass, $_;
		} else {
			last;
		}
	}

	return \@wordclass;
}

sub getMatchesForClass {
	my $classref = shift;	# array ref for a class of "identical" words
	my %files;

	my $word;
	foreach $word (@{$classref}) {
		my ($indexseek,$wordseek) = getIndices($word);
		seek INDEXFILE, $indexseek, 0;
		while (<INDEXFILE>) {
			chomp;
			last if (m/^END$/);
			$files{$_}=1;
		}
	}

	my @matches = sort keys %files;
	return \@matches;
}

sub getMatchesForSet {
	my $params = shift;
	my $setref = $params->{'_searchArray'};
							# array ref for complete set of user words to search

	$params->{'_minMatches'} = 'all' if ($params->{'_minMatches'} eq '');
	my $minhits = $params->{'_minMatches'};
							# we return only files with at least this many hits
	if ($minhits eq 'all') {	# convert symbolic hits to a number
		$minhits = scalar(@{$setref});
	}
	$params->{'_actualMatches'} = $minhits;

	my %accumulator=();
	my @hitfiles=();

	my $word, $file;
	foreach $word (@{$setref}) {
		my $classref = getWordClass($word);
		my $matches = getMatchesForClass($classref);
		foreach $file (@{$matches}) {
			$accumulator{$file}++;
		}
	}

	foreach $file (sort keys %accumulator) {
		if ($accumulator{$file} >= $minhits) {
			push @hitfiles, $file;
		}
	}

	return \@hitfiles;
}

sub convertSearchParams {
	my $params = shift;
	my $pattern;

	# given a user-input search string, we break it into "legal" words
	# and store it in another parameter.
	
	$pattern = $params->{'_search'};
	$pattern =~ s/'//g;		# apostrophes don't count
	$pattern =~ tr/[A-Z/[a-z]/;
	@patternwords = ($pattern =~ m/[A-Za-z0-9]+/gs);

	$params->{'_searchArray'} = \@patternwords;
}

sub addNewFiles {
	my $wordset = shift;	#ary ref
	my $fileset = shift;	# hash ref -- where to add results
	my $words = {};

	# Get the list of files touched since last searchDB build
	if (not open HINTS, "<$FAQ::OMatic::Config::metaDir/searchHints") {
		# sorry, can't help ya
		return;
	}
	my @touchedFiles = <HINTS>;
	close HINTS;

	# index each item
	my $filename;
	my $item;
	foreach $filename (@touchedFiles) {
		chomp $filename;
		$item = new FAQ::OMatic::Item($filename);
		$item->extractWords($words);
	}

	# for every word in the wordset, add all the files it appears
	# in to the fileset passed to us.
	my $word;
	foreach $word (@{$wordset}) {
		if ($words->{$word}) {
			foreach $filename (keys %{$words->{$word}}) {
				$fileset->{$filename} = 1;
			}
		}
	}

	# notice that if there were suffixes of the user's requested words
	# in the new content that weren't in the system anywhere when the
	# searchDB was built, then those suffixes won't be in the wordset,
	# and the search will miss them. Hey, wah, this is better than
	# missing ALL the new content, okay? :v)

	# this also screws up the counts of how many matches this file
	# had (since it could contribute matches from the searchDB lookup
	# AND the newFiles lookup), so I'm going to leave it turned off
	# for now. Rats.
}

sub getRecentSet {
	my $params = shift;
	my $recentList = [];

	$durationdays = $params->{'_duration'};

	my $filei;
	foreach $filei (FAQ::OMatic::getAllItemNames()) {
		if (-M "$FAQ::OMatic::Config::itemDir/$filei" < $durationdays) {
			push @{$recentList}, $filei;
		}
	}

	return $recentList;
}

true;
