#!/usr/bin/perl
use strict;
use warnings;

# generate 12x12 multiplication table

for (my $i = 1; $i < 13; $i++) {
	for (my $j = 1; $j < 13; $j++) {
		my $product = $i*$j;
		print "$product\t";
	}
	print "\n";
}
