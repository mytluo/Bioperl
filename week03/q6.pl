#!/usr/bin/perl
use strict;
use warnings;

regexp();

# prompt for regexp and string and determine if there is a match
sub regexp {
    my $ask = 1;
    while ($ask) {
    	print "Please enter regexp: ";
	my $regex = <STDIN>;
	chomp ($regex);
	print "Enter string or 'exit' to exit: ";
	my $str = <STDIN>;
	chomp ($str);
	if ($str =~ m/exit/) {
		print "bye bye!\n";
	    	$ask = 0;
	} else {
		if ($str =~ m/\Q$regex/) {
		    	print "Match!\n";
			} else {
				print "No match!\n";
			}
		}
	}
}
