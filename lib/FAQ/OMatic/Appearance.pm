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

use vars qw($editStart $editEnd $otherStart $otherEnd $highlightColor
	$highlightStart $highlightEnd $graphHistory $graphHeight $graphWidth);

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

# These control the overall appearance of the page (background color/gif,
# title string). Please leave the string in the footer that identifies
# the homepage of Faq-O-Matic so others can see where to get the
# software for their own site.
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

# TODO: reorganize cPageFooter to be able to render simple HTML
# (no tables, just a <hr> in front of the links) and even text
#	my $render = $params->{'render'} || 'fancy';

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

sub max {
	my $champ = shift;
	while (my $contender = shift) {
		$champ = ($champ > $contender) ? $champ : $contender;
	}
	return $champ;
}

sub itemRender {
	my $params = shift;
	my $itemboxes = shift;

	# Here is how the itemRender data structure is arranged:
	# $itemboxes is a ref to an array, each element contains the data to
	#	draw a single item. (There are multiple entries when
	#	[Show All Items Below Here] is in effect.)
	# $itemboxes->[i] is a ref to a hash.
	# $itemboxes->[i]->{'item'} is the FAQ::OMatic::Item object that this
	#	itembox represents.
	# $itemboxes->[i]->{'rows'} is a ref to an array, each element of which
	#	is a row, structured as described below. Each row corresponds
	#	to a part in the item, plus a few extra rows for other parts of
	#	the page.
	# $itemboxes->[i]->{'rows'}->[p] is a ref to a hash, describing that part.
	# $itemboxes->[i]->{'rows'}->[p]->{'type'} is one of
	#	'three', 'multirow', 'wide'.
	# type 'three' parts have ->{'body'}, ->{'editbody'}, ->{'afterbody'}
	#	refs. 'body' is a hash ref to 'text' and 'color'.
	#	'editbody' is an array ref to edit cmds that apply to this part body.
	#	each element of the array is a hash of 'text' and 'color'.
	#	'afterbody' is an array ref to edit cmds that apply after this
	#	part body.
	# type 'multirow' fields have ->{'cells'}, a ref to an array of cells
	#	that should be laid out horizontally.
	# type 'wide' fields have ->{'text'} and ->{'color'} parts that should
	#	fill the width of the display.

	my $render = $params->{'render'} || 'fancy';
	if ($render eq 'simple') {
		return itemRenderSimple($params, $itemboxes);
	} else {
		my $editDisplay = $params->{'showEditCmds'} || '';
		if ($editDisplay eq 'compact') {
			return itemRenderCompactEdits($params, $itemboxes);
		} else {
			return itemRenderNormalEdits($params, $itemboxes);
		}
	}
}

