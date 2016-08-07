#!/usr/bin/perl

use Modern::Perl;

use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;
use Bio::Search::Result::ResultI;
use Bio::Search::Hit::HitI;
use Bio::Search::HSP::HSPI;

$|++;

my $factory = Bio::Tools::Run::RemoteBlast->new( -prog       => 'blastp'   ,
                                                 -data       => 'nr'       ,
                                                 -expect     => '1e-10'    ,
                                                 -readmethod => 'SearchIO' );
my $query_str;
if( $ARGV[0] ) { $query_str = $ARGV[0]; }
else {
  print "Please enter the accession of protein to BLAST: ";
  $query_str = <STDIN>;
}

chomp( $query_str );

my $db = 'genpept';
$query_str =~ /(\w+[^.])/;
my $acc = $1;
my $seq = get_sequence($db, $acc);


my $acc2;

$factory->submit_blast( $seq );

first: while ( my @rids = $factory->each_rid ) {
   foreach my $rid ( @rids ) {
    my $result = $factory->retrieve_blast( $rid );
    if( ref( $result )) {
      my $output = $result->next_result();
      $factory->remove_rid( $rid );
      print "\n";

      foreach my $hit ( $output->hits ) {
        if ($hit->accession() ne $acc) {
          $acc2 = $hit->accession();   
          my $hsp =$hit->hsp;       
          print "Hit found: ", $hit->accession(), " with ", $hsp->percent_identity, "% identity\n"; 
          print "Running second BLAST search with ", $hit->accession(), "\n";  
          last first;
          
        }
      }
    }
    elsif( $result < 0 ) {
      print "error encountered\n";
      $factory->remove_rid( $rid );
    }
    else {
      # no results yet
      print "waiting\n";
      sleep 30;
    }
  }
}

if (defined $acc2) {
  my $seq2 = get_sequence($db, $acc2);
  $factory->submit_blast( $seq2 );  
  second: while ( my @rids = $factory->each_rid ) {
    foreach my $rid ( @rids ) {
      my $result = $factory->retrieve_blast( $rid );
      if( ref( $result )) {
        my $output = $result->next_result();
        $factory->remove_rid( $rid );
        print "\n";
        foreach my $hit ( $output->hits ) {
          if ($hit->accession() eq $acc2) {
            next;
            } 
          elsif ($hit->accession() eq $acc) {         
            print "Top hit of second BLAST search: ", $hit->accession(), " is same as initial query.\n";   
            last second;
          }
          else {
            my $hsp = ($hit->hsp);
            print "Top hit of second BLAST search: ", $hit->accession(), " has ", $hsp->percent_identity, "% identity\n";
            print "search completed\n";
            last second;   
          }
        }
      }
      elsif( $result < 0 ) {
        print "error encountered\n";
        $factory->remove_rid( $rid );
      }
      else {
        # no results yet
        print "waiting\n";
        sleep 30;
      }
    }
  }
}