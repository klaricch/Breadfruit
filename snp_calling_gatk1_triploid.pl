#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script performs Base Recalibration through Filtering Out High Confidence SNPs
# should be ran after snp_processing.pl script
# on command line: script.pl <fasta reference> <indel realigned merged bam file> <round> 
# round=1 first time running this script, =2 second time, etc.
my $reference = $ARGV[0]; 
my $samples = $ARGV[1]; #the realigned merged bam file
my $round = $ARGV[2]; #first time running this script enter 1
my $previous_round = ($round-1);
print "$previous_round\n";
print $reference;
print $samples;
print $round;

open ERROR, "> error_snp_calling_and_BR_$round\_triploid.txt";

#BASE RECALIBRATION
print "duh";system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T BaseRecalibrator -R $reference -I $samples -knownSites PASSED_SNPs_triploid_$previous_round.recode.vcf -knownSites PASSED_INDEL_triploid_$previous_round.recode.vcf -o recalibrated_samples_triploid_$round.table -nct 8 2>error_snp_calling_and_BR_triploid_$round.txt";
system"java -jar /data/mjohnson/GenomeAnalysisTK.jar -T BaseRecalibrator -R $reference -I $samples -knownSites PASSED_SNPs_triploid_$previous_round.recode.vcf -knownSites PASSED_INDEL_triploid_$previous_round.recode.vcf -BQSR recalibrated_samples_triploid_$round.table -o post_recalibrated_samples_triploid_$round.table -nct 5 2>>error_snp_calling_and_BR_triploid_$round.txt";
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T AnalyzeCovariates -R $reference -before recalibrated_samples_triploid_$round.table -after post_recalibrated_samples_triploid_$round.table -plots recalibration_plots_triploid_$round.pdf 2>>error_snp_calling_and_BR_triploid_$round.txt";
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T PrintReads -R $reference -I $samples -BQSR recalibrated_samples_triploid_$round.table -o RECAL_samples_triploid_$round.bam -nct 8 2>>error_snp_calling_and_BR_triploid_$round.txt";

#N ROUND SNP CALLING#call all variants:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T UnifiedGenotyper -R $reference -I RECAL_samples_triploid_$round.bam -glm BOTH -ploidy 3 -stand_call_conf 20 -stand_emit_conf 20 -o raw_variants_all_triploid_$round.vcf -nct 8 2>>error_snp_calling_and_BR_triploid_$round.txt";
#pull out snps to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_triploid_$round.vcf -selectType SNP -o raw_variants_snps_triploid_$round.vcf 2>>error_snp_calling_and_BR_triploid_$round.txt";
#pull out indels to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_triploid_$round.vcf -selectType INDEL -o raw_variants_indel_triploid_$round.vcf 2>>error_snp_calling_and_BR_triploid_$round.txt";

#mark high confidence snps (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_snps_triploid_$round.vcf -window 35 -cluster 3 --filterExpression 'QD<2.0||FS>60.0||MQ<40.0||HaplotypeScore>13.0||MappingQualityRankSum<-12.5||ReadPosRankSum<-8.0' --filterName 'my snp filter' -o snps_filtered_triploid_$round.vcf 2>>error_snp_calling_and_BR_triploid_$round.txt";
#mark high confidence indels (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_indel_triploid_$round.vcf --filterExpression 'QD<2.0||FS>200.0||ReadPosRankSum<-20.0' --filterName 'my_indel_filter' -o indel_filtered_triploid_$round.vcf 2>>error_snp_calling_and_BR_triploid_$round.txt";

my $snp_file = "snps_filtered_triploid_$round.vcf";
open SNP_IN, "< $snp_file";

my $snp_outputfile = "PASSED_SNPs_triploid_$round.recode.vcf ";
open SNP_OUT, "> $snp_outputfile";

my $snp_line;

while (<SNP_IN>) {
	$snp_line=$_;
	chomp $snp_line;
	unless ($snp_line=~ /(SnpCluster)|(my\ssnp\sfilter)/){
		print SNP_OUT "$snp_line\n";
	}
}



my $indel_file = "indel_filtered_triploid_$round.vcf";
open INDEL_IN, "< $indel_file";

my $indel_outputfile = "PASSED_INDEL_triploid_$round.recode.vcf ";
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


#the above steps are subbing for the below steps which only work for diploids:#write these high confidence snps to a new file:
#system "/opt/apps/vcftools/bin/vcftools --vcf snps_filtered_triploid_$round.vcf --out PASSED_SNPs_triploid_$round --remove-filtered-all --recode"; 
#write these high confidence indels to a new file:
#system" /opt/apps/vcftools/bin/vcftools --vcf indel_filtered_triploid_$round.vcf --out PASSED_INDEL_triploid_$round --remove-filtered-all --recode";

close ERROR;exit;