use Config;
$perl = $Config{'perlpath'};

# we would like to get INSTALLSITELIB the same way, but
# it depends on how Makefile.PL was invoked. If users use PREFIX=...,
# that value gets encoded in INSTALLSITELIB, but %Config doesn't see it.
# Hence the tricky mess of passing the value from Makefile.PL into the
# Makefile to here.
# $inc = $Config{'installsitelib'};
$inc = (grep {m/^INSTALLSITELIB=/} @ARGV)[0] || '';
$inc =~ s/^INSTALLSITELIB=// or die "fom.PL: INSTALLSITELIB= argument missing.\n";

open THECGI, ">fom" or die "Writing \"fom\": $!";
print THECGI "#!$perl -wT\n";
print THECGI "use lib '.';			# for suid installations\n";
print THECGI "use lib '$inc';\n";
print THECGI "$ENV{'PATH'} = '';	# for suid installations\n";
print THECGI "use FAQ::OMatic::dispatch;\n";
print THECGI "FAQ::OMatic::dispatch::main('fom-meta/');\n";
close THECGI;
chmod 0755, "fom";
