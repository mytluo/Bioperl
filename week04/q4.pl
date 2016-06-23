#!/usr/bin/perl
use strict;
use warnings;

use Test::Simple tests => 2;

use RandomDNA ('random_sequence');

my $len = 50;
my $random = 1;

ok(random_sequence($len), "DNA length = 50");
ok(random_sequence($len, $random), "DNA length random");
