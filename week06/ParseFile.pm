package ParseFile;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = ("parse_file");

=pod
=head1 parse_file
Called with a single argument consisting of the path of the file to be opened.
Opens file and parses the data; the def line is split by the pipe to create an 
array. The array is then iterated through to store each piece of data in its 
corresponding final array. The DNA sequence is temporarily stored as an array 
line by line, then joined together as a string and pushed to the final array 
@dnaseq. References to all the arrays are returned.
=cut

sub parse_file {
	my $filename = $_[0];
	open(my $fh, $filename) or die ("can't open $filename $!");
	my @data = <$fh>;
	close $fh;
	my @header;
	my @dnaseq;
	my @temp;
	my @gene;
	my @org;
	my @tissue;
	my @start;
	my @stop;
	my @level;

	foreach my $line (@data) {
		if ($line =~ m/^>/) {
			@header = [ split /\Q | /, $line ];
			foreach my $h(@header) {
				my @def = @{$h};
				foreach my $i(@def) {
					$i =~ s/[>]\s?//;
				}			
				push @gene, $def[0];
				push @org, $def[1];
				push @tissue, $def[2];
				push @start, $def[3];
				push @stop, $def[4];
				push @level, $def[5];
			}
		}

		else {
			push @temp, $line;
		}
	}

	my $seq = join("", @temp);
	push @dnaseq, $seq;

	return (\@gene, \@org, \@tissue, \@start, \@stop, \@level, \@dnaseq);
}