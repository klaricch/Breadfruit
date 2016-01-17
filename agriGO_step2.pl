#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#make hash of trinotate report annotation, read .phy files in a directory and output their annotations to a csv file with GO and top blastx hit
#the .phy files should be the ones with the reference transcripts included
#script.pl <trinotate_report> <path_to_phy_alignment_files>

my $annotation_report = $ARGV[0];
my $line;
my @columnst;
my $prot_ID;
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
my $top_blastx_hit;


my %hash;
my $key;



open IN_TRI, "< $annotation_report";

while (<IN_TRI>){
	$line=$_;
	chomp $line;
	@columnst = split (/\t/, $line);
	$top_blastx_hit = $columnst[2];
	$prot_ID = $columnst[4];
	$gene_ontology = $columnst[11];

	
	if ($prot_ID =~ /prot/) { #don't include header
		next;
	}
	if ($gene_ontology =~ /^\./) { #don't include transcripts without GO annotations
		next;
	}
	$hash{$prot_ID} ="$gene_ontology\t$top_blastx_hit"; #key for each cds.comp|m
	

	

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

open OUT, "> ortholog_annotation_key.txt";

##########


foreach $pep_file(@pep_files){
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;

	open IN2, "< $pep_file";
	while (<IN2>){
		$line2=$_;
		chomp $line2;
		if ($line2 =~ /^$name\_(c.*)/){
			$ref_id = $1;
			#print "$line2\n";
			
		if (exists $hash{$ref_id}){ #if the modified id is present, increase the count
		$annotation = "$ref_id\t$hash{$ref_id}";
		$final_hash{$name} = $annotation;
	} 
}
}
close IN2;



foreach my $item(keys %final_hash){
	print OUT "$item\t$final_hash{$item}\n";
}
%final_hash=();
}