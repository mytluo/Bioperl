#!/usr/bin/perl

use strict;
use warnings;

my @list = qw(1 5 4 345 6 1 -8 19 0 21 -199 1284);

print "@list\n";
printf ("max: %d\n", max_num(\@list));
printf ("min: %d\n", min_num(\@list));

sub max_num {
	my @nums = @{$_[0]};
	my $max = $nums[0]+0;
	foreach my $i (@nums) {
		if ($i+0 > $max) {
			$max = $i+0;
		}
	}
	return $max;
}

sub min_num {
	my @nums = @{$_[0]};
	my $min = $nums[0]+0;
	foreach my $i (@nums) {
		if ($i+0 < $min) {
			$min = $i+0;
		}
	}
	return $min;
}

