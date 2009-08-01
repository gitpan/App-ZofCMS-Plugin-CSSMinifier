package App::ZofCMS::Plugin::CSSMinifier;

use warnings;
use strict;

our $VERSION = '0.0104';
use CSS::Minifier qw/minify/;
use base 'App::ZofCMS::Plugin::Base';

sub _key { 'plug_css_minifier' }
sub _defaults {
    auto_output => 1,
    cache       => 1,
    file        => undef,
}
sub _do {
    my ( $self, $conf, $t ) = @_;

    return
        unless defined $conf->{file}
            and length $conf->{file};

    -e $conf->{file}
        or die "$conf->{file} was not found";

    open my $fh, '<', $conf->{file}
        or die "$conf->{file} could not be opened for reading: $!";

    my $css = minify( input => $fh );

    if ( $conf->{auto_output} ) {
        if ( $conf->{cache} ) {
            print "Expires: Fri, 29 Oct 2038 14:19:41 GMT\n"
        }
        print "Content-type: text/css\n\n";
        print $css;
        exit;
    }
    else {
        $t->{t}{plug_css_minifier} = $css;
    }
}
1;
__END__

=head1 NAME

App::ZofCMS::Plugin::CSSMinifier - plugin for minifying CSS files

=head1 SYNOPSIS

In your ZofCMS Template or Main Config File:

    plugins => [
        qw/CSSMinifier/,
    ],

    plug_css_minifier => {
        file => 'main.css',
    },

Now, this page can be linked into your document as a CSS file (it will be minified)

=head1 DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides means to send minified CSS files.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

=head1 WTF IS MINIFIED?

Minified means that all the useless stuff (which means whitespace, etc)
will be stripped off the CSS file to save a few bytes. See L<CSS::Minifier> for more info.

=head1 FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

=head2 C<plugins>

    plugins => [
        qw/CSSMinifier/,
    ],

B<Mandatory>. You need to include the plugin to the list of plugins to execute.

=head2 C<plug_css_minifier>

    plug_css_minifier => {
        file        => 'main.css',
        auto_output => 1, # default value
        cache       => 1, # default value
    },

    plug_css_minifier => sub {
        my ( $t, $q, $config ) = @_;
        return {
            file        => 'main.css',
            auto_output => 1, # default value
            cache       => 1, # default value
        }
    },

B<Mandatory>. Takes or a subref as a value. If subref is specified,
its return value will be assigned to C<plug_css_minifier> as if it was already there. If sub returns
an C<undef>, then plugin will stop further processing. The C<@_> of the subref will
contain (in that order): ZofCMS Tempalate hashref, query parameters hashref and
L<App::ZofCMS::Config> object; individual keys can be set in both Main Config
File and ZofCMS Template, if the same key set in both, the value in ZofCMS Template will
take precedence. The following keys/values are accepted:

=head3 C<file>

    plug_css_minifier => {
        file        => 'main.css',
    }

B<Mandatory>. Takes a string as an argument that specifies the name of the CSS file to
minify. The filename is relative to C<index.pl> file.

=head3 C<cache>

    plug_css_minifier => {
        file        => 'main.css',
        cache       => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value the plugin will
send out an HTTP C<Expires> header that will say that this content expries in like 2038, thus
B<set this option to a false value while still developing your CSS>. This argument
has no effect when C<auto_output> (see below) is turned off (set to a false value).
B<Defaults to:> C<1>

=head3 C<auto_output>

    plug_css_minifier => {
        file        => 'main.css',
        auto_output => 1,
    },

B<Optional>. Takes either true or false values. When set to a true value, plugin will
automatically send C<text/css> C<Content-type> header (along with C<Expires> header if
C<cache> argument is set to a true value), output the minified CSS file B<and exit()>.
Otherwise, the minified CSS file will be put into C<< $t->{t}{plug_css_minifier} >>
where C<$t> is ZofCMS Template hashref and you can do whatever you want with it.
B<Defaults to:> C<1>

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://haslayout.net/>, L<http://zoffix.com/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-cssminifier at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-CSSMinifier>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::CSSMinifier

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-CSSMinifier>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-CSSMinifier>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-CSSMinifier>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-CSSMinifier/>

=back



=head1 COPYRIGHT & LICENSE

Copyright 2009 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

