package FAQ::OMatic::spaceImage;

$spaceImage = <<__EOF__;
47494638396114001900f00000ffffff00000021f90401000000002c00000000
14001900000214848fa9cbed0fa39cb4da8bb3debcfb0f86e28814003b
__EOF__

sub main {
	my ($line, $out);
	foreach $line (split("\n", $spaceImage)) {
		$out .= pack("H".length($line), $line);
	}
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	print $cgi->header("-type"=>"image/jpeg");
	print $out;
}

1;
