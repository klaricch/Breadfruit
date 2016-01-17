#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script renames the sample file names to add in the the 4 letter description code
#on command line: script.pl
my $key;
my %hash =(
"EW1_AGTTCC_L003_R1_001\.fastq" => 'EW1_A2Mf_AGTTCC_L003_R1_001.fastq',
"EW1_AGTTCC_L003_R2_001\.fastq" => 'EW1_A2Mf_AGTTCC_L003_R2_001.fastq',
"EW2_GCCAAT_L003_R1_001\.fastq" => 'EW2_C2Mf_GCCAAT_L003_R1_001.fastq',
"EW2_GCCAAT_L003_R2_001\.fastq" => 'EW2_C2Mf_GCCAAT_L003_R2_001.fastq',
"EW3_CGATGT_L003_R1_001\.fastq" => 'EW3_A3Ef_CGATGT_L003_R1_001.fastq',
"EW3_CGATGT_L003_R2_001\.fastq" => 'EW3_A3Ef_CGATGT_L003_R2_001.fastq',
"EW4_TAGCTT_L003_R1_001\.fastq" => 'EW4_C2Mv_TAGCTT_L003_R1_001.fastq',
"EW4_TAGCTT_L003_R2_001\.fastq" => 'EW4_C2Mv_TAGCTT_L003_R2_001.fastq',
"RNA5_CGATGT_L001_R1_001\.fastq" => 'RNA5_C2Ef_CGATGT_L001_R1_001.fastq',
"RNA5_CGATGT_L001_R2_001\.fastq" => 'RNA5_C2Ef_CGATGT_L001_R2_001.fastq',
"RNA7_TTAGGC_L001_R1_001\.fastq" => 'RNA7_M2mf_TTAGGC_L001_R1_001.fastq',
"RNA7_TTAGGC_L001_R2_001\.fastq" => 'RNA7_M2mf_TTAGGC_L001_R2_001.fastq',
"RNA2_ATCACG_L001_R1_001\.fastq" => 'RNA2_C2mf_ATCACG_L001_R1_001.fastq',
"RNA2_ATCACG_L001_R2_001\.fastq" => 'RNA2_C2mf_ATCACG_L001_R2_001.fastq',
"RNA10_CAGATC_L003_R1_001\.fastq" => 'RNA10_H3El_CAGATC_L003_R1_001.fastq',
"RNA10_CAGATC_L003_R2_001\.fastq" => 'RNA10_H3El_CAGATC_L003_R2_001.fastq',
"RNA16_TGACCA_L001_R1_001\.fastq" => 'RNA16_H3ml_TGACCA_L001_R1_001.fastq',
"RNA16_TGACCA_L001_R2_001\.fastq" => 'RNA16_H3ml_TGACCA_L001_R2_001.fastq',
"RNA17_ACAGTG_L001_R1_001\.fastq" => 'RNA17_A3El_ACAGTG_L001_R1_001.fastq',
"RNA17_ACAGTG_L001_R2_001\.fastq" => 'RNA17_A3El_ACAGTG_L001_R2_001.fastq',
"RNA21_GCCAAT_L001_R1_001\.fastq" => 'RNA21_A2Mf_GCCAAT_L001_R1_001.fastq',
"RNA21_GCCAAT_L001_R2_001\.fastq" => 'RNA21_A2Mf_GCCAAT_L001_R2_001.fastq',
"RNA24_CAGATC_L001_R1_001\.fastq" => 'RNA24_A2Ml_CAGATC_L001_R1_001.fastq',
"RNA24_CAGATC_L001_R2_001\.fastq" => 'RNA24_A2Ml_CAGATC_L001_R2_001.fastq',
"RNA25_ACTTGA_L003_R1_001\.fastq" => 'RNA25_A3ml_ACTTGA_L003_R1_001.fastq',
"RNA25_ACTTGA_L003_R2_001\.fastq" => 'RNA25_A3ml_ACTTGA_L003_R2_001.fastq',
"RNA26_GATCAG_L003_R1_001\.fastq" => 'RNA26_A3ml_GATCAG_L003_R1_001.fastq',
"RNA26_GATCAG_L003_R2_001\.fastq" => 'RNA26_A3ml_GATCAG_L003_R2_001.fastq',
"RNA32_ACTTGA_L001_R1_001\.fastq" => 'RNA32_H2Wf_ACTTGA_L001_R1_001.fastq',
"RNA32_ACTTGA_L001_R2_001\.fastq" => 'RNA32_H2Wf_ACTTGA_L001_R2_001.fastq',
"RNA34_GATCAG_L002_R1_001\.fastq" => 'RNA34_A3Wf_GATCAG_L002_R1_001.fastq',
"RNA34_GATCAG_L002_R2_001\.fastq" => 'RNA34_A3Wf_GATCAG_L002_R2_001.fastq',
"RNA35_TAGCTT_L002_R1_001\.fastq" => 'RNA35_C2Mf_TAGCTT_L002_R1_001.fastq',
"RNA35_TAGCTT_L002_R2_001\.fastq" => 'RNA35_C2Mf_TAGCTT_L002_R2_001.fastq',
"RNA36_GGCTAC_L002_R1_001\.fastq" => 'RNA36_H2Wf_GGCTAC_L002_R1_001.fastq',
"RNA36_GGCTAC_L002_R2_001\.fastq" => 'RNA36_H2Wf_GGCTAC_L002_R2_001.fastq',
"RNA37_CTTGTA_L002_R1_001\.fastq" => 'RNA37_C2mf_CTTGTA_L002_R1_001.fastq',
"RNA37_CTTGTA_L002_R2_001\.fastq" => 'RNA37_C2mf_CTTGTA_L002_R2_001.fastq',
"RNA38_ATCACG_L002_R1_001\.fastq" => 'RNA38_A3Wl_ATCACG_L002_R1_001.fastq',
"RNA38_ATCACG_L002_R2_001\.fastq" => 'RNA38_A3Wl_ATCACG_L002_R2_001.fastq',
"RNA39_CGATGT_L002_R1_001\.fastq" => 'RNA39_A3El_CGATGT_L002_R1_001.fastq',
"RNA39_CGATGT_L002_R2_001\.fastq" => 'RNA39_A3El_CGATGT_L002_R2_001.fastq',
"RNA40_TTAGGC_L002_R1_001\.fastq" => 'RNA40_H3ml_TTAGGC_L002_R1_001.fastq',
"RNA40_TTAGGC_L002_R2_001\.fastq" => 'RNA40_H3ml_TTAGGC_L002_R2_001.fastq',
"RNA48_TGACCA_L002_R1_001\.fastq" => 'RNA48_H2ml_TGACCA_L002_R1_001.fastq',
"RNA48_TGACCA_L002_R2_001\.fastq" => 'RNA48_H2ml_TGACCA_L002_R2_001.fastq',
"RNA49_TAGCTT_L003_R1_001\.fastq" => 'RNA49_H3El_TAGCTT_L003_R1_001.fastq',
"RNA49_TAGCTT_L003_R2_001\.fastq" => 'RNA49_H3El_TAGCTT_L003_R2_001.fastq',
"RNA4_GCCAAT_L003_R1_001\.fastq" => 'RNA4_A3Ef_GCCAAT_L003_R1_001.fastq',
"RNA4_GCCAAT_L003_R2_001\.fastq" => 'RNA4_A3Ef_GCCAAT_L003_R2_001.fastq',
);

foreach $key (keys %hash){
	system "mv A_WT_R1_out.paired_$key A_WT_R1_out.paired_$hash{$key}";
	system "mv A_WT_R2_out.paired_$key A_WT_R2_out.paired_$hash{$key}";
	system "mv A_WT_R1_out.unpaired_$key A_WT_R1_out.unpaired_$hash{$key}";
	system "mv A_WT_R2_out.unpaired_$key A_WT_R2_out.unpaired_$hash{$key}";
	}
	exit;
	
	