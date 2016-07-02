#!/usr/bin/perl
use strict;
use warnings;

# prompt for type of sequence desired
sub prompt_type {
	print "Please enter 'DNA' or 'protein' to generate desired sequence, or any other key to exit: ";
	my $input_type = <STDIN>;
	return $input_type;
}

# store results of user input 
my $seqtype = prompt_type;

while ($seqtype =~ /^[DdPp]/) { # if user input starts with a D or P
	random_sequence($seqtype);  # call on subroutine random_sequence
	$seqtype = prompt_type();	# prompt user again and store results 
}

sub random_sequence {
	my @DNA = qw / A C G T /;
	my @protein = qw / A C D E F G H I K L M N P Q R S T V W Y /; 

	my $type = $_[0]; 

	foreach ( 1 .. 50 ) {
		if ( $type =~ /^[Dd]/ ) {
			print $DNA[int(rand @DNA)];
		}
		else {
			print $protein[int(rand @protein)];
		}
	}
	print "\n";
}