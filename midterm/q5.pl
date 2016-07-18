#!/usr/bin/perl

use strict;
use warnings;

use constant AT => 2;
use constant GC => 4;

print "Enter oligomer to calculate annealing temperature and GC content:\n ";
my $oligomer = <STDIN>;
chomp $oligomer;

my ($temp, $GC) = anneal_temp($oligomer);
printf ("%s\nAnnealing temperature: %d°C\nGC content: %d%%\n", $oligomer, $temp, $GC);

sub anneal_temp {
	my $DNAseq = $_[0];
	my $GC_count = 0;
	my $seqlen = length($DNAseq);
	foreach my $base (split //, $DNAseq) {
		if ($base =~ /[GC]/) {
			$GC_count++;
		}
	}
	my $temp = ($GC_count * GC) + (($seqlen - $GC_count) * AT);
	return ($temp, ($GC_count/$seqlen * 100));
}
