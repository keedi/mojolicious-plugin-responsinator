use Mojo::Base -strict;
use Test::More;
use Test::Mojo;

{
  use Mojolicious::Lite;
  plugin "Responsinator";
  get "/" => sub { shift->render(text => "test\n") };
  app->start;
}

my $t = Test::Mojo->new;

$t->get_ok('/')->status_is(200)->content_is("test\n");
$t->get_ok('/?_size=800x')->status_is(200)->element_exists('iframe');

done_testing;