sub itemRenderNormalEdits {
	my $params = shift;
	my $itemboxes = shift;

	# first, compute the widest row of cells in the table, so that
	# 'wide' and 'three'->'body' parts fit the width of the table.
	my $maxwidth = 0;
	my $tablerows = 0;
	my $tablerowcounts = {};
	foreach my $itembox (@{$itemboxes}) {
		my $item = $itembox->{'item'};
		my $rows = $itembox->{'rows'};
		foreach my $row (@{$rows}) {
			if ($row->{'type'} eq 'three') {
				$maxwidth = max($maxwidth, 3, scalar(@{$row->{'afterbody'}}));
				$tablerows += max(2, scalar(@{$row->{'editbody'}})+1);
			} elsif ($row->{'type'} eq 'multirow') {
				$maxwidth = max($maxwidth, scalar(@{$row->{'cells'}}));
				$tablerows += 1;
			} elsif ($row->{'type'} eq 'wide') {
				$maxwidth = max($maxwidth, 1);
				$tablerows += 1;
			} else {
				die "unknown row type ".$row->{'type'};
			}
		}
		$tablerowcounts->{$rows} = $tablerows;
		$tablerows = 0;
			# rows are tallied per item ($rows is the set of rows in an item),
			# so that we can compute the correct rowspan for the solid bar
			# at the left of an item.
	}

	my $rt = '';

	$rt.= "<table width=100% cellpadding=5 cellspacing=2>\n";
	foreach my $itembox (@{$itemboxes}) {
		my $item = $itembox->{'item'};
		my $rows = $itembox->{'rows'};
		$tablerows = $tablerowcounts->{$rows};

		my ($spacer,$sw) = FAQ::OMatic::ImageRef::getImageRefCA('', '',
			$item->isCategory(), $params);
	
		my $itemFile = $item->{'filename'};
		my $itemName = $item->getTitle();
		$rt.="\n<!--Item: $itemName file: $itemFile--><tr>\n"
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
			if ($row->{'type'} eq 'three') {
				my ($bodycolor,$bodytext) = getColorText($row->{'body'});
				my @editbody = @{$row->{'editbody'}};	# array ref
				my $rowspan = scalar @editbody;
				my $colspan = $maxwidth - 1;
				my @afterbody = @{$row->{'afterbody'}};	# array ref

				$rt.="<!-- type 'three' -->";
				# append a row (spanned by part box) for each editbody cell
				# first cell shares a row with part body
				my $cell = shift @editbody;
				my ($color,$text) = getColorText($cell);
				$rt .= "\n<!--editbody--><td $color>$text</td>\n\n";
	
				# a row from Part.pm with edit commands
				$rt .= "\n<!--Part body--><td colspan=$colspan "
						."rowspan=$rowspan"
						." $bodycolor>$bodytext</td></tr>\n";
				# remaining cells get own rows
				foreach $cell (@editbody) {
					($color,$text) = getColorText($cell);
					$rt .= "\n<tr><!--editbody--><td $color>"
							."$text</td>\n</tr>\n";
				}

				# append a row containing the below cells
				$rt .= "<tr><!--afterbody-->\n";
				foreach $cell (@afterbody) {
					($color,$text) = getColorText($cell);
					$rt .= "\n<td $color>$text</td>\n";
				}
				$rt .= "</tr>\n";
			} elsif ($row->{'type'} eq 'multirow') {
				# row is specified as a series of cells to be crammed
				# together horizontally.
				$rt.="<!--multirow-->";
				foreach my $cell (@{$row->{'cells'}}) {
					my ($color,$text) = getColorText($cell);
					$rt .= "\n<td $color>$text</td>\n";
				}
				$rt .= "</tr>\n";
			} else {
				# row is specified as a single cell that should fill the
				# width of the table.
				my ($color,$text) = getColorText($row);
				$rt .= "<!--wide-->"
					."<td colspan=$maxwidth $color>$text</td></tr>\n";
			}
		}
	}
	$rt.="\n</table>\n";

	return $rt;
}

sub getColorText {
	my $hashref = shift;
	my $color = $hashref->{'color'} || '';
	my $size = $hashref->{'size'} || '';
	$color = "bgcolor=$color" if ($color);
	my $text = $hashref->{'text'} || '';
	if ($size eq 'edit') {
		$text = $FAQ::OMatic::Appearance::editStart
			.$text
			.$FAQ::OMatic::Appearance::editEnd;
	}
	return ($color,$text);
}

