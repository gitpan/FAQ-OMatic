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
### A FAQ::OMatic::Part is a member of a FAQ::OMatic::Item, and contains one chunk of
### text, plus its attributions, modification date, and other
### characteristics.
###

package FAQ::OMatic::Part;

use FAQ::OMatic;
use FAQ::OMatic::Item;
use FAQ::OMatic::Appearance;
use FAQ::OMatic::Set;
use Text::Tabs;

sub new {
	my ($class) = shift;

	my $part = {};
	bless $part;
	$part->{'Type'} = '';			# type is always defined, since '' is a
									# valid type.
	$part->{'Text'} = '';			# might as well define the text, since
									# that's the point of a part.
	$part->{'Author-Set'} = new FAQ::OMatic::Set('keepOrdered');

	return $part;
}

sub loadFromFile {
	my $self = shift;
	my $fileHandle = shift;
	my $filename = shift;
	my $item = shift;
	my $partnum = shift;

	my ($lines) = 0;
	my ($text) = "";

	while (<$fileHandle>) {
		chomp;
		my ($key,$value) = FAQ::OMatic::keyValue($_);
		if ($key eq 'Author') {
			# convert old-style 'Author' keys to 'Author-Set' keys
			# transparently. Eventually all such items will get written
			# out with updated header keys.
			$key = 'Author-Set';
		}
		if ($key eq 'Lines') {
			# Lines header is always last before the text content of a Part
			$lines = $value;
			last;
		} elsif ($key =~ m/-Set$/) {
			# header key ends in '-Set' -- that means it may appear multiple
			# times.
			if (not defined($self->{$key})) {
				$self->{$key} = new FAQ::OMatic::Set;
			}
			$self->{$key}->insert($value);
		} elsif ($key ne '') {
			$self->{$key} = $value;
			if (($key eq 'Type') and ($value eq 'directory')) {
				# keep a quick way for the item object to find the part that
				# holds the directory
				$item->{'directoryHint'} = $partnum;
			}
		} else {
			FAQ::OMatic::gripe('problem',
			"FAQ::OMatic::Part::loadFromFile was confused by this header in file $filename: \"$_\"");
		}
	}
	while (($lines>0) and ($_=<$fileHandle>)) {
		$text .= $_;
		$lines--;
	}
	# verify that EndPart shows up in the right place
	$_ = <$fileHandle>;
	if (not defined $_) {
		FAQ::OMatic::gripe('problem',
		"FAQ::OMatic::Part::loadFromFile file $filename part $partnum didn't end right.");
	}
	my ($key,$value) = FAQ::OMatic::keyValue($_);
	if (($key ne 'EndPart') or ($value != $partnum)) {
		FAQ::OMatic::gripe('problem', "FAQ::OMatic::Part::loadFromFile file $filename part $partnum didn't end with EndPart.");
	}
	$self->{'Text'} = $text;
}

sub displayAsFile {
	my $self = shift;
	my $rt = "";

	foreach $key (sort keys %{$self}) {
		if (($key =~ m/^[a-z]/)
			or ($key eq 'Text')) {
			next;
			# these keys get ignored or written out later (Text)
		} elsif ($key =~ m/-Set$/) {
			my $a;
			foreach $a ($self->getSet($key)->getList()) {
				$rt .= "$key: $a\n";
			}
		} else {
			$rt .= "$key: ".$self->{$key}."\n";
		}
	}
	my $text = $self->{'Text'};
	$text =~ s/([^\n])\r([^\n])/$1\n$2/gs;	# standalone LF's become \n's.
	$text =~ s/\r//gs;						# Remove any bogus extra \r's
	$text .= "\n" if (not ($text =~ m/\n$/));	# ensure final \n
	$self->{'Text'} = $text;				# make sure in-memory copy
											# reflects the one we're saving

	$rt .= "Lines: ".countLines($text)."\n".$text;

	return $rt;
}

sub countLines {
	my $data = shift;
	my $datacopy = $data;
	$datacopy =~ s/[^\n]//gs;		# count \n's
	return length($datacopy);
}

