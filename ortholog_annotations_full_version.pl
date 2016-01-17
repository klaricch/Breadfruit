#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

## this script takes a trinotate annotation report xls file and a directory as and outputs the count of how many ortholog groups contain
## a transcript from the reference assmebly that has recieved a GO term (tell if the ortholog group is annotated)
## on command line: script.pl <annotation report> <path_to_ortholog_groups>

my $annotation_report = $ARGV[0];
my $line;
my @columnst;
my $prot_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;




my %hash;
my $key;



open IN_TRI, "< $annotation_report";

while (<IN_TRI>){
	$line=$_;
	chomp $line;
	@columnst = split (/\t/, $line);
	$prot_ID = $columnst[4];
	$gene_ontology = $columnst[11];

	
	if ($prot_ID =~ /prot/) { #don't include header
		next;
	}
	if ($gene_ontology =~ /^\./) { #don't include transcripts without GO annotations
		next;
	}
	$hash{$prot_ID} ="$gene_ontology"; #key for each cds.comp|m
	

	

}
close IN_TRI;



###########################################################
###########################################################

my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line2;
my $key2;
my %hash2;
my $count=0;
my $ref_id;
my %final_hash;
my $annotation;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;

	open IN2, "< $pep_file";
	while (<IN2>){
		$line2=$_;
		chomp $line2;
		if ($line2 =~ /^$name\_(c.*)/){
			$ref_id = $1;
			#print "$line2\n";
			
		if (exists $hash{$ref_id}){
			$count++; #if the modified id is present, increase the count
		$annotation = "$ref_id\t$hash{$ref_id}\t";
		$final_hash{$name} = $annotation;
	} else {$final_hash{$name} = "$ref_id\t\.\t";} #if the term wasn's annotated, mark it with a period
	}
}
close IN2;


}
foreach my $item(keys %final_hash){
	print "$item\t$final_hash{$item}\n\n";
}

print "COUNT: $count\n\n";
		



exit;
	