#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script take vcfs and counts the locations where 2 vcfs both have snps
#on command line: script.pl <vcf1> <vcf2>
my $file = $ARGV[0];
my $file2 = $ARGV[1];

open IN, "<$file";
my $line;
my @results;
my $ref_contig;
my $ref_position;
my %hash1;

while (<IN>){
	$line = $_;
	chomp $line;
	#print $line;
	if ($line =~ /^#/) {
		next;
	}
	@results = split(/\t/,$line);
	$ref_contig=$results[0];
	$ref_position=$results[1];
	#print "$ref_contig\n";
	#print "$ref_position\n";
	$hash1{"$ref_contig\_$ref_position"} = 0;
}



open IN2, "<$file2";
my $line2;
my @results2;
my $ref_contig2;
my $ref_position2;
my %hash2;
my $count=0;

open OUT, "> snps_in_common.txt";

while (<IN2>){
	$line2 = $_;
	chomp $line2;
	#print $line2;
	if ($line2 =~ /^#/) {
		next;
	}
	@results2 = split(/\t/,$line2);
	$ref_contig2=$results2[0];
	$ref_position2=$results2[1];
	if (exists $hash1{"$ref_contig2\_$ref_position2"}){
		$count++;
		print OUT "$ref_contig2\t$ref_position2\n";
	}
	

}




print "$count\n";
close IN;
close IN2;
close OUT;
exit;
	