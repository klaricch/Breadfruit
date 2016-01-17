#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
system "/home/zerega/data/kristen/scripts/usearch_annotation_stats.sh LI_RNA10_CAGATC_L003_R1_001.fastq /home/zerega/data/kristen/ortholog_hit_ratio_files/csa.trans.estscan.pep.10072011.fasta > O_intermediate_file.txt";
open O_IN, "< O_intermediate_file.txt";
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
	print "$1\n"
}
print @O_numbers;
close O_IN;
exit;