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
	# this is a func because FAQ::OMatic::fomTitle() isn't well-defined at
	# global initialization time.
	return "Content-type: text/html\n\n"
			."<html><head><title>".FAQ::OMatic::fomTitle()
			.FAQ::OMatic::pageDesc()."</title></head>\n"
			."<body bgcolor=\"$FAQ::OMatic::Config::backgroundColor\" "
			."text=$FAQ::OMatic::Config::textColor "
			."link=$FAQ::OMatic::Config::linkColor "
			."vlink=$FAQ::OMatic::Config::vlinkColor>\n";
}

sub cPageFooter {
	my $params = shift;		# hash ref
	my $showLinks = shift;

	my $page= "\n"
			.partStart({})
			."<table width=\"100%\"><tr><td width=\"50%\" align=left>\n"
			."The <a href=\"http://www.dartmouth.edu/cgi-bin/cgiwrap/jonh/faq.pl\">Faq-O-Matic</a> is by <a href=\"http://www.cs.dartmouth.edu/~jonh\">Jon Howell</a>.\n"
			."</td>";
	if ($showLinks) {
		$page.="<td width=\"16%\" align=center>"
			.FAQ::OMatic::makeAref('searchForm', {}, '')
			."Search</a>"
			."</td><td width=\"17%\" align=center>"
			.FAQ::OMatic::makeAref('appearanceForm', {}, '')
			."Appearance"
			."</td><td width=\"17%\" align=center>";
		if ($params->{'showEditCmds'}) {
			$page.=FAQ::OMatic::makeAref('faq', {'showEditCmds'=>''}, '')
				."Hide Edit Cmds";
		} else {
			$page.=FAQ::OMatic::makeAref('faq', {'showEditCmds'=>'1'}, '')
				."Show Edit Cmds";
		}
		$page.="</td>";
	}
	$page .= "</tr></table>"
			.partEnd({})
			."</body></html>\n";
	return $page;
}

# This is called before every item is printed. (There are multiple
# items in the "[Show All Items Below Here]" display and the search
# output.)
my $alreadyStart=0;
sub itemStart {
	my $params = shift;
	if (not $alreadyStart) {
		$alreadyStart = 1;
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
		if ($part->{'Type'} eq 'directory') {
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
$highlightStart = "<font color=$FAQ::OMatic::Config::highlightColor><b>";
$highlightEnd	= "</b></font>";

$graphHistory	= 60;	# default graphs show data going back two months
$graphWidth		= 250;	# image size of stats graphs
$graphHeight	= 180;

1;
