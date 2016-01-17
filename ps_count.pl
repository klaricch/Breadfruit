#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script take a kappa/omega summary file and counts the number of ortholog groups with omega >1 and >=999
#on command line: script.pl <M0_summary.csv>
my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $omega;
my $count = 0;
my $infinity=0;
my $count1_2=0;
my $count1_3=0;
while (<IN>){
	$line = $_;
	chomp $line;
	#print $line;
	@results = split(/,/,$line);
	$omega = $results[2];
	if ($omega > 1){$count++};
	if ($omega >=999){$infinity++};
	if ($omega > 1 && $omega<2) {$count1_2++};
	if ($omega > 1 && $omega<3) {$count1_3++};
}
print "$count\n";
print "$infinity\n";
print "$count1_2\n";
print "$count1_3\n";
close IN;
exit;
	
	