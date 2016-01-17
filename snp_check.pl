#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#this script take a vcf file and checks it for certain patterns
#on comman line: script.pl <vcf file>
my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $sample1;
my $sample2;
my $count =0;
while (<IN>) {
	$line = $_;
	chomp $line;
	if ($line =~/PASS/){
	@results = split(/\t/, $line);
	$sample1=$results[9];
	$sample2=$results[10];
	 if ($sample1 =~/0\/0\/0/ && $sample2 =~/\.\/\.\/\./){
	 	print "$sample1\t$sample2\n";
	 	next;
	 }
	#if ($sample1 =~/\.\/\.\/\./){
	#	print "$sample1\n";
	#	next;
	#	}
	#if ($sample2 =~/\.\/\.\/\./){
	#	next;
	#}
	$count++;
}
}
close IN;
print "$count\n";
exit;
	
	