sub display {
	my $self = shift;
	my @keys;
	my $rt = "";	# return text

	$rt .= "<ul>\n";
	foreach $key (sort keys %$self) {
		$rt .= "<li>$key => $self->{$key}<br>\n";
	}
	$rt .= "</ul>\n";

	return $rt;
}

sub displayHTML {
	my $self = shift;
	my $item = shift;
	my $partnum = shift;
	my $params = shift;
	my $rt = ""; 	# return text
	my $showAttributions = $params->{'showAttributions'} || 'default';

	$rt .= FAQ::OMatic::Appearance::partStart($params,$self);

	my $tmp = FAQ::OMatic::insertLinks($params, $self->{'Text'},
					   $self->{'Type'} eq 'html');
	$tmp = FAQ::OMatic::highlightWords($tmp, $params);
	$type = $self->{'Type'} || '';
	if ($type eq 'monospaced'){
		## monospaced text
		$tmp =~ s/\n$//;
		$tmp = "<pre>\n".$tmp."</pre>";
	} elsif ($type eq 'html') {
		## HTML text.  Just add a <br> at the end, and a comment that
	        ## it's untranslated.
	        $tmp = "<!-- This text is untranslated from the original;\n" .
		    "any errors are in the original text. -->\n" . $tmp .
			"\n<br>\n";
	} else {
		## standard format: double-CRs become <p>'s (whitespace between
		## paragraphs), and lines that start with whitespace get a <br>
		## tag. Note that directories are standard format too, we just
		## enforce a rule when editing to keep the structure consistent.
		$tmp .= "<br>";				# keep attributions below part
		# These are Andreas Kluﬂmann <Andreas.Klussmann@infosys.heitec.net>'s
		# cool rules: triple-space for a paragraph, double for a break,
		# indent for <pre>formatted text.
		$tmp =~ s/\n\n\n/\n<p>\n/gs;
		$tmp =~ s/\n\n/<br>\n/gs;
		$tmp =~ s/\n( +[^\n]*)(?=\n)/\n<pre>$1<\/pre>/gs;
		$tmp =~ s/<\/pre>\n<pre>/\n/gs;
	}
	$rt .= $tmp;

	# turn off attributions if this part has the HideAttributions property,
	# or if the item has the AttributionsTogether property.
	if ($showAttributions eq 'default') {
		if ($self->{'HideAttributions'} or $item->{'AttributionsTogether'}) {
			$showAttributions = 'hide';
		} else {
			$showAttributions = 'all';
		}
	}
	if ($showAttributions eq 'all') {
		#$rt .= "<i>".join(", ",
		# (DateOfPart courtesy Scott Hardin <scott@cs.dlh.de>)
		# Because the 'DateOfPart' keyword is not a standard hack,
		# we only print out the additional semicolon and space
		# if the keyword exists. Since we're lazy, we'll just pack
		# it into a string.
		my ($date_string) = '';
		if ($self->{'DateOfPart'} and $params->{'showLastModified'}) {
		        $date_string = $self->{'DateOfPart'} . "  ";
		}
		$rt .= "<i>"
			.$date_string
			.join(", ",
				map { "<a href=\"mailto:$_\">$_</a>" }
					$self->{'Author-Set'}->getList()
				)."</i>";
	}

	$rt .= FAQ::OMatic::Appearance::partEnd($params);

	my $filename = $item->{'filename'};
	if ($params->{'showEditCmds'}) {
		#$rt .= "<br>\n" if ($showAttributions eq 'all');
		$rt .= $FAQ::OMatic::Appearance::editStart;
			#."Edit Part: ";
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'editPart',
				'-params'=>$params,
				'-changedParams'=>{'file'=>$filename,
							'partnum'=>$partnum,
							'_insertpart'=>1,
							'checkSequenceNumber'=>$item->{'SequenceNumber'}}),
				"Insert Text Here")."\n";
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'editPart',
				'-params'=>$params,
				'-changedParams'=>{'file'=>$filename,
							'partnum'=>$partnum,
							'checkSequenceNumber'=>$item->{'SequenceNumber'}}),
			"Edit Above Text")."\n";
		$rt .= FAQ::OMatic::button(
			FAQ::OMatic::makeAref('-command'=>'editPart',
				'-params'=>$params,
				'-changedParams'=>{'file'=>$filename,
							'partnum'=>$partnum,
							'_insertpart'=>1,
							'_duplicate'=>1,
							'checkSequenceNumber'=>$item->{'SequenceNumber'}}),
			"Duplicate Above Text")."\n";
		if ($type ne 'directory') {
			$rt .= FAQ::OMatic::button(
				FAQ::OMatic::makeAref('-command'=>'delPart',
					'-params'=>$params,
					'-changedParams'=>{"file"=>$filename,
						'partnum'=>$partnum,
						'checkSequenceNumber'=>$item->{'SequenceNumber'}}
				),
			"Remove Above Text")."\n";
		}
		$rt .= $FAQ::OMatic::Appearance::editEnd."<br>\n";
	}

	return $rt;
}

