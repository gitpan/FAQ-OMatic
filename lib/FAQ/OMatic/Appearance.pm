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

###
### Appearance.pm
###
### These and variables functions supply some of the appearance
### of Faq-O-Matic pages.
###

package FAQ::OMatic::Appearance;
use FAQ::OMatic::ImageRef;

# These control the overall appearance of the page (background color/gif,
# title string). Please leave the string in the footer that identifies
# the author and the homepage of Faq-O-Matic.
sub cPageHeader {
	my $params = shift;
	my $suppressType = shift || '';
	# this is a func because FAQ::OMatic::fomTitle() isn't well-defined at
	# global initialization time.
	my $type = ($suppressType) ? '' : "Content-type: text/html\n\n";

	# THANKS: to Billy Naylor for requesting the ability to insert
	# THANKS: a corporate logo into every page's HTML.
	my $pageHeader = $FAQ::OMatic::Config::pageHeader || '';
	return $type
			."<html><head><title>".FAQ::OMatic::fomTitle()
			.FAQ::OMatic::pageDesc($params)."</title></head>\n"
			."<body bgcolor=\"$FAQ::OMatic::Config::backgroundColor\" "
			."text=$FAQ::OMatic::Config::textColor "
			."link=$FAQ::OMatic::Config::linkColor "
			."vlink=$FAQ::OMatic::Config::vlinkColor>\n$pageHeader\n";
}

sub cPageFooter {
	my $params = shift;		# hash ref
	my $showLinks = shift || [];	# ref to array of links to show

	my $filename = $params->{'file'} || '1';
	my $recurse = $params->{'_recurse'} || '';
	my $item = new FAQ::OMatic::Item($filename);

	my $boxColor = '';	# TODO: I don't think I use this anymore, anyway.

	my @sl;
	if ($showLinks eq 'all') {
		@sl = ('help', 'search', 'appearance', 'entire', 'edit');
	} elsif (ref $showLinks) {
		@sl = @{$showLinks};
	}
	my %sl = map {$_=>$_} @sl;
	$showLinks = \%sl;

	my $page = "\n<!--footer box at bottom of page with common links -->\n";
	$page .="<table width=\"100%\" "
		."bgcolor=\"$FAQ::OMatic::Config::regularPartColor\">\n"
		."<tr><td><table width=\"100%\">\n";

	my @cells = ();

	if ($showLinks->{'help'}) {
		push @cells, helpButton($params);
	}

	if ($showLinks->{'search'}) {
		# Search Form
		push @cells,
			"<td align=center $boxColor>"
			.FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'searchForm',
					'-params'=>$params),
				"Search</a>")
			."</td>\n";
	}

	if ($showLinks->{'appearance'}) {
		# Appearance Options
		push @cells,
			"<td align=center $boxColor>"
			.FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'appearanceForm',
					'-params'=>$params),
			"Appearance")
			."</td>\n";
	}

	if ($showLinks->{'entire'}) {
		# Show This Entire Category
		if ($item->isCategory()) {
			if ($recurse) {
				# provide a way to get rid of the recursive display
				# THANKS: Jim Adler <jima@sr.hp.com>
				push @cells,
					"<td align=center $boxColor>"
					.FAQ::OMatic::button(
						FAQ::OMatic::makeAref('-command'=>'faq',
							'-params'=>$params,
							'-changedParams'=>{'_recurse'=>''}),
						"Show Top Category Only</a>")
					."</td>\n";
			} else {
				push @cells,
				"<td align=center $boxColor>"
					.FAQ::OMatic::button(
						FAQ::OMatic::makeAref('-command'=>'faq',
							'-params'=>$params,
							'-changedParams'=>{'_recurse'=>1}),
						"Show This <em>Entire</em> Category</a>")
					."</td>\n";
			}
		} else {
			push @cells, "<td align=center></td>\n";
		}
	}

	if ($showLinks->{'edit'}
		and $FAQ::OMatic::Config::showEditOnFaq) {
		# Show Edit Commands
		my $editcell = "<td align=center $boxColor>";
		if ($params->{'showEditCmds'}) {
			$editcell.=FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'faq',
					'-params'=>$params,
					'-changedParams'=>{'showEditCmds'=>''}),
				"Hide Expert Edit Commands");
		} else {
			$editcell.=FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'faq',
					'-params'=>$params,
					'-changedParams'=>{'showEditCmds'=>'1'}),
				"Show Expert Edit Commands");
		}
		$editcell.="</td>\n";
		push @cells, $editcell;
	}

	if ($showLinks->{'faq'}) {
		# return to faq
		my $cmd = $params->{'cmd'} || '';
		if ($cmd ne '' and $cmd ne 'faq') {
			push @cells,
				"<td align=center $boxColor>"
				.FAQ::OMatic::button(
					FAQ::OMatic::makeAref('-command'=>'faq',
						'-params'=>$params,
						# kill unneeded params from 'authenticate':
						'-changedParams'=>{'partnum'=>'',
							'checkSequenceNumber'=>''},
					),
					"Return to FAQ");
		}
	}

	$page .= "<tr>\n".join('', @cells)."</tr>\n";

	my $numCells = scalar(@cells) || 0;
	my $foo = "y".$FAQ::OMatic::VERSION."x";
	$page.=	"<tr><td colspan=$numCells align=center>\n"
			."This is <a href=\""
			."http://www.dartmouth.edu/cgi-bin/cgiwrap/jonh/faq.pl"
			."\">Faq-O-Matic</a> $FAQ::OMatic::VERSION.\n"
			."</td></tr></table>\n"
			."</td></tr></table>\n";

	$page .= $FAQ::OMatic::Config::pageFooter || '';

	$page .= "</body></html>\n";
	
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
	my $item = shift;
	my $alreadyStart = $params->{'_as'} || '';	# info hidden away in $params
	my $numParts = $params->{'_numParts'} || 1;	# info hidden away in $params

	my ($spacer,$sw) = FAQ::OMatic::ImageRef::getImageRefCA('', '',
		$item->isCategory(), $params);

	if ($params->{'simple'}) {
		return $alreadyStart
			? "\n\n<p>\n"
			: "";
	} else {
		$params->{'_as'} = 1;
		# IE doesn't add white space between table cells by default,
		# so we explicitly use the cellspacing tag to delineate between
		# parts. Plus we add some cellpadding to give the text inside
		# the colored boxes a little "air" around it.
		# THANKS: Jim Adler <jima@sr.hp.com> for the suggestion.
		my $rt = '';
		if (not $alreadyStart) {
			$rt = "<table width=100% cellpadding=5 cellspacing=2>\n";
		}
		$rt.="<tr>\n"
			."<td bgcolor=$FAQ::OMatic::Config::itemBarColor "
			."valign=top align=center rowspan=$numParts width=$sw>\n"
			."$spacer\n</td>\n";
		return $rt;
	}
}

