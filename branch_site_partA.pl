#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
my $annotation_report = $ARGV[0];
my $line;
my @columnst;
my $prot_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;
my %hash;

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

system "parallel -j2 /home/zerega/data/kristen/scripts/branch_site_partB.pl {1} ::: *estimated*";

exit;