use ExtUtils::MakeMaker;

sub MY::processPL {
	my $self = shift;
	local *processPL;
	$_ = $self->MM::processPL;
	my @lines = split("\n", $_);
	my $i;
	# include extra params on fom line
	for ($i=0; $i<@lines; $i++) {
		last if ($lines[$i] =~ m/^fom/);
	}
	$i+=1;	# we actually want to append the _next_ line.
	if ($lines >= @lines) {
		print STDERR "Warning: Makefile.PL's overriding of "
			."processPL seems to have failed.\n";
	} else {
		$lines[$i].= " PERL=\$(PERL)"
			." INSTALLSITELIB=\$(INSTALLSITELIB)";
	}
	$_ = join ("\n", @lines)."\n";
}

WriteMakefile(
	NAME			=> 'FAQ::OMatic',
	VERSION_FROM	=> 'lib/FAQ/OMatic.pm',
	'dist'			=> { 'COMPRESS'=>'gzip',
						 'SUFFIX'=>'gz',
						 'POSTOP'=>
				'mv FAQ-OMatic-$(VERSION).tar.gz $(HOME)/dist; '
				.'scp $(HOME)/dist/FAQ-OMatic-$(VERSION).tar.gz zealand.cs:ftp; '
				.'ssh zealand.cs chmod 644 ftp/FAQ-OMatic-$(VERSION).tar.gz'
						},
);