# This is called only once, after the last item is drawn.
sub itemEnd {
	my $params = shift;
	if (not $params->{'simple'}) {
		return "</table>\n";
	} else {
		return "<hr>";
	}
}

sub max {
	my $champ = shift;
	while (my $contender = shift) {
		$champ = ($champ > $contender) ? $champ : $contender;
	}
	return $champ;
}

sub decodeCell {
	my $cell = shift;

	if (ref($cell)) {
		if ($cell->[0] eq 'edit') {
			return ("<font size=-1>".$cell->[1]."</font>",
				" align=center valign=bottom");
		} elsif ($cell->[0] eq 'regPart') {
			return ($cell->[1], " align=top valign=left"
					." bgcolor=$FAQ::OMatic::Config::regularPartColor");
		} elsif ($cell->[0] eq 'dirPart') {
			return ($cell->[1], " align=top valign=left"
					." bgcolor=$FAQ::OMatic::Config::directoryPartColor");
		}
		return ($cell->[1],'');
	}
	return ($cell,'');
}

sub itemRender {
	my $params = shift;
	#my $item = shift; # TODO NOW: fix
	my $itemboxes = shift;

	my $maxwidth = 0;
	my $tablerows = 0;
	my $tablerowcounts = {};
	foreach my $itembox (@{$itemboxes}) {
		my ($item, $rows) = @{$itembox};
		foreach my $row (@{$rows}) {
			if (scalar(@{$row})==3) {
				# a row from Part.pm with edit commands
				if ($FAQ::OMatic::Config::compactEditCmds || '') {
					$maxwidth = max($maxwidth, 3, scalar(@{$row->[1]}));
					$maxwidth = max($maxwidth, 3, scalar(@{$row->[2]}));
					$tablerows += 3;
				} else {
					$maxwidth = max($maxwidth, 3, scalar(@{$row->[2]}));
					$tablerows += max(2, scalar(@{$row->[1]})+1);
				}
			} elsif (ref($row->[0])) {
				$maxwidth = max($maxwidth, scalar(@{$row->[0]}));
				$tablerows += 1;
			} else {
				$maxwidth = max($maxwidth, 1);
				$tablerows += 1;
			}
		}
		$tablerowcounts->{$rows} = $tablerows;
		$tablerows = 0;
	}

	my $rt = '';

	$rt.= "<table width=100% cellpadding=5 cellspacing=2>\n";
	foreach my $itembox (@{$itemboxes}) {
		my ($item, $rows) = @{$itembox};
		$tablerows = $tablerowcounts->{$rows};

		my ($spacer,$sw) = FAQ::OMatic::ImageRef::getImageRefCA('', '',
			$item->isCategory(), $params);
	
		$rt.="<tr>\n"
				."<td bgcolor=$FAQ::OMatic::Config::itemBarColor "
				."valign=top align=center rowspan=$tablerows width=$sw>\n"
				."$spacer\n</td>\n";
		my $first = 1;
			# don't send <tr> on first table row, since we already did

		foreach my $row (@{$rows}) {
			if ($first) {
				$first = 0;
			} else {
				$rt .= "\n<tr><!-- next Part -->";
			}
			if (scalar(@{$row})==3) {
				$rt.="<!--three-part row-->";
				if ($FAQ::OMatic::Config::compactEditCmds || '') {
					# put part on its own line
					my ($celltxt,$tdopts) = decodeCell($row->[0]);
					$rt .= "\n<!--Part body--><td colspan="
							.($maxwidth)
							." $tdopts>$celltxt</td></tr>\n";

					# cram "right" and "below" cells into a single cell
					$rt .= "<tr><!--\"right\" and below cells--><td colspan="
						.($maxwidth)
						.">\n";
					foreach my $cell (@{$row->[1]}, "<br>", @{$row->[2]}) {
						($celltxt,$tdopts) = decodeCell($cell);
						$rt .= "\n$celltxt\n";
					}
					$rt .= "</td></tr>\n";
				} else {
					# append a row (spanned by part box) for each right cell
					# first cell shares a row with part body
					my @rightcells = @{$row->[1]};
					my ($celltxt,$tdopts) = decodeCell(shift @rightcells);
					$rt .= "\n<!--right cell--><td $tdopts>$celltxt</td>\n\n";
		
					# a row from Part.pm with edit commands
					($celltxt,$tdopts) = decodeCell($row->[0]);
					$rt .= "\n<!--Part body--><td colspan="
							.($maxwidth-1)
							." rowspan="
							.(scalar(@{$row->[1]}))
							." $tdopts>$celltxt</td></tr>\n";
					# remaining cells get own rows
					foreach my $cell (@rightcells) {
						my ($celltxt,$tdopts) = decodeCell($cell);
						$rt .= "\n<tr><!--right cell--><td $tdopts>"
								."$celltxt</td>\n</tr>\n";
					}
	
					# append a row containing the below cells
					$rt .= "<tr><!--below cells-->\n";
					foreach my $cell (@{$row->[2]}) {
						my ($celltxt,$tdopts) = decodeCell($cell);
						$rt .= "\n<td $tdopts>$celltxt</td>\n";
					}
				}
				$rt .= "</tr>\n";
			} elsif (ref($row->[0])) {
				if ($FAQ::OMatic::Config::compactEditCmds || '') {
					$rt.="<!--multi row--><td colspan=$maxwidth>\n";
					foreach my $cell (@{$row->[0]}) {
						my ($celltxt,$tdopts) = decodeCell($cell);
						$rt .= "\n$celltxt\n";
					}
					$rt .= "</td></tr>\n";
				} else {
					$rt.="<!--multi row-->";
					foreach my $cell (@{$row->[0]}) {
						my ($celltxt,$tdopts) = decodeCell($cell);
						$rt .= "\n<td $tdopts>$celltxt</td>\n";
					}
					$rt .= "</tr>\n";
				}
			} else {
				my ($celltxt,$tdopts) = decodeCell($row->[0]);
				$rt .= "<!--single row-->"
					."<td colspan=$maxwidth $tdopts>$celltxt</td></tr>\n";
			}
		}
	}
	$rt.="\n</table>\n";

	return $rt;
}

