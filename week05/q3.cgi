#!/usr/bin/perl
use strict;
use warnings;
use CGI (':standard');

my $q = new CGI;
print $q->header();
output_top($q);

if ($q->param()) {
  display_results($q);
} else {
  output_form($q);
}

exit 0;

sub output_top {
  my ($q) = @_;
  my $title = "Random Sequence Generator";
  print $q->start_html(-title => $title);
  print $q->h1($title);
}

sub display_results {
  my ($q) = @_;
  my $type = $q->param('type');
  print $q->p(random_sequence($type));
  output_form($q);
}

sub output_form {
  my ($q) = @_;
  print $q->start_form(
    -name => 'type',
    -method => 'POST',);
  print $q->radio_group(-name => 'type',
    -values => ['DNA', 'Protein'],);
  print $q->p(submit(-value => 'Submit'));
}

sub random_sequence {
  my @DNA = qw / A C G T /;
  my @protein = qw / A C D E F G H I K L M N P Q R S T V W Y /; 

  my $type = $_[0];
  print "type ", $type; 
  my @resseq = (); 
  foreach ( 1 .. 50 ) {
    if ( $type eq "DNA" ) {
      push(@resseq, $DNA[int(rand @DNA)]);
    }
    elsif ($type eq "Protein") {
      push(@resseq, $protein[int(rand @protein)]);
    }
  }
  return join("", @resseq);
}