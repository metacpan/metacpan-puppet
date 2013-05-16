#!/usr/bin/perl

use strict;
use warnings;

use Plack::App::Directory;
my $app = Plack::App::Directory->new({
        root => '/home/metacpan/vmbox.metacpan.org/files/',
})->to_app;

return $app;