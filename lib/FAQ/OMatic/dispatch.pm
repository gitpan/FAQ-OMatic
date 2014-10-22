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
### dispatch.pm
###
### This is the dispatch module; it calls one of the command modules. (Each
### command module used to be a separate CGI, but this makes installation
### a lot easer.) A nearly-empty CGI calls this file, which parses the
### parameters to decide which module to load and run.

package FAQ::OMatic::dispatch;

#use FAQ::OMatic;
#	--the fewer pieces we statically include, the more likely we can
#	dynamically catch any compile errors and display them gracefully
#	instead of giving an Infernal Server Error.

use vars qw($meta $cgi);

sub main {
	$meta = shift;	# The single adjustable parameter in the actual CGI
	my $haveMeta=0;

	# it's not so important what this path is (though a good selection
	# will help the install cmd make better suggestions for the mail and
	# RCS commands), but that we set it so it's not tainted.
	$ENV{'PATH'} = '/bin:/usr/bin:/usr/sbin:/usr/local/bin';

	if (-f "$meta/config") {
		# note config file is not subject to 'use strict,' since it is
		# inside its own file.
		require "$meta/config";
		if ($meta eq ($FAQ::OMatic::Config::metaDir||'')) {
			$haveMeta = 1;
		} else {
			print "Content-type: text/plain\n\n";
			print "meta moved. jonh didn't really feel like dealing\n";
			print "with this case. Mail him at jonh\@cs.dartmouth.edu .\n";
			exit 0;
		}
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
	my %knownModules = map { $_ => $_ } (
		'faq', 				'help',				'appearanceForm',
		'search',			'searchForm',		'recent',
		'stats', 			'statgraph',
		'authenticate',		'changePass',		'submitPass',
		'editPart',			'submitPart',		'delPart',
		'addItem',			'editItem',			'submitItem',
		'editModOptions',	'submitModOptions',
		'submitCatToAns',	'submitAnsToCat',
		'moveItem',			'submitMove',
		'selectBag',		'editBag',			'submitBag',
		'install',			'maintenance',
		'editGroups',		'submitGroup',
		'img',				'mirrorServer',		'displaySlow'
	);

	# functions that we need to run even if the versions mismatch.
	# not sure every maintenance task can be run when there's
	# a mismatch, but some need to, since they're accessed from
	# the installer. Can add another version check in maintenance.pm
	# if I need to later, I guess.
	my %versionSafeFunc = map { $_ => $_ } (
		'install',			'img',
		'authenticate',		'maintenance',
		'displaySlow',		'changePass',
		'submitPass'
	);
	
	use CGI;
	
	$cgi = new CGI;
	my $cmd = ($haveMeta)
				? ($cgi->param('cmd') || 'faq')
				: 'install';

	my $problem = '';
	my $func;

	# notice we take the value of the hash lookup, rather than just
	# testing it -- that handily untaints $func.
	if ($func = $knownModules{$cmd}) {
		# Require means we don't load the module until we need it.
		# (But mod_perl will accumulate modules, and only load them
		# if they haven't been loaded before, of course.)
		# This invocation will call the $func module's main()

		# from here inside, catch warnings as errors.
		local $SIG{'__WARN__'} = sub { die $_[0] };

		eval {
			require "FAQ/OMatic/$func.pm";

			if (($FAQ::OMatic::Config::version || '') ne $FAQ::OMatic::VERSION
				and not $versionSafeFunc{$func}) {
				FAQ::OMatic::gripe('abort', "The scripts don't match the "
					."configured version number. Admin must run "
					.FAQ::OMatic::makeAref('-command'=>'install')
					."installer</a>. "
					."This message has been sent to "
					."$FAQ::OMatic::Config::adminEmail.");
			}

			eval "FAQ::OMatic::".$func."::main();";
			die $@ if ($@);	# pass internal errors out to next eval
		};
		$problem = $@;
	} else {
		$problem = "Unknown command: $cmd";
	}
	
	if ($problem ne '') {
		# something broken happened. Let the admin know,
		# lest it was a script that failed to compile, or a
		# 'use strict' message or -w warning.
		# try a nice presentation, else fall back on text:
		# (unfortunately, text errors don't get mailed to $faqAdmin.)
		eval("require FAQ::OMatic; "
			."FAQ::OMatic::gripe('abort', 'problem: '.\$problem);");
		if ($@) {
			print $cgi->header('-type'=>"text/html");
			print "<tt>\n$problem\n</tt>\n";
		}
	}
}

1;