sub itemRenderCompactEdits {
	my $params = shift;
	my $itemboxes = shift;

	# first, compute the widest row of cells in the table, so that
	# 'wide' and 'three'->'body' parts fit the width of the table.
	my $maxwidth = 0;
	my $tablerows = 0;
	my $tablerowcounts = {};
	foreach my $itembox (@{$itemboxes}) {
		my $item = $itembox->{'item'};
		my $rows = $itembox->{'rows'};
		foreach my $row (@{$rows}) {
			if ($row->{'type'} eq 'three') {
				# both editbody and afterbody are laid out horizontally.
				$maxwidth = max($maxwidth, 3, scalar(@{$row->{'editbody'}}));
				$maxwidth = max($maxwidth, 3, scalar(@{$row->{'afterbody'}}));
				# the 'body' gets one row, the 'editbody' and 'afterbody'
				# share a second row.
				$tablerows += 2;
			} elsif ($row->{'type'} eq 'multirow') {
				$maxwidth = max($maxwidth, scalar(@{$row->{'cells'}}));
				$tablerows += 1;
			} elsif ($row->{'type'} eq 'wide') {
				$maxwidth = max($maxwidth, 1);
				$tablerows += 1;
			} else {
				die "unknown row type ".$row->{'type'};
			}
		}
		$tablerowcounts->{$rows} = $tablerows;
		$tablerows = 0;
			# rows are tallied per item ($rows is the set of rows in an item),
			# so that we can compute the correct rowspan for the solid bar
			# at the left of an item.
	}

	my $rt = '';

	$rt.= "<table width=100% cellpadding=5 cellspacing=2>\n";
	foreach my $itembox (@{$itemboxes}) {
		my $item = $itembox->{'item'};
		my $rows = $itembox->{'rows'};
		$tablerows = $tablerowcounts->{$rows};

		my ($spacer,$sw) = FAQ::OMatic::ImageRef::getImageRefCA('', '',
			$item->isCategory(), $params);
	
		my $itemFile = $item->{'filename'};
		my $itemName = $item->getTitle();
		$rt.="\n<!--Item: $itemName file: $itemFile--><tr>\n"
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
			if ($row->{'type'} eq 'three') {
				my ($bodycolor,$bodytext) = getColorText($row->{'body'});
				my @editbody = @{$row->{'editbody'}};	# array ref
				my @afterbody = @{$row->{'afterbody'}};	# array ref

				$rt.="<!-- type 'three' -->";
				# in compact mode, the 'body' gets a row to itself
				# a row from Part.pm with edit commands
				$rt .= "\n<!--Part body--><td colspan=$maxwidth "
						."$bodycolor>$bodytext</td></tr>\n";

				# 'editbody' and 'afterbody' cells crammed into a single
				# cell (hence the "compact" :v)
				# everybody in the cell gets the color of the first guy.
				my ($color,$text) = getColorText($editbody[0]);
				$rt .= "<tr><td colspan=$maxwidth $color>";
				my $cell;
				foreach $cell (@editbody) {
					($color,$text) = getColorText($cell);
					$rt.="<!--editbody-->".$text;
				}
				$rt .= "\n<br>";
				foreach $cell (@afterbody) {
					($color,$text) = getColorText($cell);
					$rt.="<!--afterbody-->".$text;
				}
				$rt .= "</tr>\n";
			} elsif ($row->{'type'} eq 'multirow') {
				# row is specified as a series of cells to be crammed
				# together horizontally.
				my @cells = @{$row->{'cells'}};

				# everybody in the cell gets the color of the first guy.
				my ($color,$text) = getColorText($cells[0]);
				$rt.="<!--multirow--><td colspan=$maxwidth $color>";

				foreach my $cell (@cells) {
					my ($color,$text) = getColorText($cell);
					$rt .= "<!--cell-->".$text;
				}
				$rt .= "</tr>\n";
			} else {
				# row is specified as a single cell that should fill the
				# width of the table.
				my ($color,$text) = getColorText($row);
				$rt .= "<!--wide-->"
					."<td colspan=$maxwidth $color>$text</td></tr>\n";
			}
		}
	}
	$rt.="\n</table>\n";

	return $rt;
}

sub itemRenderSimple {
	# an HTML rendering mode that uses no tables; a goal is for it to
	# look acceptable in lynx.
	my $params = shift;
	my $itemboxes = shift;

	my $rt = "<dl>\n";

	foreach my $itembox (@{$itemboxes}) {
		my $item = $itembox->{'item'};
		my $rows = $itembox->{'rows'};

		my $itemFile = $item->{'filename'};
		my $itemName = $item->getTitle();

		# this rendering method assumes (hopes!) that the first
		# row of an item is a 'wide' row, something that looks like
		# a title.
		my $row = shift @$rows;
		if ($row->{'type'} ne 'wide') {
			FAQ::OMatic::gripe('problem', "assertion failed. ".caller(0));
		}
		my $text = $row->{'text'};
		$rt.="\n<!--Item: $itemName file: $itemFile-->\n"
			."<dt>$text\n"
			."<dd><ul>\n";

		foreach $row (@{$rows}) {
			$rt .= "\n<!-- next Part -->";
			if ($row->{'type'} eq 'three') {
				my ($bodycolor,$bodytext) = getColorText($row->{'body'});
				my @editbody = @{$row->{'editbody'}};	# array ref
				my @afterbody = @{$row->{'afterbody'}};	# array ref

				$rt.="<!-- type 'three' -->";
				$rt.="<li>$bodytext<br>\n";
				my $cell;
				foreach $cell (@editbody) {
					my ($color,$text) = getColorText($cell);
					$rt.="<!--editbody-->".$text;
				}
				$rt .= "\n<br>";
				foreach $cell (@afterbody) {
					my ($color,$text) = getColorText($cell);
					$rt.="<!--afterbody-->".$text;
				}
			} elsif ($row->{'type'} eq 'multirow') {
				# row is specified as a series of cells to be crammed
				# together horizontally.
				$rt.="<!--multirow-->";
				$rt.="<li>";
				foreach my $cell (@{$row->{'cells'}}) {
					my ($color,$text) = getColorText($cell);
					$rt .= "$text\n";
				}
			} else {
				# row is specified as a single cell that should fill the
				# width of the table.
				my ($color,$text) = getColorText($row);
				$rt .= "<!--wide-->"
					."<li>$text\n";
			}
		}
		$rt.="\n</ul>\n";
	}
	$rt.="\n</dl>\n";

	return $rt;
}

# TODO: eventually, an itemRenderText function.

1;
