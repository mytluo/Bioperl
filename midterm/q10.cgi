#!/usr/bin/perl

use strict;
use warnings;
use CGI (':standard');
use DBI;

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
  my $title = "Search Expression Levels";
  print $q->start_html(-title => $title);
  print $q->h1($title);
}

sub display_results {
  my ($q) = @_;
  my $gene = $q->param('gene');
  my $organism = $q->param('organism');
  my $tissue = $q->param('tissue');
  my $level = $q->param('level');
  print $q->p(get_data(($gene, $organism, $tissue, $level)));
  output_form($q);
}

sub output_form {
  my ($q) = @_;
  print $q->start_form(
    -name => 'search',
    -method => 'POST',);
  print $q->start_table;
  print $q->Tr(
      $q->td('Gene name:'),
      $q->td(
        $q->textfield(-name => "gene", -size => 50,)
      )
  );
  print $q->Tr(
      $q->td('Organism:'),
      $q->td(
        $q->textfield(-name => "organism", -size => 50,)
      )
  );
  print $q->Tr(
      $q->td('Tissue type:'),
      $q->td(
        $q->textfield(-name => "tissue", -size => 50,)
      )
  );
  print $q->Tr(
      $q->td('Expression level:'),
      $q->td(
        $q->popup_menu(-name => "level", 
          -values => ['', '0-100', '100-500', '500-1000', '1000-5000', '5000-10000', '>10000'],
          -default => '',)
      )
  );
  print $q->Tr($q->td($q->submit(-value => 'Submit')));
  print $q->end_table;
  print $q->end_form;
}

sub get_data {
  my @params = qw(gene organism tissue level);
  my %fields = ();
  my $len = @_;
  foreach my $i ( 0 .. $len-1 ) {
    if ($_[$i] ne "") {
      $fields{$params[$i]} = $_[$i];
    } 
  }
  #print "Key: $_ and value: $fields{$_}\n" foreach (keys%fields);
  my $dbh = DBI->connect( "dbi:SQLite:data.dbl" ) || die "Cannot connect: $DBI::errstr";
  my $sth = $dbh->prepare("SELECT g.gene, g.organism, e.tissue, e.expressionlevel, g.sequence 
    FROM genes g JOIN expression e ON g.id = e.geneid 
    WHERE g.gene LIKE ? AND g.organism LIKE ? AND e.tissue LIKE ? AND e.expressionlevel BETWEEN ? AND ?");
  $sth->bind_param(1, "\%$fields{'gene'}\%");
  $sth->bind_param(2, "\%$fields{'organism'}\%");
  $sth->bind_param(3, "\%$fields{'tissue'}\%");
  $fields{'level'} =~ />?(\d+)-?(\d*)/;
  if (defined $1) {
    $sth->bind_param(4, $1+0);
  } else {
      $sth->bind_param(4, 0);
  } 
  if (defined $2) {
      $sth->bind_param(5, $2+0);
  } else {
    $sth->bind_param(5, 9223372036854775807);
  }
  $sth->execute();
  while (my @row = $sth->fetchrow_array()) {
    print "<p>Gene: $row[0]</p>";
    print "<p>Organism: $row[1]</p>";
    print "<p>Tissue type: $row[2]</p>";
    print "<p>Expression level: $row[3]</p>";
    print "<p>Sequence: $row[4]</p>";
  } 
  print "<i>end of results</i>";
}