# These are called before and after drawing each part.
sub partStart {
	my $params = shift;
	my $part = shift;	# can examine the part to see if it's a directory

	if (not $params->{'simple'}) {
		my $color = (($part->{'Type'} || '') eq 'directory')
					? $FAQ::OMatic::Config::directoryPartColor
					: $FAQ::OMatic::Config::regularPartColor;
		return "<tr><td bgcolor=$color>\n";
	} else {
		return "<p>\n";
	}
}

sub partEnd {
	my $params = shift;
	if (not $params->{'simple'}) {
		return "</td></tr>\n";
	} else {
		return "<br>\n";
	}
}

use vars qw($editStart $editEnd $otherStart $otherEnd $highlightColor
	$highlightStart $highlightEnd $graphHistory $graphHeight $graphWidth);

# These surround the editing buttons. I make them smaller so they'll
# not look as much like part of the item being displayed, and more
# like little intruders.
# TODO: should be functions to handle 'simple' HTML mode
$editStart = "<tr><td><font size=-1>\n";
$editEnd = "\n</font></td></tr>\n";

# These surround other text, such as moderator and attributionsTogether
$otherStart = "<tr><td>\n";
$otherEnd = "\n</td></tr>\n";

# These surround words in the document that were in a search query.
$highlightColor	= $FAQ::OMatic::Config::highlightColor || "#a01010";
$highlightStart = "<font color=$highlightColor><b>";
$highlightEnd	= "</b></font>";

$graphHistory	= 60;	# default graphs show data going back two months
$graphWidth		= 250;	# image size of stats graphs
$graphHeight	= 180;

1;
