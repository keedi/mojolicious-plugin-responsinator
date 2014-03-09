use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Mojolicious::Plugin::MediaQuery',
  ABSTRACT_FROM => 'lib/Mojolicious/Plugin/MediaQuery.pm',
  VERSION_FROM => 'lib/Mojolicious/Plugin/MediaQuery.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {

  },
  BUILD_REQUIRES => {

  },
  META_MERGE => {
    resources => {
      license => 'http://dev.perl.org/licenses/',
      homepage => 'https://metacpan.org/release/Mojolicious-Plugin-MediaQuery',
      bugtracker => 'https://github.com/jhthorsen/mojolicious-plugin-mediaquery/issues',
      repository => 'https://github.com/jhthorsen/mojolicious-plugin-mediaquery.git',
    },
  },
  test => {
    TESTS => 't/*.t',
  },
  #MIN_PERL_VERSION => 5.10,
  #EXE_FILES => ['bin/my-app'],
);
