#!/usr/bin/perl

use strict;
use warnings;

my @input = ();

print "Input the number of rows desired: ";
my $rows = <STDIN>;
print "Input the number of columns desired: ";
my $cols = <STDIN>;
chomp $rows;
chomp $cols;
my $counter = $cols;
my @rowarr = ();
while ($rows > 0) {
	if ($counter == 0) {
		$rows--;
		push (@input, [@rowarr[0 .. $cols-1]]);
		@rowarr = ();
		$counter = $cols;
	} else {
		print "Input element of matrix: ";
		my $element = <STDIN>;
		chomp $element;
		push (@rowarr, $element);
		$counter--;	
	}
}

my @output = transpose(\@input);
print "input matrix: \n";
print "@$_\n" for @input;
print "\noutput matrix: \n";
print "@$_\n" for @output;

sub transpose {
	my @input = @{$_[0]};
	my @output;
	foreach my $i (0 .. $#input) {
		my @row = @{$input[$i]};
		foreach my $j (0 .. $#row) {
			$output[$j][$i] = $row[$j];
		} 
	}
	return @output;
}
