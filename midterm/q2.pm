#Write a subroutine that returns a reference to a hash. Write a script that (a) declares a reference to this function, (b) calls the function via the reference, and (c) prints out the hash whose reference is returned from the subroutine. 10 points

package q2;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ("return_hash");

sub return_hash {
	my %tower = qw(Cayde-6 Exo
			IkoraRey Human
			Zavala Awoken);
	return \%tower;
}
