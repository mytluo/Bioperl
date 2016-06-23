package RandomDNA; 

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ("random_sequence");

=pod
random_sequence takes in two arguments, one required and one optional.
the first (required) argument is the length of DNA sequence to be generated.
if the second (optional) argument is given, then the function generates 
a DNA sequence of random length between 1 and the first argument.
=cut
sub random_sequence {
	my @bases = qw/ A C G T /;

	my( $length, $random_length ) = @_;

	if ( $random_length ) {
	$length = int( rand( $length ));
	}

	foreach ( 1 .. $length ) {
	print $bases[int(rand(4))];
	}
	print "\n";
}

1;