#!/usr/bin/perl
use strict;
use warnings;

# generate DNA sequence of length 50

my @bases = ("A", "T", "G", "C");
for (my $i = 0; $i < 50; $i++) {
	my $nuc = int(rand @bases);
	print "$bases[$nuc]";
}
print "\n";
