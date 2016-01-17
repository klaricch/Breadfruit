#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $reference;
my $long_header_reference;
my $full_name_sample;
my $sample;
my @F;

	$full_name_sample = $ARGV[0];
	#chomp $full_name_sample;
	$full_name_sample =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
	$sample = $1;
	$long_header_reference = "LI_$full_name_sample\_R1_001.fastq";
	print "$full_name_sample\n";

	
###################################################################################
###################################################################################
#
# PREPARE THE REFERENCE ASSEMBLY
#
###################################################################################
###################################################################################
#remove long trinity headers:
#system "cat /home/zerega/data/kristen/assemblies/$long_header_reference  | perl -lane 'print \$F[0]' > LI_$full_name_sample\_simple_header.fasta";
#$reference = "LI_$full_name_sample\_simple_header.fasta";
#system "bwa index $reference";  #use SH=simple header assembly
#make dictionary file of the reference assembly:
#system "java -jar /data/mjohnson/picard/dist/CreateSequenceDictionary.jar R= $reference O= $reference.dict";
#make fasta index of the reference assembly:
#system "samtools faidx $reference";
###################################################################################
#
# BWA Alignment
#
###################################################################################
###################################################################################

#system "bwa aln $reference /home/zerega/data/kristen/assemblies/A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq > $sample\_1.sai"; #forward paired

#system "bwa aln $reference /home/zerega/data/kristen/assemblies/A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_2.sai"; #reverse paired

#system "cat /home/zerega/data/kristen/assemblies/A_WT_R1_out.unpaired_$full_name_sample\_R1_001.fastq /home/zerega/data/kristen/assemblies/A_WT_R2_out.unpaired_$full_name_sample\_R2_001.fastq > $sample\_S.fastq"; #combine unpaired reads into one fastq file

#system "bwa aln $reference $sample\_S.fastq > $sample\_S.sai"; #all of the unpaired reads

#the paired ends:
#system "bwa sampe $reference $sample\_1.sai $sample\_2.sai /home/zerega/data/kristen/assemblies/A_WT_R1_out.paired_$full_name_sample\_R1_001.fastq /home/zerega/data/kristen/assemblies/A_WT_R2_out.paired_$full_name_sample\_R2_001.fastq > $sample\_PE.sam";

#the unpaired ends:
#system "bwa samse $reference $sample\_S.sai $sample\_S.fastq > $sample\_SE.sam";


###################################################################################
###################################################################################
#
# SAMTOOLS(mostly)
#
###################################################################################
###################################################################################
#system "samtools view -bS $sample\_PE.sam > $sample\_PE.bam"; #convert paired sam to bam
#system "samtools view -bS $sample\_SE.sam > $sample\_SE.bam"; #convert unpaired sam to bam
#system "samtools sort $sample\_PE.bam $sample\_SPE"; #sort paired bam, unnecessary at this point? #dont put ".bam" at end of sort command
#system "samtools sort $sample\_SE.bam $sample\_SSE"; #sort unpaired bam, unnecessary at this point?
#fix mate pairs out of sync:
#system "java -Xmx2g -Djava.io.tmpdir=/home/zerega/data/kristen/snps/tmp -jar /data/mjohnson/picard/dist/FixMateInformation.jar INPUT=$sample\_SPE.bam OUTPUT=$sample\_FM_SPE.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT TMP_DIR=/home/zerega/data/kristen/snps/tmp 2>error_log_$sample.txt";
#system "samtools merge $sample\_all.bam $sample\_FM_SPE.bam $sample\_SSE.bam"; #merge paired and unpaired into one file
#system "samtools index $sample\_all.bam"; #index file to speed up next step
#system "samtools sort $sample\_all.bam $sample\_all_sorted"; #sort this final file
#system "samtools index $sample\_all_sorted.bam";
###################################################################################
###################################################################################
#
# DEPTH
#
###################################################################################
###################################################################################
#system "samtools depth $sample\_all_sorted.bam > $sample\_depth.txt";
#system "Rscript /home/zerega/data/scripts/depth.r $sample\_depth.txt > depth_metrics_$sample.txt";

###################################################################################
###################################################################################
#
# CLEANUP
#
###################################################################################
###################################################################################

my @cleanup;
my $cleanup_file;
push (@cleanup,
	"$sample\_1.sai",
	"$sample\_2.sai",
	"$sample\_S.fastq",
	"$sample\_S.sai",
	"$sample\_PE.sam",
	"$sample\_SE.sam",
	"$sample\_PE.bam",
	"$sample\_SPE.bam",
	"$sample\_SSE.bam",
	"$sample\_FM_SPE.bam",
	"$sample\_all.bam",
	"$sample\_all.bam.bai",
#	"$sample\_all_sorted.bam",
#	"$sample\_all_sorted.bam.bai",

	);
foreach $cleanup_file(@cleanup){
	system "lftp sftp://kristen:moraceae\@10.0.7.154 -e 'cd homes/kristen/data/depth_and_self_alignment_intermediate_files; put $cleanup_file;bye'";
	system "rm $cleanup_file";
	
}

exit;