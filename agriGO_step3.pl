#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

## this script takes annotationreport and preps it....print the phy identifiera and GO terms plus a detailed file with the blastx hit name
##script.pl <ortholog.txt> <path to the parred down orthologs>
##the path is prep2/fix

my $annotation_report = $ARGV[0];
my $line;
my @columns;
my $transcript_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;
my $blast;
my %hash;
my $name;
my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;
foreach my $pep_file(@pep_files){
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	$hash{$name} =0;
}
	



my %seen;
my $count = 0;


open IN, "< $annotation_report";
open OUT, "> agriGO_$annotation_report.txt";
open OUT2, "> agriGO_$annotation_report\_full_details.txt";
while (<IN>){
	$line=$_;
	chomp $line;
	@columns = split (/\t/, $line);
	$transcript_ID = $columns[0];
	$gene_ontology = $columns[2];
	$blast = $columns[3];
	
	if ($seen{$transcript_ID}++) {
		$count++;
		print "$transcript_ID\n";
		
		};
	
	if ($transcript_ID =~ /transcript/) { #don't include header--remnant from other script
		next;
	}
	if ($gene_ontology =~ /^\./) { #don't include transcripts without GO annotations
		next;
	}
	if (exists $hash{$transcript_ID}){
	print OUT "$transcript_ID\t";
	print OUT2 "$transcript_ID\t";
	print OUT2 "$blast\t";
	
	@full_GO = split ("`", $gene_ontology);
	foreach $GO_term(@full_GO){
			$GO_term =~ /(GO\:\d+)/;
			$GO = $1;
			print OUT "$GO\t";
			print OUT2 "$GO\t";
		
		}
			
	
	print OUT "\n";
	print OUT2 "\n";
}
}
print $count;

close IN;
close OUT2;
exit;
	