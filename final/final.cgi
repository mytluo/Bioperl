#!/usr/bin/perl
use warnings;
use strict;
$|++;

use DBI;
use CGI (':standard');
use LWP::Simple;
use Bio::DB::GenBank;
use Bio::SeqFeatureI;
use Bio::Tools::Run::RemoteBlast;

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
  my $title = "Bioperl Final";
  print $q->start_html(-title => $title);
  print $q->h1($title);
}

sub display_results {
  my ($q) = @_;
  my $query = $q->param('acc');
  my $format = $q->param('format');
  my $blast = $q->param('blast');
  print $q->h2("Accession: $query");
  $q->p(search($query, $format, $blast)); 
  output_form($q);
}

sub output_form {
  my ($q) = @_;
  print $q->start_form(
    -name => 'search',
    -method => 'POST',);
  print $q->start_table;
  print $q->Tr(
      $q->td('Accession:'),
      $q->td($q->textfield(-name => 'acc', -size => 50,)),
  );
  print $q->Tr(
      $q->td('Display format:'),
      $q->td(radio_group(-name => 'format', -values => ['FASTA', 'GenBank (full)'],)),
  );
  print $q->Tr(
      $q->td('Run BLAST?'),
      $q->td(
        $q->popup_menu(-name => 'blast', 
          -values => ['', 'blastn', 'blastp', 'blastx', 'tblastn', 'tblastx'],
          -default => '',)),
  );
  print $q->end_table;
  print $q->p(submit(-value => 'Submit'));
  print $q->end_form;
}

sub search {
  $_[0] =~ m/(\w+)/;
  my $acc = $1;
  my $format = $_[1];
  my $blast = $_[2];
  my $s;

  if ($format eq 'GenBank (full)') { # fetch GenBank flat file (unformatted)
	  $s = get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=$acc&rettype=gp");
  } else { # fetch FASTA file
  	  $s = get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=$acc&rettype=fasta");	
  }
  die "couldn't get GenBank file!" unless defined $s;
  print "<font face='Courier'>$s\n</font>";
  my $gbh = Bio::DB::GenBank->new(-format => 'fasta');
  my $seq = $gbh->get_Seq_by_id( $acc );
  if (database_search($acc) == 0) { #if accession number does not already exist in database

	my $id = $seq->display_name;
	my $desc = $seq->desc;
	my $fullseq = $seq->seq;
	my $type = $seq->alphabet;
	my $len = $seq->length;
	my $def = ">$id$desc";
	database_entry($acc, $def, $len, $type, $fullseq); #add accession and related info to accessions table
  }
  if ($blast) { #if BLAST run selected
  	my $prog = $blast;
  	if (blast_search($acc, $prog) == 0) { #if BLAST results not already in database
	  	my $factory = Bio::Tools::Run::RemoteBlast->new(
	  		-prog => $prog, -data => 'nr', -expect => '1e-10', -readmethod => 'SearchIO');
	  	$factory->submit_blast($acc);
	  	while (my @rids = $factory->each_rid) {
	  		foreach my $rid (@rids) {
	  			my $result = $factory->retrieve_blast($rid);
	  			if (ref($result)) {
	  				my $output = $result->next_result();
	  				$factory->remove_rid($rid);
	  				foreach my $hit($output->hits) {
	  					my $res_acc = $hit->accession;
	  					my $desc = $hit->description;
	  					my $hsp = $hit->hsp;
	  					my $evalue = $hsp->evalue;
	  					my $id = $hsp->percent_identity;
	  					#add BLAST results to blast_results table
	 					blast_database($acc, $prog, $res_acc, $desc, $evalue, $id); 
	  				}
	  			}
	  		}
	  	
	  	}
	}
	blast_search($acc, $prog); #print results to user
  }
}

