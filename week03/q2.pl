#!/usr/bin/perl
use strict;
use warnings;

# generate nxn multiplication table

print "Please enter the size of the multiplication table desired: ";
our $input = <STDIN>;

mult_table($input);

sub mult_table {
	my $size = $_[0];
	for (my $i = 1; $i <= $size ; $i++) {
		for (my $j = 1; $j <= $size; $j++) {
			my $product = $i*$j;
			print "$product\t";
		}
		print "\n";
	}
}
