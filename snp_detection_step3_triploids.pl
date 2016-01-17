#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script will run merge samples listed in a file, pre-processing them, and do the initial variant calling
# on command line: script.pl <reference_assmebly.fast> <list of samples.txt>
# this script schould be ran after snp_detection_step.pl
# follow this script with "snp_calling_gatk.pl" which performs Base Recalibration and completes SNP/INDEL identification

# example sample in list of samples.txt: RNA10_H3El_CAGATC_L003


my $reference = $ARGV[0]; 
my  $list_of_samples = $ARGV[1];

$reference =~ /(.+)\.fasta/;
my $reference_sample_name = $1;
my $full_name_sample;
my $sample;

my @sample_list;
my $sample_inputs;


#HASH
my %lane_hash =(
RNA16_H3m => 'lane1',
RNA17_A3E => 'lane1',
RNA21_A2M => 'lane1',
RNA24_A2M => 'lane1',
RNA2_C2m => 'lane1',
RNA32_H2W => 'lane1',
RNA5_C2E => 'lane1',
RNA7_M2m => 'lane1',
RNA24_A3W => 'lane2',
RNA35_C2M => 'lane2',
RNA36_H2W => 'lane2',
RNA37_C2m => 'lane2',
RNA38_A3W => 'lane2',
RNA39_A3E => 'lane2',
RNA40_H3m => 'lane2',
RNA48_H2m => 'lane2',
RNA10_H3E => 'lane3',
RNA25_A3m => 'lane3',
RNA26_A3m => 'lane3',
RNA49_H3E => 'lane3',
RNA4_A3E => 'lane3',
EW1_A2M => 'lane4', ####CHECK WHAT TO DO FO THESE SAMPLES!
EW2_C2M => 'lane4',
EW3_A3E => 'lane4',
EW4_C2M => 'lane4',
);



###################################################################################
###################################################################################
#
# INDIVIDUAL SAMPLES
#
###################################################################################
###################################################################################

open IN, "< $list_of_samples";
while (<IN>){ 

	$full_name_sample = $_;
	chomp $full_name_sample;
	$full_name_sample =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
	$sample = $1;
	print "$full_name_sample\n";

push (@sample_list, "realigned_$sample.bam");

};
###################################################################################
###################################################################################
#
# MERGE FILES
#
###################################################################################
###################################################################################

$sample_inputs=join(" INPUT=", @sample_list);
#merge:
system "java -jar /data/mjohnson/picard/dist/MergeSamFiles.jar INPUT=$sample_inputs OUTPUT=UI_merged_samples_triploid.bam";
#############TAKE OUT FOLLOWING STEPS?
#reorder:
system "java -jar /data/mjohnson/picard/dist/ReorderSam.jar INPUT=UI_merged_samples_triploid.bam OUTPUT=merged_samples_triploid.bam REFERENCE=$reference TMP_DIR=/home/zerega/data/kristen/snps/tmp";
#index:
#system "samtools index merged_samples.bam  merged_samples.bai";
############TAKE OUT ABOVE STEPS
system "samtools index merged_samples_triploid.bam merged_samples_triploid.bai";
###################################################################################
###################################################################################
#
# MERGED FILE INDEL REALGINER
#
###################################################################################
###################################################################################
open ERROR, "> error_log_merged_samples_triploid.txt";
#create the targets:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -I merged_samples_triploid.bam -o indel_Target_Intervals_merged_samples_triploid.intervals -nt 8 2>>error_log_merged_samples_triploid.txt";
#the realignment:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T IndelRealigner -R $reference -I merged_samples_triploid.bam -targetIntervals indel_Target_Intervals_merged_samples_triploid.intervals -o realigned_merged_samples_triploid.bam 2>>error_log_merged_samples_triploid.txt";



###################################################################################
###################################################################################
#
# FIRST ROUND OF CALLING SNPS
#
###################################################################################
###################################################################################
#call all variants:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T UnifiedGenotyper -R $reference -I realigned_merged_samples_triploid.bam -glm BOTH -ploidy 3 -stand_call_conf 20 -stand_emit_conf 20 -o raw_variants_all_triploid_0.vcf -nct 8";
#pull out snps to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_triploid_0.vcf -selectType SNP -o raw_variants_snps_triploid_0.vcf";
#pull out indels to separate file:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SelectVariants -R $reference -V raw_variants_all_triploid_0.vcf -selectType INDEL -o raw_variants_indel_triploid_0.vcf";
#mark high confidence snps (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_snps_triploid_0.vcf -window 35 -cluster 3 --filterExpression 'QD<2.0||FS>60.0||MQ<40.0||HaplotypeScore>13.0||MappingQualityRankSum<-12.5||ReadPosRankSum<-8.0' --filterName 'my snp filter' -o snps_filtered_triploid_0.vcf";

###########
#ALTERNATIVE EXAMPLES
############
#java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R adj.LI_EW4_C2M_TAGCTT_L003_R1_001.fasta -V raw_variants_snps_0.vcf -window 35 -cluster 3 -filterName FS -filter "FS > 60.0" -filterName QD -filter "QD < 2.0"  -filterName MQ -filter "MQ<40" -filterName HaplotypeScore -filter "HaplotypeScore>13.0" -filterName MQ -filter "MappingQualityRankSum < -12.5" -filterName ReadPosRankSum -filter "ReadPosRankSum<-8.0" -o sns_filtered_TEST.vcf

#write these high confidence snps to a new file:
system "/opt/apps/vcftools/bin/vcftools --vcf snps_filtered_triploid_0.vcf --out PASSED_SNPs_triploid_0 --remove-filtered-all --recode"; #output file will have the prefix "PASSED_SNPs"
#mark high confidence indels (hard-filter):
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T VariantFiltration -R $reference -V raw_variants_indel_triploid_0.vcf --filterExpression 'QD<2.0||FS>200.0||ReadPosRankSum<-20.0' --filterName 'my_indel_filter' -o indel_filtered_triploid_0.vcf";
#write these high confidence indels to a new file:
system" /opt/apps/vcftools/bin/vcftools --vcf indel_filtered_triploid_0.vcf --out PASSED_INDEL_triploid_0 --remove-filtered-all --recode";

#vcf tools steps will fail because it can't handel polylpoids...use vcf_triploid.pl script for these steps instead
close ERROR;
close IN;
exit;