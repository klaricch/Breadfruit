#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script takes calculates the orhtolog hit ratio useign the Morus notabilis proteome
#on command line: script.pl <list_of_samples>



#prep n50 csv report file for all samples:
my $column_names= "Sample,Contigs with best hit in protein database,Unique peptides found,Average Ortholog hit ratio, Peptides with best hit in assembly,Unique contigs with hits,Reciprocal best hits,Average collapse factor";
open CSV, "+>> ortholog_hit_ratio_mulberry.csv";
print CSV "$column_names\n";

my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $fileR1;
my $fileR2;
my @org_files;
my $item;
my $line2;
my $line3;
my $line4;
my $line_STATS;
my $line9_STATS;
my @results_STATS;

while (<IN>) {
	$line = $_;
	chomp $line;
	@results = split (/\t/, $line);
	$fileR1 = $results[0];
	$fileR2 = $results[1];
	@org_files=("$fileR1","$fileR2");
	print CSV "$fileR1,";


########################################################################################################
########################################################################################################
#
#                         	ORTHOLOG HIT RATIO STATS
#
########################################################################################################
########################################################################################################
system "/home/zerega/data/kristen/scripts/usearch_annotation_stats.sh LI_$fileR1 /home/zerega/data/kristen/ortholog_hit_ratio_files/mulberry_predicted_protein.fasta > O_intermediate_file_mulberry.txt";

open O_IN, "< O_intermediate_file_mulberry.txt";
my ($O_line1, $O_line2_A, $O_line3_A, $O_line4_A, $O_line5_A, $O_line2_R, $O_line3_R, $O_line4_R, $O_line5_R, $O_line6_R); 
my @O_numbers;
my $O_number;

while (<O_IN>){
	$O_line1 = $_;
	if ($O_line1 =~ /Annotation/){ #Annotation Statistics
		$O_line2_A = scalar <O_IN>, $O_line3_A =scalar <O_IN>; $O_line4_A = scalar <O_IN>, $O_line5_A = scalar <O_IN>;
		push (@O_numbers, $O_line3_A, $O_line4_A, $O_line5_A);
	} 
	
	if ($O_line1 =~ /Reverse/){ #Reverse Search Statistics
		$O_line2_R = scalar <O_IN>, $O_line3_R =scalar <O_IN>; $O_line4_R = scalar <O_IN>, $O_line5_R = scalar <O_IN>, $O_line6_R = scalar <O_IN>;
		push (@O_numbers, $O_line3_R, $O_line4_R, $O_line5_R, $O_line6_R);
	}
}


foreach $O_number(@O_numbers){ #only need the numbers from the results
	$O_number =~ /(\d+\.*\d+)/; #match digit one or more times, . zero or more times, digit one or more times >>>>> so that includes whole numbers and decimals
	print CSV "$1,"
}
print CSV "\n";
}


close O_IN;

close O_IN;
close CSV;
close IN;
exit;
	