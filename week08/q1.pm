package RestrictionEnzyme;

use Moose;
use Moose::Util::TypeConstraints;
=pod
RestrictionEnzyme creates a class with attributes name, manufacturer, 
and recognition sequence using Moose. The name and recognition sequence 
are required when creating a new instance of the class object; manufacturer
defaults to "unknown" if not entered. We use AUTOLOAD to automatically
generate accessor and mutator methods (if permission settings permit), 
and there is one class method, cut_dna.
=cut

# define subtype "Nucleotides" so the recognition sequence attribute
# can be sepcified to be of type Nucleotides. 

subtype 'Nucleotides'
	=> as 'Str'
	=> where { /^[ACGT]+$/i};

# class attributes
has 'name' => (is => 'ro', required => 1);
has 'manufacturer' => (is => 'rw');
has 'recognitionseq' => (isa => 'Nucleotides', is => 'ro', required => 1,
					reader => 'getSite');

=pod
cut_dna takes in a DNA sequence and splits it by the restriction
sequence as specified by the class object self. It returns a 
reference to the array containing the cut pieces of DNA.
=cut

sub cut_dna {
	my ($self, $dnaseq) = ( @_ );
	my $cutsite = $self->getSite;
	my $seq = uc $dnaseq;
	my @sites = (split(qr/($cutsite)/, $seq));
	return \@sites;
}
1;