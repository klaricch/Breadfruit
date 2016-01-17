#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


##create a log fil!!#!#!#!!!!!!!!!!!!!
my $reference = $ARGV[0]; 
my  $list_of_samples = $ARGV[1];

$reference =~ /(.+)\.fasta/;
my $reference_sample_name = $1;
my $full_name_sample;
my $sample;


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

open IN, "< $list_of_samples";
while (<IN>){ 
	$full_name_sample = $_;
	chomp $full_name_sample;
	$full_name_sample =~ /(RNA\d+_\w\d\w|EW\d+_\w\d\w)/;
	$sample = $1;
###################################################################################
###################################################################################
#
# BWA Alignment
#
###################################################################################
###################################################################################
#system "bwa index $reference";  #use SH=simple header assembly

#system "bwa aln $reference A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq > $sample\_1.sai"; #forward paired

#system "bwa aln $reference A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_2.sai"; #reverse paired

#system "cat A_WT_R1_out.unpaired_$full_name_sample\_R1_001.fastq A_WT_R2_out.unpaired_$full_name_sample\_R2_001.fastq > $sample\_S.fastq"; #combine unpaired reads into one fastq file

#system "bwa aln $reference $sample\_S.fastq > $sample\_S.sai"; #all of the unpaired reads

#the paired ends:
#system "bwa sampe $reference $sample\_1.sai $sample\_2.sai A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_PE.sam";

#the unpaired ends:
#system "bwa samse $reference $sample\_S.sai $sample\_S.fastq > $sample\_SE.sam";

###################################################################################
###################################################################################
#
# SAMTOOLS
#
###################################################################################
###################################################################################

#system "samtools view -bS $sample\_PE.sam > $sample\_PE.bam"; #convert paired sam to bam
#system "samtools view -bS $sample\_SE.sam > $sample\_SE.bam"; #convert unpaired sam to bam

#system "samtools sort $sample\_PE.bam $sample\_SPE"; #sort paired bam, unnecessary at this point? #dont put ".bam" at end of sort command
#system "samtools sort $sample\_SE.bam $sample\_SSE"; #sort unpaired bam, unnecessary at this point?

#system "samtools merge $sample\_all.bam $sample\_SPE.bam $sample\_SSE.bam"; #merge paired and unpaired into one file

#system "samtools sort $sample\_all.bam $sample\_all_sorted"; #sort this final file

###################################################################################
###################################################################################
#
# PICARD
#
###################################################################################
###################################################################################

#add read groups:
#system "java -jar /data/mjohnson/picard/dist/AddOrReplaceReadGroups.jar I=$sample\_all_sorted.bam O=$sample\_S_RG.bam ID=$lane_hash{$sample} LB=lib_$sample PL=illumina PU=$lane_hash{$sample} SM=$sample VALIDATION_STRINGENCY=LENIENT";
####WHY PROCESSED 59,000?!??!?!?!??!

#mark duplicates:
#system "java -jar /data/mjohnson/picard/dist/MarkDuplicates.jar I=$sample\_S_RG.bam O=$sample\_S_RG_MD.bam M=metircs_file_$sample.txt ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000"; #set this number below result of ulimit -n

#make dictionary file of the reference assembly:
#system "java -jar /data/mjohnson/picard/dist/CreateSequenceDictionary.jar R= $reference O= $reference_sample_name.dict";

#make fasta index of the reference assembly:
#system "samtools faidx $reference";

system "samtools index $sample\_S_RG_MD.bam $sample\_S_RG_MD.bai";

exit;
}
close IN;
exit;