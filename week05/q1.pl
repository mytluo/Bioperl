#!/usr/bin/perl

use strict;
use warnings;

my @a1 = (1, 2, 3);
my @a2 = (2, 4, 6);

# pass in arrays by reference
resmatrix(\@a1, \@a2);

sub resmatrix {
	my @a1 = @{$_[0]};
   	my @a2 = @{$_[1]};
   	foreach my $n1 (@a1) {
    	foreach my $n2 (@a2) {
        	print $n1*$n2, "\t";
      	}
   		print "\n";
   	}
}