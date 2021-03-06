#!/usr/bin/perl

use strict;
use warnings;

# Write a Perl program to convert temperatures from Fahrenheit to Celsius and Celsius to Fahrenheit. (User should be asked what scale input is in and program should act accordingly.) 10 points

use constant TO_CELCIUS => 5/9.;
use constant TO_FAHRENHEIT => 9/5.;

my $scale_prompt = ("Enter 'C' for Celcius or 'F' for Fahrenheit ('q' to quit): ");
my $temp_prompt = ("Enter the temperature to convert: ");

prompt();

sub prompt {
	while(1) {
		print $scale_prompt;
		my $scale = <STDIN>;
		chomp $scale;
		if ($scale =~ m/[Qq]/) {
			print "Goodbye.\n";
			last;
		} 
		else {
			print $temp_prompt;
			my $temp = <STDIN>;
			chomp $temp;
			my $converted_temp;
			my $converted_scale;
			if ($scale =~ m/[CcFf]/) {
				$converted_temp = convert($temp, $scale);
				if ($scale =~ m/[Cc]/) {
					$converted_scale = "F";
				}
				else {
					$converted_scale = "C";
				}
				printf ("%.1f°%s is %.1f°%s\n", $temp, $scale, $converted_temp, $converted_scale);
			}
			else {
				print "Invalid temperature scale. Please try again.\n";
			}
		}
	}
}

sub convert {
	my $temp = $_[0];
	my $scale = $_[1];
	if ($scale =~ m/[Cc]/) {
		return ((TO_FAHRENHEIT * $temp) + 32);
	} else {
		return (TO_CELCIUS * ($temp - 32));
	}
}
