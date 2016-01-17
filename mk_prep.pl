#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#this script prepares a file with the ortholog id, blast hit name, and balst description
#on command line: script.pl <ortholog_annoation_key> <path to phy alignment files>

my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

my %ortholog_hash;
my $ortholog;
foreach my $pep(@pep_files){
	$pep =~ /(\d+)\.phy/;
	$ortholog = $1;
	$ortholog_hash{$ortholog}=0;
}
	
open OUT, ">MK.txt";

my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $GO;
my $blast;
my $id;
my %blast_hash;
my %GO_hash;
my @blast_cat;
my $b1;
my $b2;
my $gene_id;
my $description;
while (<IN>){
	$line =$_;
	chomp $line; 
	@results = split(/\t/,$line);
	$id = $results[0];
	$GO = $results[2];
	$blast = $results[3];
	@blast_cat = split(/\^/, $blast);
	$b1 = $blast_cat[0];
	$b1 =~ /sp\|.*\|(.*)/;
	$gene_id = $1;
	$b2 = $blast_cat[5];
	$b2=~ /.*Full\=(.*);/;
	$description = $1;
	if (exists $ortholog_hash{$id}){
	print OUT "$id\t$gene_id\t$description\n";
}

}

close IN;
close OUT;
exit;