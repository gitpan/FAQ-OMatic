$perl = $ARGV[0];
$perl =~ s/^PERL=// or die "fom.PL: Unexpected argument list.\n";
$inc = $ARGV[1];
$inc =~ s/^INSTALLSITELIB=// or die "fom.PL: Unexpected argument list.\n";

open THECGI, ">fom" or die "Writing \"fom\": $!";
print THECGI "#!$perl\n";
print THECGI "use lib '$inc';\n";
print THECGI "use FAQ::OMatic::dispatch;\n";
print THECGI "FAQ::OMatic::dispatch::main('meta/');\n";
close THECGI;
chmod 0755, "fom";
