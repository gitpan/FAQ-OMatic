package FAQ::OMatic::uncheckedImage;

$uncheckedImage = <<__EOF__;
47494638396114001900f00000000000ffffff21f90401000001002c00000000
1400190000022c8c8fa9cbed0fa39cb4da06b2de1c201f8186f890a4634a69f8
a92d7b9cd80bad355de2a83ec76edc09661005003b
__EOF__

sub main {
	my ($line, $out);
	foreach $line (split("\n", $uncheckedImage)) {
		$out .= pack("H".length($line), $line);
	}
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	print $cgi->header("-type"=>"image/jpeg");
	print $out;
}

1;
