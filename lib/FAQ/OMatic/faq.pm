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

package FAQ::OMatic::faq;

use CGI;
use FAQ::OMatic::Item;
use FAQ::OMatic;

sub main {
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	
	my $params = FAQ::OMatic::getParams($cgi);
	# supply some default parameters where necessary
	$params->{'file'} = 1 if (not $params->{'file'});

	if ($params->{'appearance'}) {
		my ($paramName,$newValue) = split('EQUALS', $params->{'theChange'});
		my $url = FAQ::OMatic::makeAref('faq',
			{$paramName=>$newValue,
				'appearance'=>'',
				'theChange'=>''},
			'url');
		#print "Content-type: text/plain\n\n";
		#print "url: $url\n";
		print $cgi->redirect(FAQ::OMatic::urlBase($cgi).$url);
		exit(0);
	}

	print FAQ::OMatic::pageHeader(1);
	
	$item = new FAQ::OMatic::Item($params->{'file'});
	if ($item->isBroken()) {
		FAQ::OMatic::gripe('error', "The file (".
			$params->{'file'}.") doesn't exist.");
	}

	if ($params->{'debug'}) {
		print $item->display();
	}
	print $item->displayHTML($params);

	## print the url for people to reference
	# distill out all the fluffy parameters, keep only the important ones
	my %killParams = %{$params};
	delete $killParams{'file'};
	delete $killParams{'recurse'};
	my $i; foreach $i (keys %killParams) { $killParams{$i} = ''; }

	my $url = FAQ::OMatic::urlBase($cgi)
			 .FAQ::OMatic::makeAref('', \%killParams, 'url');
	print "This document is: <i>$url</i><br>\n";
	
	print FAQ::OMatic::pageFooter();
}

1;
