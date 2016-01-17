#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

## this script takes a trinotate annotation report xls file as input and outputs the transcripts and GOs in WEGO native format
## WEGO will appropriately group a transcript that has two separate annotations
## on command line: script.pl <annotation report>

my $annotation_report = $ARGV[0];
my $line;
my @columns;
my $transcript_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;


my $sample;
$annotation_report =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
$sample = $1;

my %seen;
my $count = 0;

open IN, "< $annotation_report";
if ($sample =~ /l/){
open OUT, "+>> Wego_report\_leaf.txt";
} else {
open OUT, "+>> Wego_report\_fruit.txt";
}
while (<IN>){
	$line=$_;
	chomp $line;
	@columns = split (/\t/, $line);
	$transcript_ID = $columns[1];
	$gene_ontology = $columns[11];
	
	if ($seen{$transcript_ID}++) {
		$count++;
		print "$transcript_ID\n";
		
		};
	
	if ($transcript_ID =~ /transcript/) { #don't include header
		next;
	}
	if ($gene_ontology =~ /^\./) { #don't include transcripts without GO annotations
		next;
	}
	
	print OUT "$sample\_$transcript_ID\t";
	
	@full_GO = split ("`", $gene_ontology);
	foreach $GO_term(@full_GO){
			$GO_term =~ /(GO\:\d+)/;
			$GO = $1;
			print OUT "$GO\t";
		}
	
	print OUT "\n";
}
print $count;

close IN;
close OUT;
exit;
	