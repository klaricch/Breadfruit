#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

## this script extracts the longest isofroms from an assembly
## on command line type LongestContig1.pl <Trinity.fasta file>

my $file=$ARGV[0];
my $line;
my @results;
my $full_contig_info;
my %hash;
my %sumhash;

open IN, "< $file" or die $!;
my $outputfile = "List_of_Longest_Contigs.txt";
open (FILE, "> $outputfile");
my $key;
my $value;
my $new_key;
my @other_results;
my $contig;

while (<IN>){
	$line = $_;
	chomp $line;
	if ($line =~/^>/){ 
		@results = split (/ |(?=s)|=/, $line);
		
		$full_contig_info = $results[0];
		my $seq_no = $results[1];
		my $length = $results[3];
		$key = $full_contig_info;
		$value = $length;
		$new_key="$full_contig_info$seq_no";
		
		if (exists $hash{$key}) {
			if ($value >= $hash{$key}) { 
				$sumhash{$key} = "$value\t$new_key";
				$hash{$key} = $value;
				}
				
			} else {
				$hash{$key} = $value;
				$sumhash{$key} = "$value\t$new_key"};
	} 
	

}

foreach (keys %sumhash) 
{
    print FILE "$_\t$sumhash{$_}\n";
};


my $line2;
my @results2;
my $longest_contig;
my %longest_contig_hash;
 open FILE, "< $outputfile" or die $!;
while (<FILE>){
	$line2 = $_;
	chomp $line2;
	@results2 = split (/\t/, $line2);
	$longest_contig = $results2[2];
	$longest_contig_hash{$longest_contig}=0;
}
	
my $outputfile2 = "New_Contigs_$file";
open (FILE2, "> $outputfile2");

close IN;	
open IN, "< $file" or die $!;


my $line3;
while (<IN>) { 
	$line3 = $_;
	chomp $line3;
	if ($line3 =~/^>/ ) { @other_results = split (/ /, $line3);
		$contig=$other_results[0]};
		if (exists $longest_contig_hash{$contig}){
	print FILE2 "$line3\n"}
}
	
close FILE;
close IN;
close FILE2;
exit;