sub displayPartEditor {
	my $self = shift;
	my $item = shift;
	my $partnum = shift;
	my $params = shift;
	my $rt = ''; 	# return text

	# default number of rows is room for text plus a little new text.
	my $rows = countLines($self->{'Text'})+4;
	$rows = 15 if ($rows < 15);	# make sure it's never too teeny
	$rows = 30 if ($rows > 30);	# and never way big

	$rt .= FAQ::OMatic::makeAref('-command'=>'submitPart',
						'-params'=>$params,
						'-refType'=>'POST',
						'-saveTransients'=>1);

	$rt .= "<input type=hidden name=\"checkSequenceNumber\" value=\""
		.$item->{'SequenceNumber'}."\">\n";

	# no text boxes wrap anymore -- it breaks long URLs.
	# (thanks to Billy Naylor <banjo@actrix.gen.nz> for the fix)
	$rt .= "<textarea cols=80 rows=$rows name=_newText>";

	my $text = $self->{'Text'};
	$text =~ s/&/&amp;/gs;		# all browsers I've met correctly
	$text =~ s/</&lt;/gs;		# convert textarea entities into the real thing
	$text =~ s/>/&gt;/gs;

	$text = FAQ::OMatic::addTitleToFaqomaticReferences($text);
	$rt .= $text."</textarea>\n";

	# HideAttributions
	$rt .= "<br><input type=checkbox name=\"_HideAttributions\"";
	$rt .= " CHECKED" if $self->{'HideAttributions'};
	$rt .= "> Hide Attributions\n";

	# Type
	if ($self->{'Type'} eq 'directory') {
		if (scalar($self->getChildren()) == 0) {
			$rt .= "<br><input type=checkbox name=\"_removeDirectory\" "
				."value=\"1\"> Remove directory (turning this category "
				."item into an answer item) if text box above is empty.\n";
		}
		$rt .= "<br><input type=radio name=\"_Type\" value=\"directory\""
			."  CHECKED> Directory\n";
	} else {
		$rt .= "<br><input type=radio name=\"_Type\" value=\"\"";
		$rt .= " CHECKED" if ($self->{'Type'} eq '');
		$rt .= "> Natural text\n";

		$rt .= "<br><input type=radio name=\"_Type\" value=\"monospaced\"";
		$rt .= " CHECKED" if ($self->{'Type'} eq 'monospaced');
		$rt .= "> Monospaced text (code, tables)\n";

		# THANKS: John Goerzen supplied the patches to introduce
		# THANKS: 'html'-type parts.
		my $rd = FAQ::OMatic::Auth::ensurePerm($item, 'PermUseHTML',
			 FAQ::OMatic::commandName(), 
			 $FAQ::OMatic::dispatch::cgi, 0, 'useHTML');
		if ($rd) {
			# TODO: exit is ugly and wrong.
			print $rd; exit 0;
		} else {
	    	$rt .= "<br><input type=radio name=\"_Type\" value=\"html\"";
	    	$rt .= " CHECKED" if ($self->{'Type'} eq 'html');
	    	$rt .= "> Untranslated HTML\n";
		}
	}

	# Submit
	$rt .= "<br><input type=submit name=\"_submit\" value=\"Submit Changes\">\n";
	$rt .= "<input type=reset name=\"_reset\" value=\"Revert\">\n";
	$rt .= "<input type=hidden name=\"_zzverify\" value=\"zz\">\n";
		# this lets the submit script check that the whole POST was
		# received.
	$rt .= "</form>\n";
#	$rt .= FAQ::OMatic::button(
#			FAQ::OMatic::makeAref('-command'=>'faq',
#				'-params'=>$params,
#				'-changedParams'=>{'partnum'=>'',
#					'checkSequenceNumber'=>''}
#				),
#			'Cancel and return to FAQ');

	return $rt;
}

