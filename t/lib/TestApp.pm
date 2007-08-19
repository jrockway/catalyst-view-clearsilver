package TestApp;
use Catalyst;

use FindBin qw($Bin);

TestApp->config->{View::ClearSilver} = {
    TEMPLATE_EXTENSION => '.cs',
    INCLUDE_HDF        => [TestApp->path_to('root', 'test.hdf')],
    INCLUDE_PATH       => [TestApp->path_to('root')],
};

TestApp->setup;

1;
