#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $snp_file = "snps_filtered_triploid_0.vcf";
open SNP_IN, "< $snp_file";

my $snp_outputfile = "PASSED_SNPs_triploid_0.recode.vcf ";
open SNP_OUT, "> $snp_outputfile";

my $snp_line;

while (<SNP_IN>) {
	$snp_line=$_;
	chomp $snp_line;
	unless ($snp_line=~ /(SnpCluster)|(my\ssnp\sfilter)/){
		print SNP_OUT "$snp_line\n";
	}
}



my $indel_file = "indel_filtered_triploid_0.vcf";
open INDEL_IN, "< $indel_file";

my $indel_outputfile = "PASSED_INDEL_triploid_0.recode.vcf ";
open INDEL_OUT, "> $indel_outputfile";

my $indel_line;

while (<INDEL_IN>) {
	$indel_line=$_;
	chomp $indel_line;
	unless ($indel_line=~ /(my_indel_filter)/){
		print INDEL_OUT "$indel_line\n";
	}
}

close SNP_IN;
close SNP_OUT;
close INDEL_IN;
close INDEL_OUT;
exit;
	