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
### Appearance.pm
###
### These and variables functions supply some of the appearance
### of Faq-O-Matic pages.
###

package FAQ::OMatic::Appearance;

# These control the overall appearance of the page (background color/gif,
# title string). Please leave the string in the footer that identifies
# the author and the homepage of Faq-O-Matic.
sub cPageHeader {
	my $params = shift;
	my $suppressType = shift || '';
	# this is a func because FAQ::OMatic::fomTitle() isn't well-defined at
	# global initialization time.
	my $type = ($suppressType) ? '' : "Content-type: text/html\n\n";
	return $type
			."<html><head><title>".FAQ::OMatic::fomTitle()
			.FAQ::OMatic::pageDesc($params)."</title></head>\n"
			."<body bgcolor=\"$FAQ::OMatic::Config::backgroundColor\" "
			."text=$FAQ::OMatic::Config::textColor "
			."link=$FAQ::OMatic::Config::linkColor "
			."vlink=$FAQ::OMatic::Config::vlinkColor>\n";
}

sub cPageFooter {
	my $params = shift;		# hash ref
	my $showLinks = shift || [];	# ref to array of links to show
	my $numCells = 0;

	my @sl;
	if ($showLinks eq 'all') {
		@sl = ('help', 'search', 'appearance', 'entire', 'edit');
	} elsif (ref $showLinks) {
		@sl = @{$showLinks};
	}
	my %sl = map {$_=>$_} @sl;
	$showLinks = \%sl;

	my $page= "\n"
			.partStart({})
			."<table width=\"100%\">\n";
	#my $boxColor = "bgcolor=\"$FAQ::OMatic::Config::backgroundColor\"";
	my $boxColor = '';
	my $filename = $params->{'file'} || '1';
	my $recurse = $params->{'_recurse'} || '';
	my $item = new FAQ::OMatic::Item($filename);
	$page.="<tr>\n";

	if ($showLinks->{'help'}) {
		$page.=helpButton($params);
		$numCells++;
	}

	if ($showLinks->{'search'}) {
		# Search Form
		$page.="<td align=center $boxColor>"
			.FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'searchForm',
					'-params'=>$params),
				"Search</a>")
			."</td>\n";
		$numCells++;
	}

	if ($showLinks->{'appearance'}) {
		# Appearance Options
		$page.="<td align=center $boxColor>"
			.FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'appearanceForm',
					'-params'=>$params),
			"Appearance")
			."</td>\n";
		$numCells++;
	}

	if ($showLinks->{'entire'}) {
		# Show This Entire Category
		if ($item->isCategory() and (not $recurse)) {
			$page.="<td align=center $boxColor>"
				.FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'faq',
						'-params'=>$params,
						'-changedParams'=>{'_recurse'=>1}),
					"Show This <em>Entire</em> Category</a>")
				."</td>\n";
		} else {
			$page.="<td align=center></td>\n";
		}
		$numCells++;
	}

	if ($showLinks->{'edit'}) {
		# Show Edit Commands
		$page.="<td align=center $boxColor>";
		if ($params->{'showEditCmds'}) {
			$page.=FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'faq',
					'-params'=>$params,
					'-changedParams'=>{'showEditCmds'=>''}),
				"Hide Edit Commands");
		} else {
			$page.=FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'faq',
					'-params'=>$params,
					'-changedParams'=>{'showEditCmds'=>'1'}),
				"Show Edit Commands");
		}
		$page.="</td>\n";
		$numCells++;
	}

	if ($showLinks->{'faq'}) {
		# Show Edit Commands
		my $cmd = $params->{'cmd'} || '';
		if ($cmd ne '' and $cmd ne 'faq') {
			$page.="<td align=center $boxColor>";
			$page.=FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'faq',
					'-params'=>$params,
# kill unneeded params from 'authenticate':
					'-changedParams'=>{'partnum'=>'',
						'checkSequenceNumber'=>''},
				),
				"Return to FAQ");
			$numCells++;
		}
	}

	$page.="</tr>\n";

	$page.=	"<tr><td colspan=$numCells align=center>\n"
			."The <a href=\"http://www.dartmouth.edu/cgi-bin/cgiwrap/jonh/faq.pl\">Faq-O-Matic</a> is by <a href=\"http://www.cs.dartmouth.edu/~jonh\">Jon&nbsp;Howell</a>.\n"
			."</td></tr>"
			."</table>"
			.partEnd({})
			."</body></html>\n";
	return $page;
}

