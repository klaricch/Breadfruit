#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#make hash of  report annotation, read .phy files in a directory and output their annotations to a csv file
#script.pl <agriGO_ortholog_annotation_key.txt.txt> <path_to_phy_alingnment_files>

my $annotation_report = $ARGV[0];
my $line;
my @columnst;
my $ortholog_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;
my $cds_file;
my $name;
my $line2;
my $key2;
my %hash2;
my $count=0;
my $ref_id;
my %final_hash;
my $annotation;
my $pep_file;


my %hash;
my $key;



open IN_TRI, "< $annotation_report";

while (<IN_TRI>){
	$line=$_;
	chomp $line;
	$line =~ /(\d+)\t(.*)/;
	$ortholog_ID = $1;
	$gene_ontology = $2;
	$hash{$ortholog_ID} ="$gene_ontology"; #key for each cds.comp|m
	

	

}
close IN_TRI;
##################################################

my @sites;
my @columns;
my $position;
my $amino_acid;
my $Pr;
my $post_mean;
my $SE;
my @classes;
my @classesfb;



my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

open OUT, "> ps_$annotation_report";

##########


foreach $pep_file(@pep_files){
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	if (exists $hash{$name}){  #the hash won't exist if a transcript did not receive a GO annotation
	print OUT "$name\t$hash{$name}\n"
}
}
exit;

	