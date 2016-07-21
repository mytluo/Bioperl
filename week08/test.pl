#!/usr/bin/perl

use strict;
use warnings;

use RestrictionEnzyme;

my $resenz = RestrictionEnzyme->new(
  name     => 'HaeIII',
  manufacturer => 'Hemophilus aegypticus',
  recognitionseq => 'GGCC',
);

my @bases = qw/ A C G T /;
my @seqarr = ();
foreach ( 1 .. 50 ) {
	push (@seqarr, $bases[int(rand(4))]);
}
my $randomseq = join("", @seqarr); 
my @test = $resenz->cut_dna($randomseq);
foreach (@test) {
	print "@{$_}\t";
}