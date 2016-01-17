#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $file = $ARGV[0];
open ASSEMBLYLIST, "< $file" or die "can't open $!";
my $sample_name;
my $assembly_name;
while (<ASSEMBLYLIST>){
	$assembly_name = $_;
	chomp $assembly_name;
	if ($assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/){($sample_name)= $assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/};
	print "$sample_name\n";
	open INC, "<fve_carotenoid_blast_$sample_name.txt" or die "can't open $!"; #blast results table
	my $outputfileC = "SORTED_fve_carotenoid_blast_$sample_name.txt";
	open OUTC, "> $outputfileC";
	my $lineC;
	my @resultsC;
	my $evalueC;
	my %hashC;
	while (<INC>){
	$lineC=$_;
	chomp $lineC;
	@resultsC = (split /\t/, $lineC);
	$evalueC = $resultsC[10]; #this column is the evalue
	$hashC{$evalueC} = $lineC;
	}
	foreach (sort { $a <=> $b } keys(%hashC) ) #sort the blast file based on evalue
	{
		print  OUTC "$hashC{$_}\n"; #printed the sorted results
		}
		close INC;
	}
	close ASSEMBLYLIST;
	close INC;
	close OUTC;
	exit;