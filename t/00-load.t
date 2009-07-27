use Test::More tests => 3;

BEGIN {
    use_ok('CSS::Minifier');
    use_ok('App::ZofCMS::Plugin::Base');
    use_ok( 'App::ZofCMS::Plugin::CSSMinifier' );
}

diag( "Testing App::ZofCMS::Plugin::CSSMinifier $App::ZofCMS::Plugin::CSSMinifier::VERSION, Perl $], $^X" );
