#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script takes aa contig ids and pull out the matching nucleotide seq from the original assembly
#on command line script.pl <amino acid sequences of phytozome genes> <file of aa Blast results> <nucleotide assembly---protein assembly>
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
my $contig;
my $outputfile1;

my $file=$ARGV[0];  #amino acid sequences files of targeted genes---one file with all fve aa seqs
open IN, "< $file";
$/ =">"; while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		chomp $line; #chomping off ">"
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		my $name = "fve:$file_name";
		$hash{$name} = 0;
		my $outputfile = "tree_seq_fve_$file_name.txt";
		open (FILE," > $outputfile");
		$/ = "\n";
		chomp $line;
		print FILE ">$line";
		open(PHYTOZOME, "< phytozome_fve_$file_name.txt"); #add in phytozome results
		while (<PHYTOZOME>){
			print FILE $_;
		}
	}
}
$/ = "\n"; #make sure delimiter is reset

my %hash2;my $file1 = $ARGV[1]; #blast results table
open IN1, "<$file1";
while (<IN1>) {
	$line1 = $_;
	chomp $line1;
	@results = split (/\t/,$line1);
	$fvegeneID = $results[0]; 
	$contigID = $results[1];                      
	if (exists $hash{$fvegeneID}){
		$hash2{$contigID} = $fvegeneID;
		 push (@list, $contigID)};	                       
}


my $file2 = $ARGV[2]; # longest isoform contig assembly (amino acid .pep version)
open IN2, " < $file2";
while (<IN2>){
	$line2 = $_;
	chomp $line2;
	if ($line2 =~ /^>/) {
		@results1 = split (/\s/,$line2);
	$contig = $results1[0];
	$contig =~ s/>//;
	if (exists $hash2{$contig}){
		for ($hash2{$contig}){s/:/_/};
		my $outputfile1 = "tree_seq_$hash2{$contig}.txt";
		open (FILE1," +>> $outputfile1");  #"+>>" will create a file if doesn't exist but will not overwrite a file if it already exists
		print FILE1"$line2\n";   #NEED TO ADD NEWLINE INSTEAD OF OVERWRITING
		print FILE1 scalar <IN2>;
	}
}
}
	
	
#my $contiglist=join("|", @list); 

#my $file1=$ARGV[1];
#open IN1, "< $file1";

#while (<IN1>){
#	if ($_ =~/^>/ && $_ =~/$contiglist/) {
#		print FILE $_;
#		do {$line2 = scalar <IN1>;
#		print FILE $line2} until ($line2 =~/^>/);
		
		
#	}
#}

#define a line2close IN;
close IN1;
close IN2;
close FILE;
close FILE1;
exit;