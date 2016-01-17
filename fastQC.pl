#!/usr/bin/perl -w
use strict;
use warnings;


open IN, " < $file";

my @results;
my $fileR1;
my $fileR2;
	
while (<IN>) {
	$line = $_;
	chomp $line;
	@results = split (/\t/, $line);
	$fileR1 = $results[0];
	$fileR2 = $results[1];
		
system "fastqc $fileR2 --outdir fastqc_reports";
}

exit;