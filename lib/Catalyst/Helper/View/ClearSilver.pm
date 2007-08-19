package Catalyst::Helper::View::ClearSilver;

use strict;
use warnings;

=head1 NAME

Catalyst::Helper::View::ClearSilver - Helper for ClearSilver Views

=head1 SYNOPSIS

    script/create.pl view ClearSilver ClearSilver

=head1 DESCRIPTION

Helper for ClearSilver Views.

=head2 METHODS

=head3 mk_compclass

=cut

sub mk_compclass {
    my ( $self, $helper ) = @_;
    my $file = $helper->{file};
    $helper->render_file('compclass', $file);
}

=head1 SEE ALSO

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>

=head1 AUTHOR

Jiro Nishiguchi E<lt>jiro@cpan.orgE<gt>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;

__DATA__

__compclass__
package [% class %];

use strict;
use base 'Catalyst::View::ClearSilver';

=head1 NAME

[% class %] - Catalyst ClearSilver View

=head1 SYNOPSIS

See L<[% app %]>

=head1 DESCRIPTION

Catalyst ClearSilver View.

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

