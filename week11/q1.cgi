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
  my $title = "NCBI Entrez";
  print $q->start_html(-title => $title);
  print $q->h1($title);
}

sub display_results {
  my ($q) = @_;
  my $query = $q->param('query');
  print "<p>ESEARCH RESULTS FOR: $query</p>";
  $q->p(entrez_search($query));
  output_form($q);
}

sub output_form {
  my ($q) = @_;
  print $q->start_form(
    -name => 'search',
    -method => 'POST',);
  print $q->start_table;
  print $q->Tr(
      $q->td('Keyword query:'),
      $q->td($q->textfield(-name => "query", -size => 50,))
  );
  print $q->end_table;
  print $q->p(submit(-value => 'Submit'));
  print $q->end_form;
}

sub entrez_search {
  my $query = $_[0];
  use LWP::Simple;
  my $utils = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils";
  my $esearch = get("$utils/egquery.fcgi?term=$query");
  print "<table><tr><th colspan='3'>Database</th><th>Count</th></tr>";
  while ($esearch =~ /<MenuName>(.+)[<].+<Count>(\d+)/g) {
    print "<tr><td colspan='3'>$1</td><td>$2</td></tr>";
  }
  print "</table></br></br>";
}