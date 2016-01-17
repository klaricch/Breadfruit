#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $file = $ARGV[0];
open IN, "< $file";



my $universal_adapter = "AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT"; #58 bases prefix PE1, PE1, Universal adapter


my $PE_2= "GTGACTGGAGTTCAGACGTGTGCTCTTCCGATC"; #33 bases prefix PE2, PE2
my $PE_1_rc = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA"; #34 bases PE1_rc
my $PE_2_rc = "GATCGGAAGAGCACACGTCTGAACTCCAGTCAC"; #33 bases PE2_rc

my @array_UA = -52..-6;
my @array_PE1rc = -34..-6;
my @array_PE2_PE2rc = -33..-6;

my $adapter_check;
my $adapter_count;
my $line;

while (<IN>){
	$line= $_;
	chomp $line;
	my $outputfile = "adapter_grep_results_$line.csv";
	open FILE, "> $outputfile";
	print FILE "Adapter, Adapter Length, Adapters Found\n";

foreach (@array_UA){
$adapter_check= substr ($universal_adapter, $_);
print "$adapter_check\n";
$adapter_count =  `grep -c $adapter_check $line`;
print FILE "UA,$_,$adapter_count";
}


foreach (@array_PE1rc){
$adapter_check= substr ($PE_1_rc, $_);
print "$adapter_check\n";
$adapter_count =  `grep -c $adapter_check $line`;
print FILE "PE1rc,$_,$adapter_count";
}


foreach (@array_PE2_PE2rc){
$adapter_check= substr ($PE_2, $_);
print "$adapter_check\n";
$adapter_count =  `grep -c $adapter_check $line`;
print FILE "PE2,$_,$adapter_count";
}

foreach (@array_PE2_PE2rc){
$adapter_check= substr ($PE_2_rc, $_);
print "$adapter_check\n";
$adapter_count =  `grep -c $adapter_check $line`;
print FILE "PE2rc,$_,$adapter_count";
}
}

close IN;
exit;
