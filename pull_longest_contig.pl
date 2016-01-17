#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script prints the longest contig nuc seq sequence of an assembly to a new seaparate file
#on command line: script.pl <LI_assembly_name> <length of longest contig>

my $line_LI;
my @results_LI;
my $full_contig_info;
my $length;
my $seq_no;

my $file_LI = $ARGV[0];
my $longest_length = $ARGV[1];

open IN_LI, "< $file_LI" or die $!;
my $outputfile = "Longest_Contigs_$file_LI.txt";
open (FILE, "> $outputfile");

$/ = ">";
while (<IN_LI>){
	$line_LI = $_;
	chomp $line_LI;
		@results_LI = split (/ |(?=s)|=/, $line_LI);
		$full_contig_info = $results_LI[0];
		$seq_no = $results_LI[1];
		$length = $results_LI[3];
		if ($length==$longest_length){
			print FILE "$line_LI\n"
			}
		
	}
close FILE;
close IN_LI;
exit;