sub blast_database {
	# adds specific BLAST results of the queried accession to table blast_results
	my $query_acc = $_[0];
	my $prog = $_[1];
	my $res_acc = $_[2];
	my $desc = $_[3];
	my $evalue = $_[4];
	my $id = $_[5];
	my $dbh = DBI->connect( "DBI:SQLite:final.db", {RaiseError => 1} ) 
		or die "Cannot connect: $DBI::errstr";
	my $sth = qq(CREATE TABLE IF NOT EXISTS blast_results 
		(accession VARCHAR(25) PRIMARY KEY UNIQUE NOT NULL, 
		blast_prog TEXT NOT NULL, 
		result_acc VARCHAR(25) NOT NULL,
		result_desc TEXT,
		evalue INT NOT NULL,
		percent_id INT NOT NULL););
	my $rv = $dbh->do($sth);
	my $sql = $dbh->prepare("INSERT OR IGNORE INTO blast_results VALUES (?, ?, ?, ?, ?, ?)");
	$sql->bind_param(1, $query_acc);
	$sql->bind_param(2, $prog);
	$sql->bind_param(3, $res_acc);
	$sql->bind_param(4, $desc);
	$sql->bind_param(5, $evalue);
	$sql->bind_param(6, $id);
	$sql->execute(); 
	$dbh->disconnect;
}

sub blast_search {
	# search blast_results for existing entry given the query accession and BLAST program
	my $query_acc = $_[0];
	my $prog = $_[1];
	my $dbh = DBI->connect( "DBI:SQLite:final.db", {RaiseError => 1} ) 
		or die "Cannot connect: $DBI::errstr";
	my $sel = $dbh->prepare("SELECT res_acc, desc, evalue, id FROM blast_results WHERE accession = ? AND blast_prog = ?");
	$sel->execute($query_acc, $prog);
	my $count = 0;
	print "<p>$prog results for $query_acc:</p>";
	while (my @row = $sel->fetchrow_arrayref()) {
		print "<p>Accession: $row[0]</p>
			<p>Description: $row[1]</p>
			<p>E-value: $row[2]</p>
			<p>%Identity: $row[3]</p>";
		$count++;
	} unless ($count) {
		return 0;
	}
	$dbh->disconnect;
}

sub database_search {
	# search accessions for existing entry given the query accession
	my $acc = $_[0];
	my $dbh = DBI->connect( "DBI:SQLite:final.db", {RaiseError => 1} ) 
		or die "Cannot connect: $DBI::errstr";
	my $sel = $dbh->prepare("SELECT defline, sequence FROM accessions WHERE accession = ?");
	$sel->execute($acc);
	my @row = $sel->fetchrow_array();
	if (@row) {
		return "$row[0]\n$row[1]";
	} else {
		return 0;
	}
	$dbh->disconnect;
}

sub database_entry {
	# adds accession entry to accessions if it does not exist in table already
	my $acce = $_[0];
	my $def = $_[1];
	my $len = $_[2];
	my $type = $_[3];
	my $seq = $_[4];
	my $dbh = DBI->connect( "DBI:SQLite:final.db", {RaiseError => 1} ) 
		or die "Cannot connect: $DBI::errstr";
	my $sth = qq(CREATE TABLE IF NOT EXISTS accessions 
		(accession VARCHAR(25) PRIMARY KEY UNIQUE NOT NULL, 
		defline VARCHAR(125) NOT NULL, 
		length INT NOT NULL,
		type TEXT NOT NULL,
		sequence TEXT NOT NULL););
	my $rv = $dbh->do($sth);
	my $sql = $dbh->prepare("INSERT OR IGNORE INTO accessions VALUES (?, ?, ?, ?, ?)");
	$sql->bind_param(1, $acce);
	$sql->bind_param(2, $def);
	$sql->bind_param(3, $len);
	$sql->bind_param(4, $type);
	$sql->bind_param(5, $seq);
	$sql->execute(); 
	database_search($acce);
	$dbh->disconnect;
}









