#!/usr/bin/perl
use strict;
use warnings;
use CGI (':standard');

my $title = "Random Sequence Generator";
print header,
	start_html($title),
	h1($title);

if(param('submit')) {
		my $type = param('type');
		print("type", $type);
		print p(random_sequence($type));
		hr();
}

my $url = url();
print start_form(-method => 'GET', action => $url),
p("Choose sequence type to generate: " . radio_group(-name => 'type',
													-values => ['DNA', 'Protein']));
p(submit(-name => 'submit', value => 'Submit')),
end_form();
end_html();
=
# prompt for type of sequence desired
sub prompt_type {
	print "Please enter 'DNA' or 'protein' to generate desired sequence, or any other key to exit: ";
	my $input_type = <STDIN>;
	return $input_type;
}

# store results of user input 
my $seqtype = prompt_type;

while ($seqtype =~ /^[DdPp]/) { # if user input starts with a D or P
	random_sequence($seqtype);  # call on subroutine random_sequence
	$seqtype = prompt_type();	# prompt user again and store results 
}
=cut

sub random_sequence {
	my @DNA = qw / A C G T /;
	my @protein = qw / A C D E F G H I K L M N P Q R S T V W Y /; 

	my $type = $_[0]; 

	foreach ( 1 .. 50 ) {
		if ( $type =~ /^[Dd]/ ) {
			print $DNA[int(rand @DNA)];
		}
		else {
			print $protein[int(rand @protein)];
		}
	}
	print "\n";
}