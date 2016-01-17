#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script (1) takes a list of fveID and removes the duplicates from the MERGED files in a new FINAL file
#            (2) aligns the sequences with mafft and creates phylo.g trees in FastTree
#on command line: 
my $list = $ARGV[0];
my $fveID;
my $seq;
my %seen;
my @tree_list;
my $tree;
open IN, "< $list";
while (<IN>){
	$fveID=$_;
	chomp $fveID;
	open (MERGED, "<MERGED_fve_$fveID.fasta");
	open(FINAL, "> FINAL_fve_$fveID.fasta");
	$/ =">"; 
	while (<MERGED>){
		$seq=$_;
		$seq=~s/fve\:/fve_/;
		unless ($seen{$seq}++) {  
			print FINAL "$seq\n";
			}	
		}
		$/ ="\n";
		push (@tree_list, "FINAL_fve_$fveID.fasta");
	}
	
	foreach $tree(@tree_list){
	system "mafft $tree >mafftoutput_$tree";    
	system "FastTree mafftoutput_$tree > Tree_$tree.tree";
}

	
	close MERGED;
close FINAL;
exit;