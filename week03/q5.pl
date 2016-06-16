#!/usr/bin/perl
use strict;
use warnings;

# generate 10 DNA sequences of at least 50 bases and store in separate files

my $files = 10;
my $seq = 1;
my @bases = ("A", "T", "G", "C");
while ($files > 0) {
    my $length = int(rand 50) + 50;
    my $filename = "seq$seq";
    $seq += 1;
    open (my $fh, '>', $filename) or die "could not open file $filename $!";
    for (my $i = 0; $i < $length; $i++) {
        my $base = int(rand @bases);
        print $fh $bases[$base];
    }
    $files -= 1;
    print "\n";
    close $fh;
}
