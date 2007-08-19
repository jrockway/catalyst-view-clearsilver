package Catalyst::View::ClearSilver;
use strict;
use warnings;
use base qw(Catalyst::View::Templated);

use Data::Structure::Util qw/unbless circular_off/;
use ClearSilver;
use Class::C3;

our $VERSION = '0.02';

sub new {
    my $self = shift;
    $self = $self->next::method(@_);
    
    # backcompat config options
    $self->{TEMPLATE_EXTENSION} ||= $self->{template_extension} || '.cs';
    $self->{INCLUDE_HDF} ||= $self->{hdfpaths};
    if (ref $self->{INCLUDE_HDF} ne 'ARRAY') {
        $self->{INCLUDE_HDF} = [$self->{INCLUDE_HDF}];
    }
    unshift @{$self->{INCLUDE_PATH}}, $self->{loadpaths};

    die "Cannot pass CATALYST_VAR; it's ignored" 
      if $self->{CATALYST_VAR} ne 'c';
    
    return $self;
}

sub _render {
    my ( $self, $template, $stash, $args ) = @_;
    
    delete $stash->{$self->{CATALYST_VAR}};
    
    my $hdf = $self->_create_hdf($stash);
    die qq/Couldn't create HDF dataset/ unless $hdf;
    
    my $cs = ClearSilver::CS->new($hdf);
    unless ($cs->parseFile($template)) {
        die qq/Failed to parse template/;
    }
    
    return $cs->render;
}

sub _create_hdf {
    my ( $self, $stash ) = @_;

    my $hdf = ClearSilver::HDF->new;
    for my $path (@{$self->{INCLUDE_HDF}||[]}) {
        $hdf->readFile($path) or die 'Failed to read HDF $path';
    }
    
    my $loadpaths = $self->{INCLUDE_PATH};
    _hdf_setValue($hdf, 'hdf.loadpaths', $loadpaths);

    $stash = unbless($stash);    
    while (my ($key, $val) = each %$stash) {
        _hdf_setValue($hdf, $key, $val);
    }
    
    return $hdf;
}

sub _hdf_setValue {
    my ($hdf, $key, $val) = @_;

    if (ref $val eq 'ARRAY') {
        my $index = 0;
        for my $v (@$val) {
            _hdf_setValue($hdf, "$key.$index", $v);
            $index++;
        }
    } 
    elsif (ref $val eq 'HASH') {
        while (my ($k, $v) = each %$val) {
            _hdf_setValue($hdf, "$key.$k", $v);
        }
    } 
    elsif (ref $val eq 'SCALAR') {
        _hdf_setValue($hdf, $key, $$val);
    } 
    elsif (defined $val) {
        $hdf->setValue($key, "$val");
    }
}

1;
__END__

=head1 NAME

Catalyst::View::ClearSilver - ClearSilver View Class

=head1 SYNOPSIS

Use the helper:

    create.pl view ClearSilver ClearSilver

Which generates C<lib/MyApp/View/ClearSilver.pm>:

    package MyApp::View::ClearSilver
    use base 'Catalyst::View::ClearSilver';
    1;

Configure it to your liking:

    MyApp->config->{View::ClearSilver} = {
        INCLUDE_PATH       => ['/path/to/loadpath', '/path/to/anotherpath'],
        TEMPLATE_EXTENSION => '.cs', # .cs is the default
        
        # optional:
        INCLUDE_HDF        => ['mydata1.hdf', 'mydata2.hdf'],
    };

Then use it:

    $c->forward('MyApp::View::ClearSilver');
    my $out = $c->view('ClearSilver')->render('template.cs');
    # etc.

=head1 DESCRIPTION

This is the C<ClearSilver> view class.  It works like
L<Catalyst::View::Templated|Catalyst::View::Templated>, so refer to
that for more details on what config options and methods you can use.

=head1 CAVEATS

You can't call back into your application from ClearSilver, so most of
the attributes in C<$c> will be worthless.  Be sure to pre-compute
anything you need and put it in the stash before rendering.

C<$c> will I<not> be included in your HDF at all, and hence the
C<CATALYST_VAR> config option is ignored.  Setting it is a fatal
error.

=head1 METHODS

=over 4

=item process

Renders the selected template and stores the result as the response body.

=item render($template)

Renders C<$template> and returns the result

=item template([$template])

Sets the template to render, or returns the template that will be
rendered.

=item new

Called by Catalyst.  Sets up the config (mapping 0.01 config variables
to 0.02 names).

=back

=head1 CONFIG VARIABLES

=over 4

=item INCLUDE_PATH

added to hdf.loadpaths.
default is C<< $c->config->{root} >> only.

=item INCLUDE_HDF

HDF Dataset files into the current HDF object.

=item TEMPLATE_EXTENSION

a sufix to add when looking for templates bases on the C<match> method
in L<Catalyst::Request>.

=back

=head1 AUTHOR

Jiro Nishiguchi C<< <jiro@cpan.org> >>

Jonathan Rockway C<< <jrockway@cpan.org> >>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst>, L<Catalyst::View::Templated>, L<ClearSilver>

ClearSilver Documentation:  L<http://www.clearsilver.net/docs/>
