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
### dispatch.pm
###
### This is the dispatch module; it calls one of the command modules. (Each
### command module used to be a separate CGI, but this makes installation
### a lot easer.) A nearly-empty CGI calls this file, which parses the
### parameters to decide which module to load and run.

package FAQ::OMatic::dispatch;

sub main {
	$meta = shift;	# The single adjustable parameter in the actual CGI
	my $haveMeta=0;

	if (-f "$meta/config") {
		require "$meta/config";
		if ($meta eq $FAQ::OMatic::Config::metaDir) {
			$haveMeta = 1;
		}	# else meta has moved, and config file is out of date: send
			# user to install screen.
	} else {
		# if unconfigured, the default behavior is to install.
		# This could be bad -- it means if meta/config becomes inaccessible,
		# the Internet can install a new faqomatic on your machine. Hmmm.
		$haveMeta = 0;
	}

	# The map trick is a way to make a hash act like a "set" -- we use it
	# to test membership. This is the set of modules we know (prevents
	# the user from making up some other module and getting it into
	# our eval()).
	%knownModules = map {$_=>1} (
		'faq', 'search', 'recent', 'stats', 'statgraph',
		'appearanceForm',	'searchForm',
		'editPart', 'submitPart', 'delPart',
		'addItem', 'editItem', 'submitItem', 'moveItem', 'submitMove',
		'authenticate', 'changePass', 'submitPass',
		'install', 'maintenance',
		'pickerImage', 'checkedImage', 'uncheckedImage', 'spaceImage',
		'editGroups', 'submitGroup'
	);
	
	use CGI;
	
	$cgi = new CGI;
	my $cmd = ($haveMeta)
				? ($cgi->param('cmd') || 'faq')
				: 'install';

	my $problem = '';
	
	if ($knownModules{$cmd}) {
		my $dispatch = "use FAQ::OMatic::$cmd; FAQ::OMatic::".$cmd."::main();";
		eval($dispatch);
		$problem = $@;
	} else {
		$problem = "Unknown command: $cmd";
	}
	
	if ($problem) {
		# try a nice presentation, else fall back on text:
		require FAQ::OMatic;
		eval("require FAQ::OMatic; "
			."FAQ::OMatic::gripe('error', \$problem)");
		if ($@) {
			print $cgi->header('-type'=>"text/html");
			print "<tt>\n$problem\n</tt>\n";
		}
	}
}

1;
