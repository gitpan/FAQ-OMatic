package FAQ::OMatic::checkedImage;

$checkedImage = <<__EOF__;
47494638396114001900f10000000000ffffffff000000000021f90401000001
002c000000001400190000024c8c8fa9cb21dd847c30cd6a2f3e7abbbe81a174
00e6899e2080add5c496af141bf572dd31993dfac733687e400ad086a8692614
62f18894719841673118b05e93dc5e420b95da522601f95600003b
__EOF__

sub main {
	my ($line, $out);
	foreach $line (split("\n", $checkedImage)) {
		$out .= pack("H".length($line), $line);
	}
	my $cgi = $FAQ::OMatic::dispatch::cgi;
	print $cgi->header("-type"=>"image/jpeg");
	print $out;
}

1;