sub setText {
	my $self = shift;
	my $newText = shift;

	# eliminate tabs
	if ($newText =~ m/\t/) {
		# use Text::Tabs expand function to eliminate tabs
		$Text::Tabs::tabstop = 8;
		$newText = join("\n", Text::Tabs::expand(split(/\n/, $newText)));
	}
	$self->{'Text'} = $newText;
}

sub setProperty {
	my $self = shift;
	my $property = shift;
	my $value = shift;

	if ($value) {
		$self->{$property} = $value;
	} else {
		delete $self->{$property};
	}
}

sub getChildren {
	my $self = shift;

	if ($self->{'Type'} ne 'directory') {
		return ();
	}

	return $self->getLinks();
}

# returns a list of all faqomatic: links in this part
sub getLinks {
	my $self = shift;
	
	my $text = $self->{'Text'};
	my @dirlist = ($text =~ m/faqomatic:(\S+)/gs);
	return @dirlist;
}

sub mergeDirectory {
	my $self = shift;
	my $filename = shift;

	if ($self->{'Type'} ne 'directory') {
		FAQ::OMatic::gripe('panic', "mergeDirectory: self is not a directory");
	}
	if (not -f "$FAQ::OMatic::Config::itemDir/$filename") {
		FAQ::OMatic::gripe('panic', "mergeDirectory: $filename isn't a file");
	}

	my @dirlist = $self->getChildren();
	my %dirhash = map { ($_,1) } @dirlist;
	return if ($dirhash{$filename});			# already done

	my $item = new FAQ::OMatic::Item($filename);
	if ((defined $item->{'directoryHint'})
		and ($self->{'Text'} =~ m/\n\nAnswers in this categ/)) {
		# Insert subcategories above "Answers in this category" header, if
		# one exists.
		$self->{'Text'} =~ s/\n\nAnswers in this categ/\n\nfaqomatic:$filename\n\nAnswers in this categ/s;
	} else {
		# just tack on the end with all the other answers
		$self->{'Text'} .= "\nfaqomatic:$filename\n";
	}
	my ($id,$aq) = FAQ::OMatic::Auth::getID();			# user is now a coauthor of
	$self->addAuthor($id) if ($id);				# the directory part
}

sub unmergeDirectory {
	my $self = shift;
	my $filename = shift;

	if ($self->{'Type'} ne 'directory') {
		FAQ::OMatic::gripe('panic',
			"unmergeDirectory: self is not a directory");
	}

	# since directories can now contain textual content, we
	# unmerge by simply "substituting out" the faqomatic link:
	$self->{'Text'} =~ s/ ?faqomatic:$filename\n?\n?//;
}

sub addAuthor {
	my $self = shift;
	my $author = shift;

	$self->{'Author-Set'}->insert($author);
}

sub clone {
	# return a deep-copy of myself
	my $self = shift;

	my $newpart = new FAQ::OMatic::Part();

	# copy all of prototype's attributes
	my $key;
	foreach $key (keys %{$self}) {
		if ($key =~ m/-Set$/) {
			$newpart->{$key} = $self->{$key}->clone();
		} elsif (ref $self->{$key}) {
			# guarantee this is a deep copy -- if we missed
			# a ref, complain.
			FAQ::OMatic::gripe('error', "FAQ::OMatic::Part::clone: prototype has "
				."key '$key' that is a reference (".$self->{$key}.").");
		}
		$newpart->{$key} = $self->{$key};
	}

	# don't let rogue directories escape and mess up the item structure
	$newpart->{'Type'} = '' if ($newpart->{'Type'} eq 'directory');

	return $newpart;
}

sub getSet {
	my $self = shift;
	my $setName = shift;

	return $self->{$setName} || new FAQ::OMatic::Set;
}

1;
