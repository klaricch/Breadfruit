#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script take the output samtools depth files and pulls out the overall mean depth
#on command line: /home/zerega/data/kristen/scripts/depth_parse.pl /home/zerega/data/kristen/depth/

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @depth_files = grep(/depth_metric/,readdir(DIR));
closedir DIR;

open OUT, "> mean_depth_summary.csv";

my $depth_file;
my $sample;
my $line;
my @results;
my @line;
my $overall_mean_line;
my $overall_mean;
foreach my $depth_file (@depth_files) {
	$depth_file =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
	$sample = $1;
	open IN, "$depth_file";
	my @line = <IN>; #small files, so read into an array
	$overall_mean_line = $line[2];
	print "$overall_mean_line\n";
	@results = split (/\s+/, $overall_mean_line);
	$overall_mean = $results[4];
	print OUT "$sample,$overall_mean\n";

	close IN;
}
exit;