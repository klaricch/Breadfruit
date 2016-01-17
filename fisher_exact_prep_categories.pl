#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

open OUT, ">fishers.csv";
my $file = $ARGV[0];
my $ploidy;
my $species;
my $region;
open IN, "<$file";
my $line;
my @results;
my $sample;
while (<IN>){
	$line = $_;
	chomp $line;
	if (1..1){
		print OUT "cat,cat,cat,cat,$line\n";
		}else{
	@results = split(/,/,$line);
	$sample = $results[0];
	print "$sample\n";
	$sample =~ /_(\D)(\d)(\D)/;
	$species = $1;
	$ploidy = $2;
	$region = $3;
	print OUT "$sample,";
	$line =~ s/blank//g;
	if ($species =~ /A/){print OUT "altilis,"};
	if ($species =~ /C/){print OUT "camansi,"};
	if ($species =~ /H/){print OUT "hybrid,"};
	if ($species =~ /M/){print OUT "mariannensis,"};
	if ($ploidy =~ /2/){print OUT "diploid,"};
	if ($ploidy =~ /3/){print OUT "triploid,"};
	if ($region =~ /M/){print OUT "melanesia,"};
	if ($region =~ /m/){print OUT "micronesia,"};
	if ($region =~ /W/){print OUT "westpolynesia,"};
	if ($region =~ /E/){print OUT "eastpolynesia,"};
	print OUT "$line\n", #can delete the unnecessary extra sample column in the excel file later
}
}
close IN;
exit;