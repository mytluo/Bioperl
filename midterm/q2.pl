#!/usr/bin/perl

# Write a subroutine that returns a reference to a hash. Write a script that (a) declares a reference to this function, (b) calls the function via the reference, and (c) prints out the hash whose reference is returned from the subroutine. 10 points

use strict;
use warnings;
use q2("return_hash");

my %action = ("hash" => \&q2::return_hash);

my $hashref = $action{"hash"}->();

foreach (keys %$hashref) {
	print "$_: $hashref->{$_}\n"
}
