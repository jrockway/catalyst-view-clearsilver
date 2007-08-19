#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 3;
use FindBin qw($Bin);
use lib "$Bin/lib";
use Catalyst::Test qw(TestApp);
is get('/test'),  "Hello, Universe.\n";
is get('/world'), "Hello, world.\n";
is get('/hdf'),   "baz = Baz\n";