sub helpButton {
	my $params = shift;
	my $page = '';
	my $cmd = $params->{'cmd'} || '';

	# Help
	# -- disabled for this version, since it's not completely implemented
	# or very tested. all the other code is here, there's just no
	# "front door" to get into the help system through.
#	if ($params->{'help'}) {
#		$page.="<td align=center $boxColor>"
#			.FAQ::OMatic::button(
#				FAQ::OMatic::makeAref('-command'=>$cmd,
#					'-params'=>$params,
#					'-changedParams'=>{'help'=>''},
#					'-saveTransients'=>1,
#					'-target'=>'_top'),
#				"Hide Help")
#			."</td>\n";
#	} else {
#		$page.="<td align=center $boxColor>"
#			.FAQ::OMatic::button(
#				FAQ::OMatic::makeAref('-command'=>'help',
#					'-params'=>$params,
#					'-changedParams'=>{'_onCmd'=>$cmd},
#					'-saveTransients'=>1,
#					'-target'=>'_top'),
#				"Help")
#			."</td>\n";
#	}

	return $page;
}

# This is called before every item is printed. (There are multiple
# items in the "[Show All Items Below Here]" display and the search
# output.)
sub itemStart {
	my $params = shift;
	my $alreadyStart = $params->{'_as'} || '';	# info hidden away in $params
	if (not $alreadyStart) {
		$params->{'_as'} = 1;
		if (not $params->{'simple'}) {
			return
				"<table width=100%><tr><td bgcolor=$FAQ::OMatic::Config::itemBarColor>"
				."&nbsp;</td><td>\n";
		} else {
			return "";
		}
	} else {
		if (not $params->{'simple'}) {
			return "</td></tr><tr><td bgcolor=$FAQ::OMatic::Config::itemBarColor>"
					."&nbsp;</td><td>\n";
		} else {
			return "<p>";
		}
	}
}

# This is called only once, after the last item is drawn.
sub itemEnd {
	my $params = shift;
	if (not $params->{'simple'}) {
		return "</td></tr></table>\n";
	} else {
		return "<hr>";
	}
}

# These are called before and after drawing each part.
sub partStart {
	my $params = shift;
	my $part = shift;	# can examine the part to see if it's a directory

	if (not $params->{'simple'}) {
		if (($part->{'Type'} || '') eq 'directory') {
			return "<table bgcolor=$FAQ::OMatic::Config::directoryPartColor "
				."width=\"100%\"><tr><td>\n";
		} else {
			return "<table bgcolor=$FAQ::OMatic::Config::regularPartColor "
				."width=\"100%\"><tr><td>\n";
		}
	} else {
		return "<br>\n";
	}
}

sub partEnd {
	my $params = shift;
	if (not $params->{'simple'}) {
		return "</td></tr></table>\n";
	} else {
		return "<br>";
	}
}

# These surround the editing buttons. I make them smaller so they'll
# not look as much like part of the item being displayed, and more
# like little intruders.
$editStart = "<font size=-1>";
$editEnd = "</font>";

# These surround words in the document that were in a search query.
$highlightColor	= $FAQ::OMatic::Config::highlightColor || "#a01010";
$highlightStart = "<font color=$highlightColor><b>";
$highlightEnd	= "</b></font>";

$graphHistory	= 60;	# default graphs show data going back two months
$graphWidth		= 250;	# image size of stats graphs
$graphHeight	= 180;

1;
