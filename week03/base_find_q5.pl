#!/usr/bin/perl
use strict;
use warnings;

my $counter = 1;

#call base_find for seq1 - seq10 
while ($counter <= 10) {
	base_find("seq$counter");
	$counter += 1;
}

#look for stretches of identical bases of length 4 or more
sub base_find {
	my $filename = $_[0];
	open(my $fh, $filename) or die ("can't open $filename $!");
	my $seq = <$fh>;
	if ($seq =~ /[A]{4,}/) {
		print "A run found in $filename\n";
	}
	if ($seq =~ /[T]{4,}/) {
        print "T run found in $filename\n";
        }
    if ($seq =~ /[G]{4,}/) {
        print "G run found in $filename\n";
    }
    if ($seq =~ /[C]{4,}/) {
        print "C run found in $filename\n";
    }
}
