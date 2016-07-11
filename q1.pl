#!/usr/bin/perl
use strict;
use warnings;

use DBI;

use ParseFile("parse_file"); 

my @data = parse_file("data.fasta");
my @genes = @{$data[0]};
my @organisms = @{$data[1]};
my @tissues = @{$data[2]};
my @starts = @{$data[3]};
my @stops = @{$data[4]};
my @levels = @{$data[5]}; 
my @dnaseq = @{$data[6]};

my $dbh = DBI->connect( "dbi:SQLite:data.dbl" ) || die "Cannot connect: $DBI::errstr";
$dbh->do("PRAGMA foreign_keys = ON"); 
$dbh->do("CREATE TABLE genes (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	gene VARCHAR(255) NOT NULL, 
	organism VARCHAR(255) NOT NULL, 
	start INTEGER, 
	stop INTEGER, 
	sequence TEXT)");
my $sth = $dbh->prepare("INSERT INTO genes (gene, organism, start, stop, sequence)
	VALUES (?, ?, ?, ?, ?)");
foreach my $i (0 .. (scalar(@genes)-1)) {
	$sth->execute($genes[$i], $organisms[$i], $starts[$i], $stops[$i], $dnaseq[$i]);
}
$dbh->do("CREATE TABLE expression (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	tissue VARCHAR(255), 
	expressionlevel INTEGER,
	geneid INTEGER,
	FOREIGN KEY (geneid) REFERENCES genes(id))");
$sth = $dbh->prepare("INSERT INTO expression (tissue, expressionlevel) 
	VALUES (?, ?)");
foreach my $i (0 .. (scalar(@genes)-1)) {
	$sth->execute($tissues[$i], $levels[$i]);
}

my $res = $dbh->selectall_arrayref( q (SELECT gene, organism, 
	expression.tissue, expression.expressionlevel
	FROM genes
	JOIN expression ON genes.id = expression.geneid ));

foreach (@{$res}) {
	foreach my $i (0 .. $#$_) {
		print "$_->[$i]";
	}
	print "\n";
}
$dbh->disconnect;