#!/usr/bin/perl
use strict;
use warnings;

# prompt length (or max length, if random length) of DNA sequence
sub prompt_length {
	print "Please enter (max) length of DNA desired (1-100): ";
	my $input_len = <STDIN>;
	return $input_len;
}

# ask for optional parameter of random length desire
sub prompt_random {
	print "Generate random length? (Y/N): ";
	chomp(my $input_op = <STDIN>);
	my $op = uc substr($input_op, 0, 1);
	return $op eq 'Y';
}

if (prompt_random) {
	random(prompt_length, "random");
} else {
	random(prompt_length);
}

sub random {
	my @nucleotides = ("A", "T", "G", "C");
    my $length;
	if (defined $_[1]) {
    	$length = int(rand $_[0]) + 1;		
    } else {
    	$length = $_[0];
    }
    for (my $i = 0; $i < $length; $i++) {
        my $nuc = int(rand @nucleotides);
        print $nucleotides[$nuc];
    }
	print "\n";
}
