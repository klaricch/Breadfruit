#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script take the 25 samples, puts them in list.txt files according to species, regions, ploidy, etc, runs GATK's selectvariant, only induding
#those that still show variation after subsetting, and outputs how many SNPS survive to a summary csv file
#on command line: script.pl
#HASH
my %lane_hash =(
RNA16_H3ml => 'lane1',
RNA17_A3El => 'lane1',
RNA21_A2Mf => 'lane1',
RNA24_A2Ml => 'lane1',
RNA2_C2mf => 'lane1',
RNA32_H2Wf => 'lane1',
RNA5_C2Ef => 'lane1',
RNA7_M2mf => 'lane1',
RNA34_A3Wf => 'lane2',
RNA35_C2Mf => 'lane2',
RNA36_H2Wf => 'lane2',
RNA37_C2mf => 'lane2',
RNA38_A3Wl => 'lane2',
RNA39_A3El => 'lane2',
RNA40_H3ml => 'lane2',
RNA48_H2ml => 'lane2',
RNA10_H3El => 'lane3',
RNA25_A3ml => 'lane3',
RNA26_A3ml => 'lane3',
RNA49_H3El => 'lane3',
RNA4_A3Ef => 'lane3',
EW1_A2Mf => 'lane4', ####CHECK WHAT TO DO FOR THESE SAMPLES!
EW2_C2Mf => 'lane4',
EW3_A3Ef => 'lane4',
EW4_C2Mv => 'lane4',
);

my %file_hash = (
"wild_diploid.txt" => '0',
"cultivated_diploid.txt" => '0',
"cultivated_triploid.txt" => '0',
"camansi_diploid.txt" => '0',
"altilis_diploid.txt" => '0',
"altilis_triploid.txt" => '0',
"hybrid_diploid.txt" => '0',
"hybrid_triploid.txt" => '0',
"melanesia_diploid.txt" => '0',
"micronesia_diploid.txt" => '0',
"micronesia_triploid.txt" => '0',
"wploynesia_diploid.txt" => '0',
"wpolynesia_triploid.txt" => '0',
"epolynesia_diploid.txt" => '0',
"epolynesia_triploid.txt" => '0',
);

my $value;
my $species;
my $ploidy;
my $region;

#DOMESTCATION
open OUTW1, ">wild_diploid.txt"; #is only diploid
open OUTW2, ">cultivated_diploid.txt";
open OUTW3, ">cultivated_triploid.txt";
#SPECIES

open OUTS1, ">camansi_diploid.txt"; #is only diploid
open OUTS2, ">altilis_diploid.txt";
open OUTS3, ">altilis_triploid.txt";
open OUTS4, ">hybrid_diploid.txt";
open OUTS5, ">hybrid_triploid.txt";
#REGION
open OUTR1, ">melanesia_diploid.txt"; #is only diploid
open OUTR2, ">micronesia_diploid.txt";
open OUTR3, ">micronesia_triploid.txt";
open OUTR4, ">wploynesia_diploid.txt";
open OUTR5, ">wpolynesia_triploid.txt";
open OUTR6, ">epolynesia_diploid.txt";
open OUTR7, ">epolynesia_triploid.txt";

#make hash of OUT FILES to reun selct variants on

foreach my $key(keys %lane_hash){
	$key =~ /_(\D)(\d)(\D)(\D)/;
	$species = $1;
	$ploidy = $2;
	$region = $3;
	
#DOMESTICATION
	if ($species =~ /C|M/) {print OUTW1 "$key\n"};
if ($species =~ /A|H/ && $ploidy =~ /2/) {print OUTW2 "$key\n"};
if ($species =~ /A|H/ && $ploidy =~ /3/) {print OUTW3 "$key\n"};
#SPECIES
if ($species =~ /C/) {print OUTS1 "$key\n"};
if ($species =~ /A/ && $ploidy =~ /2/) {print OUTS2 "$key\n"};
if ($species =~ /A/ && $ploidy =~ /3/) {print OUTS3 "$key\n"};
if ($species =~ /H/ && $ploidy =~ /2/) {print OUTS4 "$key\n"};
if ($species =~ /H/ && $ploidy =~ /3/) {print OUTS5 "$key\n"};
#REGION
if ($region =~ /M/) {print OUTR1 "$key\n"};
if ($region =~ /m/ && $ploidy =~ /2/) {print OUTR2 "$key\n"};
if ($region =~ /m/ && $ploidy =~ /3/) {print OUTR3 "$key\n"};
if ($region =~ /W/ && $ploidy =~ /2/) {print OUTR4 "$key\n"};
if ($region =~ /W/ && $ploidy =~ /3/) {print OUTR5 "$key\n"};
if ($region =~ /E/ && $ploidy =~ /2/) {print OUTR6 "$key\n"};
if ($region =~ /E/ && $ploidy =~ /3/) {print OUTR7 "$key\n"};
}
	
close OUTW1; close OUTW2; close OUTW3; close OUTS1; close OUTS2; close OUTS3; close OUTS4; close OUTS5; close OUTR1; close OUTR2; close OUTR3; close OUTR4; close OUTR5; close OUTR6; close OUTR7;

open SUMMARY, "> snp_summary.csv";
my $file_name;
my $file_ploidy;
my $snps;foreach my $file(keys %file_hash){
	$file =~/(\D+)_(\D+)\.txt/;
	$file_name = $1;
	$file_ploidy = $2;
	

	system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R LI_altilis_simple_header.fasta -V PASSED_SNPs_$file_ploidy\_4.recode.vcf --sample_file $file --excludeNonVariants -o $file_name\_$file_ploidy.vcf";
	$snps = `grep -c "PASS" $file_name\_$file_ploidy.vcf`;
	print SUMMARY "$file,$snps";
	
}

	
	
close SUMMARY;	exit;