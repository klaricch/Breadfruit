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

open ERROR, "> error_snp_calling_and_BR_$round\_diploid.txt";

#BASE RECALIBRATION
print "duh";system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T BaseRecalibrator -R $reference -I $samples -knownSites PASSED_SNPs_diploid_$previous_round.recode.vcf -knownSites PASSED_INDEL_diploid_$previous_round.recode.vcf -o recalibrated_samples_diploid_$round.table -nct 10 2>error_snp_calling_and_BR_diploid_$round.txt";
system"java -jar /data/mjohnson/GenomeAnalysisTK.jar -T BaseRecalibrator -R $reference -I $samples -knownSites PASSED_SNPs_diploid_$previous_round.recode.vcf -knownSites PASSED_INDEL_diploid_$previous_round.recode.vcf -BQSR recalibrated_samples_diploid_$round.table -o post_recalibrated_samples_diploid_$round.table -nct 10 2>>error_snp_calling_and_BR_diploid_$round.txt";
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T AnalyzeCovariates -R $reference -before recalibrated_samples_diploid_$round.table -after post_recalibrated_samples_diploid_$round.table -plots recalibration_plots_diploid_$round.pdf 2>>error_snp_calling_and_BR_diploid_$round.txt";
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T PrintReads -R $reference -I $samples -BQSR recalibrated_samples_diploid_$round.table -o RECAL_samples_diploid_$round.bam -nct 10 2>>error_snp_calling_and_BR_diploid_$round.txt";

#N ROUND SNP CALLING#call all variants:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T UnifiedGenotyper -R $reference -I RECAL_samples_diploid_$round.bam -glm BOTH -ploidy 2 -stand_call_conf 20 -stand_emit_conf 20 -o raw_variants_all_diploid_$round.vcf -nct 10 2>>error_snp_calling_and_BR_diploid_$round.txt";
#pull out snps to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_diploid_$round.vcf -selectType SNP -o raw_variants_snps_diploid_$round.vcf 2>>error_snp_calling_and_BR_diploid_$round.txt";
#pull out indels to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_diploid_$round.vcf -selectType INDEL -o raw_variants_indel_diploid_$round.vcf 2>>error_snp_calling_and_BR_diploid_$round.txt";

#mark high confidence snps (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_snps_diploid_$round.vcf -window 35 -cluster 3 --filterExpression 'QD<2.0||FS>60.0||MQ<40.0||HaplotypeScore>13.0||MappingQualityRankSum<-12.5||ReadPosRankSum<-8.0' --filterName 'my snp filter' -o snps_filtered_diploid_$round.vcf 2>>error_snp_calling_and_BR_diploid_$round.txt";
#write these high confidence snps to a new file:
system "/opt/apps/vcftools/bin/vcftools --vcf snps_filtered_diploid_$round.vcf --out PASSED_SNPs_diploid_$round --remove-filtered-all --recode"; 
#mark high confidence indels (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_indel_diploid_$round.vcf --filterExpression 'QD<2.0||FS>200.0||ReadPosRankSum<-20.0' --filterName 'my_indel_filter' -o indel_filtered_diploid_$round.vcf 2>>error_snp_calling_and_BR_diploid_$round.txt";
#write these high confidence indels to a new file:
system" /opt/apps/vcftools/bin/vcftools --vcf indel_filtered_diploid_$round.vcf --out PASSED_INDEL_diploid_$round --remove-filtered-all --recode";

close ERROR;exit;