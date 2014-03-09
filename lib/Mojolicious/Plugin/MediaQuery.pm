package Mojolicious::Plugin::MediaQuery;

=head1 NAME

Mojolicious::Plugin::MediaQuery - Simulate media queries

=head1 VERSION

0.01

=head1 DESCRIPTION

This module allow you to embed a given web page inside an iframe, to see
how it would look on different screens.

=head1 SYNOPSIS

You need to enable the plugin in your L<Mojolicious> application:

  use Mojolicious::Lite;
  plugin "MediaQuery";
  get "/" => sub { shift->render(text => "test\n") };
  app->start;

The from the browser, you can ask for an URL with the "_mq" param to embed a
website inside an iframe. Example:

  http://localhost:3000/some/path?_mq=iphone   # iphone portrait
  http://localhost:3000/some/path?_mq=r:iphone # iphone landscape
  http://localhost:3000/some/path?_mq=100x400  # width: 100px; height: 400px

=cut

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

=head1 ATTRIBUTES

=head2 presets

Defined presets:

  desktop: 992x
  ipad:    1024x768
  iphone:  320x480
  large:   1200x
  tablet:  768x

=cut

has presets => sub {
  return {
    desktop => '992x',
    ipad => '1024x768',
    iphone => '320x480',
    large => '1200x',
    tablet => '768x',
  };
};

=head1 METHODS

=head2 register

  $self->reqister($app, \%config);
  $app->plugin(MediaQuery => \%config);

Will register an "around_dispatch" hook, which will trigger on the C<_mq>
query param. C<%config> can contain:

=over 4

=item * param

Use this to specify another query param than the default "_mq".

=item * presets

This should be a hash-ref with the same format as the attribute L</presets>.

=back

=cut

sub register {
  my($self, $app, $config) = @_;
  my $param = $config->{param} || '_mq';
  my %presets = ( %{ $config->{presets} || {} }, %{ $self->presets } );

  $app->hook(around_dispatch => sub {
    my($next, $c) = @_;
    my $size = $c->param($param) or return $next->();
    my $url = $c->req->url->to_abs;
    my($rotate, $height, $width);

    $rotate = $size =~ s!^r:!!;
    $size = $presets{$size} if $presets{$size};
    $size =~ /^(\d*)x(\d*)$/ or return $next->();
    $width = $1 ? "${1}px" : "100%";
    $height = $2 ? "${2}px" : "100%";
    ($width, $height) = ($height, $width) if $rotate;
    $url->query->remove($param); # make sure it does not recurse

    $c->render(
      text => <<"      HTML",
<html style="width:100%;height:100%;padding:0;margin:0;">
<head><title>width:$width; height:$height;</title></head>
<body style="width:100%;height:100%;padding:0;margin:0;background:#333;">
<iframe style="width:$width;height:$height;background: #fff;border:0;" src="$url"></iframe>
</body>
</html>
      HTML
    );
  });
}

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
