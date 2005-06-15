#!/usr/bin/perl -w
use strict;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $prereqs = {'SOAP::Lite' => 0,
               'mod_perl2' => 0,
              };
my %opts = (
            NAME              => 'Apache2::SOAP',
            VERSION_FROM      => 'lib/Apache2/SOAP.pm', # finds $VERSION
            dist   => {
                        SUFFIX   => 'gz',
                        COMPRESS => 'gzip -9f',
                    },
            PL_FILES => {},
            PREREQ_PM => $prereqs,
           );

my $eu_version = $ExtUtils::MakeMaker::VERSION;
if ($eu_version >= 5.43) {
  $opts{ABSTRACT} = q{mod_perl-2 SOAP server};
  $opts{AUTHOR} = 'Randy Kobes <r.kobes@uwinnipeg.ca>';
}
if ($eu_version > 6.11 ) {
  $opts{NO_META} = 1;
}

eval {require ModPerl::MM;};
if ($@) {
  die "ModPerl::MM required";
}
ModPerl::MM::WriteMakefile(%opts);

# use Apache::Test to test things, but if not available,
# print out a message to that effect for 'make test'

sub MY::test {
  eval {require Apache::TestMM; import Apache::TestMM qw(test clean)};
  unless ($@) {
    Apache::TestMM::filter_args();
    Apache::TestMM::generate_script('t/TEST');
    return Apache::TestMM->test;
  }
  
  return <<'EOF';
test::
	@echo This test suite requires Apache::Test,
	@echo available from the mod_perl 2 sources
	@echo or from CPAN.
EOF

}

