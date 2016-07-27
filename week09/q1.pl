#! /usr/bin/perl

use warnings;
use strict;

use Bio::Perl;

my $fasta = "path/to/file.fasta";

my $prots = parse_file($fasta);

#user can choose to pass as many sequences as they want to run_blast()
#as long as sequence exists

run_blast(${prots}[0], ${prots}[2]);

sub parse_file {
	my $file = $_[0];
	my @seqs = ();
	my @seq_objs = read_all_sequences ($file, 'fasta');
	foreach my $seq (@seq_objs) {
		my $sequence = $seq->seq;
		my $translated = translate($sequence);
		push @seqs, $translated;
	}
	return \@seqs;
} 
sub run_blast {
	my $blast_file "path/to/blast_output";
	foreach my $prot (@_) {
		my $blast = blast_sequence($prot);
		write_blast(">$blast_file", $blast);
	}
}
