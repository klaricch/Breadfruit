#!/usr/bin/perl -wuse 5.010;
use strict;
use warnings;
#this script takes a file of tab delimited paired end reads and outputs fastQC file reports for each one to a folder named "fastqc_reports"
my $file = $ARGV[0];
open IN, " < $file";
my $line;
my @results;
my $fileR1;
my $fileR2;
	
while (<IN>) {
	$line = $_;
	chomp $line;
	@results = split (/\t/, $line);
	$fileR1 = $results[0];
	$fileR2 = $results[1];
		system "fastqc $fileR1 --outdir fastqc_reports";
system "fastqc $fileR2 --outdir fastqc_reports";
}
close IN;
exit;
