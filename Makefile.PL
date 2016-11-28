# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.041.
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Generate Google Earth Camera Tours from Tracks and Paths",
  "AUTHOR" => "Gryphon Shafer <gryphon\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Geo-GoogleEarth-AutoTour",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010",
  "NAME" => "Geo::GoogleEarth::AutoTour",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Date::Parse" => 0,
    "Exporter" => 0,
    "IO::Compress::Zip" => 0,
    "IO::Uncompress::Unzip" => 0,
    "Math::Trig" => 0,
    "XML::LibXML" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::File" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "blib" => "1.01"
  },
  "VERSION" => "1.04",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Date::Parse" => 0,
  "Exporter" => 0,
  "File::Spec" => 0,
  "IO::Compress::Zip" => 0,
  "IO::File" => 0,
  "IO::Handle" => 0,
  "IO::Uncompress::Unzip" => 0,
  "IPC::Open3" => 0,
  "Math::Trig" => 0,
  "Test::More" => 0,
  "Test::Most" => 0,
  "XML::LibXML" => 0,
  "base" => 0,
  "blib" => "1.01",
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);