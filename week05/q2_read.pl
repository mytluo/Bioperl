#!/usr/bin/perl
use strict;
use warnings;
use Storable;
use Data::Dumper;
  
# assume files are called 'seq1' thru 'seq10'
foreach my $file ( 1 .. 10 ) {
	my $filename = "seq$file";
	my $dataref = retrieve($filename);
	my $seq = Dumper $dataref; 	# read file with Data::Dumper
	BASE: foreach my $base ( qw/ A C G T / ) {
  		if ( $seq =~ /$base{4}/ ) {
    		print "$base run found in $filename\n";
    		last BASE;
 	 	}
	}
}