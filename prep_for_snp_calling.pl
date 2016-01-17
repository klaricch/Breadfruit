#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script will run the pre-processing step needed before variant calling (alignment through indel realignment and the first round or snp calling) given a reference assembly and a list of samples
# on command line: script.pl <reference_assmebly.fast> <list of samples.txt>
# follow this script with "snp_calling_gatk.pl" which performs Base Recalibration and completes SNP/INDEL identification

# example sample in list of samples.txt: RNA10_H3E_CAGATC_L003
# standard errors or certain parts will be output to "error_log" files for each sample

my $reference = $ARGV[0]; 


$reference =~ /(.+)\.fasta/;
my $reference_sample_name = $1;
my $full_name_sample;
my $sample;

my @sample_list;
my $sample_inputs;



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
RNA24_A3Wl => 'lane2',
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


###################################################################################
###################################################################################
#
# PREPARE THE REFERENCE ASSEMBLY
#
###################################################################################
###################################################################################
#system "bwa index $reference";  #use SH=simple header assembly
#make dictionary file of the reference assembly:
#system "java -jar /data/mjohnson/picard/dist/CreateSequenceDictionary.jar R= $reference O= $reference_sample_name.dict";
#make fasta index of the reference assembly:
#system "samtools faidx $reference";

###################################################################################
###################################################################################
#
# INDIVIDUAL SAMPLES
#
###################################################################################
###################################################################################



	$full_name_sample = $ARGV[1];
	#chomp $full_name_sample;
	$full_name_sample =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
	$sample = $1;
	print "$full_name_sample\n";
	open ERROR_OUT, "> error_log_$sample.txt";
###################################################################################
###################################################################################
#
# BWA Alignment
#
###################################################################################
###################################################################################


system "bwa aln $reference /home/zerega/data/kristen/assemblies/A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq > $sample\_1.sai"; #forward paired

system "bwa aln $reference /home/zerega/data/kristen/assemblies/A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_2.sai"; #reverse paired

system "cat /home/zerega/data/kristen/assemblies/A_WT_R1_out.unpaired_$full_name_sample\_R1_001.fastq /home/zerega/data/kristen/assemblies/A_WT_R2_out.unpaired_$full_name_sample\_R2_001.fastq > $sample\_S.fastq"; #combine unpaired reads into one fastq file

system "bwa aln $reference $sample\_S.fastq > $sample\_S.sai"; #all of the unpaired reads

#the paired ends:
system "bwa sampe $reference $sample\_1.sai $sample\_2.sai /home/zerega/data/kristen/assemblies/A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq /home/zerega/data/kristen/assemblies/A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_PE.sam";

#the unpaired ends:
system "bwa samse $reference $sample\_S.sai $sample\_S.fastq > $sample\_SE.sam";

###################################################################################
###################################################################################
#
# SAMTOOLS(mostly)
#
###################################################################################
###################################################################################


system "samtools view -bS $sample\_PE.sam > $sample\_PE.bam"; #convert paired sam to bam
system "samtools view -bS $sample\_SE.sam > $sample\_SE.bam"; #convert unpaired sam to bam

system "samtools sort $sample\_PE.bam $sample\_SPE"; #sort paired bam, unnecessary at this point? #dont put ".bam" at end of sort command
system "samtools sort $sample\_SE.bam $sample\_SSE"; #sort unpaired bam, unnecessary at this point?

#fix mate pairs out of sync:
system "java -jar /data/mjohnson/picard/dist/FixMateInformation.jar INPUT=$sample\_SPE.bam OUTPUT=$sample\_FM_SPE.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT 2>error_log_$sample.txt";

system "samtools merge $sample\_all.bam $sample\_FM_SPE.bam $sample\_SSE.bam"; #merge paired and unpaired into one file

system "samtools index $sample\_all.bam"; #index file to speed up next step
system "samtools sort $sample\_all.bam $sample\_all_sorted"; #sort this final file

###################################################################################
###################################################################################
#
# PICARD
#
###################################################################################
###################################################################################

#add read groups:
system "java -jar /data/mjohnson/picard/dist/AddOrReplaceReadGroups.jar I=$sample\_all_sorted.bam O=$sample\_S_RG.bam ID=$lane_hash{$sample} LB=lib_$sample PL=illumina PU=$lane_hash{$sample} SM=$sample VALIDATION_STRINGENCY=LENIENT 2>>error_log_$sample.txt";
####WHY PROCESSED 59,000?!??!?!?!??!

#mark duplicates:
system "java -jar /data/mjohnson/picard/dist/MarkDuplicates.jar I=$sample\_S_RG.bam O=$sample\_S_RG_MD.bam M=metrics_file_$sample.txt ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 2>>error_log_$sample.txt"; #set this number below result of ulimit -n
#bam index?


###################################################################################
###################################################################################
#
# SPLIT N CIGARS and INDEL REALIGNER
#
###################################################################################
###################################################################################
#reorder
system "java -jar /data/mjohnson/picard/dist/ReorderSam.jar INPUT=$sample\_S_RG_MD.bam OUTPUT=$sample\_S_RG_MD_R.bam REFERENCE=$reference VALIDATION_STRINGENCY=LENIENT";
#index:
system "samtools index $sample\_S_RG_MD_R.bam $sample\_S_RG_MD_R.bai";
#removed unmapped reads which cause errors with SplitNCigars
system "samtools view -bF 4  $sample\_S_RG_MD_R.bam >  $sample\_S_RG_MD_R_RUM.bam";
#index:
system "samtools index  $sample\_S_RG_MD_R_RUM.bam  $sample\_S_RG_MD_R_RUM.bai";
#SplitNCigarReads:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T SplitNCigarReads -R $reference -I $sample\_S_RG_MD_R_RUM.bam -o $sample\_S_RG_MD_R_RUM_SC.bam -U ALLOW_N_CIGAR_READS";
#create the targets:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -I $sample\_S_RG_MD_R_RUM_SC.bam -o indel_Target_Intervals_$sample.intervals -nt 1 2>>error_log_$sample.txt";
#the realignment:
system "java -jar /data/mjohnson/GenomeAnalysisTK.jar -T IndelRealigner -R $reference -I $sample\_S_RG_MD_R_RUM_SC.bam -targetIntervals indel_Target_Intervals_$sample.intervals -o realigned_$sample.bam 2>>error_log_$sample.txt";

push (@sample_list, "realigned_$sample.bam");
close ERROR_OUT;
exit;