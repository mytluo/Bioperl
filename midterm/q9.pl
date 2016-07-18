#!/usr/bin/perl

use strict;
use warnings;

use Test::Simple tests => 14;
use q8('translate_dna');

my @testseqs = ("ATGTTTGACACGGGGGGCCCAAACTTTAAACTGTGGTGA",
				"ACATGTGGACATCACGTACGATAACGGATCCACTGCCCA",
				"AAACCCGGGTTTAAACCCGGGTTTFFFATG",
				"AAATTTCCCGGGGGAGGCGGTTTATTGTTCAATAACAAG",
				"ATTATGCC**tcggaaagaggttaTT11TTCAACCGTAA",
				"acatGCCATTAGGACCCTTCGGCTTTTTCTTgggcTAG",
				"atgaggagaaccacaattatattatcctgggtagagaaa");
foreach my $s (@testseqs) {
	ok($s =~ /^[ACTG]+$/i, "test for invalid nucleotides");
	ok(translate_dna($s), "translate dna sequence");
}
