#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
open IN, "< $file";

my $outputfile = "save.txt";
open OUT, "> $outputfile";

my $line;

while (<IN>) {
	$line=$_;
	chomp $line;
	unless ($line=~ /SnpCluster/|/my\ssnp\sfilter/){
		print OUT "$line\n";
	}
}

close IN;
close OUT;
exit;
	