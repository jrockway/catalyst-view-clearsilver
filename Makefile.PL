use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Catalyst::View::ClearSilver',
    AUTHOR        => 'Jonathan Rockway <jrockway@cpan.org>',
    VERSION_FROM  => 'lib/Catalyst/View/ClearSilver.pm',
    PL_FILES      => {},
    PREREQ_PM => {
        'Test::More'  => 0.32,
        'ClearSilver' => 0,
        'Catalyst'    => 5.7,
        'Catalyst::View::Templated' => 0.01,
        'Data::Structure::Util' => 0,       
        'Class::C3' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Catalyst-View-ClearSilver-*' },
);
