#!/usr/bin/perl

use strict;
use warnings;

my %members = (
	serenity => ["mal", "zoe", "wash", "kaylee", "simon", "river", "jayne", "inara", "book"],
	normandy => ["shepard", "joker", "edi", "liara", "garrus", "mordin", "wrex", "kaidan", "grunt", "javik"],
	guardians => ["cayde-6", "zavala", "ikora", "eris", "shaxx", "rahool", "saladin", "xur"], );

for $crew (keys %members) {
	print "$crew: @{ $members{$crew} }\n";
}
