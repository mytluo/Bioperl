#!/usr/bin/perl
use strict;
use warnings;
use Storable;

# generate 10 DNA sequences of at least 50 bases and write to disk

my $files = 10;
my @bases = ("A", "T", "G", "C");
while ($files > 0) {
    my $length = int(rand 50) + 50;
    my $filename = "seq$files";
    my @dnaseq = (); # empty array to store new randomly generated sequence
    for (my $i = 0; $i < $length; $i++) {
        my $base = int(rand @bases); # generate random int
        push(@dnaseq, $bases[$base]); # use int to retrieve random base and push it to @dnaseq
    }
    my $DNAseq = join("", @dnaseq); # join array to string 
    store \$DNAseq, $filename;      
    $files -= 1;
}