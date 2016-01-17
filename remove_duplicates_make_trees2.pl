#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#            (2) aligns the sequences with mafft and creates phylo.g trees in FastTree
#on command line: 

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
	
	
	system "mafft $tree >mafftoutput_$tree";    
	system "FastTree mafftoutput_$tree > Tree_$tree.tree";
}

	
	
close FINAL;
exit;