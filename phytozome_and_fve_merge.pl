#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script:
#translates the longest isoform nucleotide assemblies into protein assmeblies and creates a blast database of the results
#takes a file of a.a seqeunces (such as fve carotenoid transcripts) and uses them as a query to blast against the assemblies
#combines the a.a. seq file,the results from blasting each a.a seq in pytozome, and the results of blasting against the assembly
#runs mafft and FastTree on the final combined file to later be visualized in FigTree
#on command line script.pl <a.a seqs of genes of interest> <list of nuc assemblies to be used> #requires pre-existing separate files of a.a. seq of phytozome individuals per each gene of interest

my @list;
my $fvegeneID;
my $contigID;
my @results;
my $line;
my $line1;
my $line2;
my $line3;
my %hash;
my @results1;
#my $contig;
my $outputfile1;
my @complete_file_array;
my $complete_file;
my %seen;
my $seq;

##################################################################################################
##################################################################################################
#
#			FILE ORGANIZATION and ADD IN PHYTOZOME RESULTS
#
##################################################################################################
##################################################################################################
my $file;
$file=$ARGV[0];  #amino acid sequences files of targeted genes---ex:one file with all fve aa seqs
open IN, "< $file";
$/ =">"; while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		my $name = "fve:$file_name";
		chomp $line;
		$hash{$name} = 0;
		my $outputfile = "all_seq_fve_$file_name.fasta";
		push (@complete_file_array, "all_seq_fve_$file_name.fasta");
		open (FILE," > $outputfile");
		$/ = "\n";
		chomp $line;
		print FILE ">$line\n";
		
				
		open(PHYTOZOME, "< phytozome_fve_$file_name.txt"); #add in phytozome results
		while (<PHYTOZOME>){
			$/ =">";
			print FILE "$_"; #print to the complete seqs file
		}
	}
}
$/ = "\n"; #make sure delimiter is reset

close IN;

close FILE;
close PHYTOZOME;
exit;