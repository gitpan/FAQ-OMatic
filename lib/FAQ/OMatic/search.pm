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

package FAQ::OMatic::search;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;
use FAQ::OMatic::Search;
use FAQ::OMatic::Appearance;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	FAQ::OMatic::getParams($cgi);
	my $params = \%FAQ::OMatic::theParams;

	# Convert user input into a set of searchable words
	FAQ::OMatic::Search::convertSearchParams($params);

	if (scalar(@{$params->{_searchArray}})==0) {
		my $url = FAQ::OMatic::makeAref('faq', {}, 'url');
		$cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
	}

	# Get the names of the matching files
	my $matchset = FAQ::OMatic::Search::getMatchesForSet($params);

	# Filter out those in the trash
	# THANKS: dschulte@facstaff.wisc.edu for the suggestion
	# I have no idea why grep{} won't work here, but I couldn't get it to.
	my @finalset = ();
	my $file;
	foreach $file (@{$matchset}) {
		my $item = new FAQ::OMatic::Item($file);
		if (not $item->hasParent('trash')) {
			push @finalset, $item;
		}
	}

	my $rt = FAQ::OMatic::pageHeader();
	if (scalar(@{$matchset})==0) {
		$rt.="No items matched "
			.$params->{'_minMatches'}." of these words: <i>"
			.join(", ", @{$params->{'_searchArray'}})
			."</i>.\n<br>\n";
	} else {
		$rt.="Search results for "
			.($params->{'_minMatches'} eq 'all' ?
				'all' : "at least ".$params->{'_minMatches'})
			." of these words: <i>"
			.join(", ", @{$params->{'_searchArray'}})
			."</i>:<p>\n";

		my $item;
		my $itemboxes = [];
		foreach $item (@finalset) {
			push @$itemboxes, $item->displaySearchContext($params);
		}
		$rt .= FAQ::OMatic::Appearance::itemRender($params, $itemboxes);
	}

	if (not -f "$FAQ::OMatic::Config::metaDir/freshSearchDBHint") {
		$rt .= "<br>Results may be incomplete, because the search "
			."index has not been refreshed since the most recent change "
			."to the database.<p>\n";
	}

	$rt.=FAQ::OMatic::Help::helpFor($params,
		'Search Tips', "<br>");

#	$rt.=FAQ::OMatic::button(
#		FAQ::OMatic::makeAref('faq', {'_minMatches'=>'','search'=>''}),
#		'Return to FAQ');
	
	$rt .= FAQ::OMatic::pageFooter($params, ['search', 'faq']);

	print $rt;

	FAQ::OMatic::Search::closeWordDB();
}

1;
