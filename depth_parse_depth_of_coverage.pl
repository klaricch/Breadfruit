#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script take the output gatk depth of coverage file and pulls out the overall mean depth
#on command line: /home/zerega/data/kristen/scripts/depth_parse_depth_of_coverage.pl <depth_of_coverage.sample_summary>

my $depth_file= $ARGV[0];  #name of directory


open OUT, "> mean_depth_of_coverage_summary.csv";
open IN, "< $depth_file";
my $sample;
my $line;
my @results;
my $overall_mean;
while (<IN>){
	$line= $_;
	chomp $line;
	@results = split (/\s+/, $line);
	$sample = $results[0];
	$overall_mean = $results[2];
	print OUT "$sample,$overall_mean\n";
}
close IN;
close OUT;
exit;