#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script takes aa contig ids and pull out the matching nucleotide seq from the original assembly
#on command line FilterCOntigs.pl <file of aa Blast results> <nucleotide assembly>
my @list;
my $fvegeneID;
my $contigID;
my @results;
my $line;
my $line2;
my $line3;

my $file=$ARGV[0];
open IN, "< $file";
$/ =">";while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		chomp $line; #chomping off ">"
		print "$line\n";
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		#$file_name =~ s/\s|,|;|\//_/g; #replace spaces, commas, semicolons, and forward slashes with underscores for the file names
		#$file_name =~ s/__/_/g; #replace two underscores with one to clean up previous step
		my $outputfile = "fve_$file_name.txt";
		open (FILE," > $outputfile");
		print FILE "$line\n";
		#print FILE scalar <IN>;
		#if (/$line2/../\>/) {print FILE $_};
		#print scalar <IN> if ( $_ != /^>/);
		#$line2 = scalar <IN>;
		#print $line2;
		#if ($line2 !~ /^>/){
		#print FILE $line2;
		#$line2 = scalar <IN>;
		#redo;
	
}
	
}
#	@results = split (/\t/,$_);
#	$fvegeneID = $results[0]; 
#	$contigID = $results[1];                      
#	push (@list, $contigID);	                       
#}
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
close FILE;
exit;