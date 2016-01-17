#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script takes a file of tab delimited paired end reads and trims and aligns them with Trimmomatic and Trinity 
# on command line: Process.pl <file with names of paired end reads (pairs separated by tabs)> 

#prep n50 csv report file for all samples:
my $column_names= "Read Count,Pairs Survived,%,Forward Only Survived,%,Reverse Only Survived,%,Dropped,%,A-Tails Removed from Forward,A-Tails Removed from Reverse,T-Tails Removed from Forward,T-Tails Removed from Reverse,Assembly,Number of contigs,Total size of contigs,Longest contig,Shortest contig,Number of contigs > 1K nt,Percentage of contigs > 1K nt,Number of contigs > 10K nt,Percentage of contigs > 10K nt,Number of contigs > 100K nt,Percentage of contigs > 100K nt,Number of contigs > 1M nt,Percentage of contigs > 1M nt,Number of contigs > 10M nt,Percentage of contigs > 10M nt,Mean contig size,Median contig size,N50 contig length,L50 contig count,contig %A,contig %C,contig %G,contig %T,contig %N,contig %non-ACGTN,Number of contig non-ACGTN nt,";
open CSV, "+>> N50_Stats.csv";
print CSV "$column_names\n";

my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $fileR1;
my $fileR2;
my @org_files;
my $item;
my $line2;
my $line3;
my $line4;
my $line_STATS;
my $line9_STATS;
my @results_STATS;

while (<IN>) {
	$line = $_;
	chomp $line;
	@results = split (/\t/, $line);
	$fileR1 = $results[0];
	$fileR2 = $results[1];
	@org_files=("$fileR1","$fileR2");
	
########################################################################################################
########################################################################################################
#
#                                READ COUNT
#
########################################################################################################
########################################################################################################
system "mv /home/zerega/data/kristen/samples/originals/$fileR1.gz .";
system "mv /home/zerega/data/kristen/samples/originals/$fileR2.gz .";
system "gunzip $fileR1.gz";
system "gunzip $fileR2.gz";
my $line_count = `wc -l $fileR1`;  #back ticks act as "system" but can store the output into a variable
my $read_count = ($line_count/4); #each read has four lines of data associated with it; therefore, divide the total line count by 4 to obtain the read count
print CSV "$read_count,";
########################################################################################################
########################################################################################################
#
#                                 TRIMMOMATIC
#
########################################################################################################
########################################################################################################
system "netstat |java -jar /usr/local/bin/trimmomatic-0.30.jar PE -threads 10 -phred33 $fileR1 $fileR2 R1_out.paired_$fileR1 R1_out.unpaired_$fileR1 R2_out.paired_$fileR2 R2_out.unpaired_$fileR2 ILLUMINACLIP:Adapters_TruSeq3-PE-2.alt.fa:2:30:10:1 HEADCROP:15 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:50 2> trimmomatic_stats.txt"; #use netstat and 2> becuase the trimmomatic basic stats normally printed to the screen are part of the standard error, not the standard output
open TRIM_STATS, " < trimmomatic_stats.txt";
while (<TRIM_STATS>){
	$line_STATS = $_;
	scalar <TRIM_STATS>,scalar <TRIM_STATS>,scalar <TRIM_STATS>,scalar <TRIM_STATS>,scalar <TRIM_STATS>,scalar <TRIM_STATS>,scalar <TRIM_STATS>;
	$line9_STATS = scalar <TRIM_STATS>;
	chomp $line9_STATS;
	@results_STATS = split (/\s+/, $line9_STATS);
	print CSV "$results_STATS[6],$results_STATS[7],$results_STATS[11],$results_STATS[12],$results_STATS[16],$results_STATS[17],$results_STATS[19],$results_STATS[20],";
	last;
}
########################################################################################################
########################################################################################################
#
#                                POLY A TAIL REMOVAL
#
########################################################################################################
########################################################################################################
system "trimest -sformat fastq-sanger -sequence R1_out.paired_$fileR1 -osformat fastq-sanger -outseq WT_R1_out.paired_$fileR1 -minlength 4 -mismatches 1"; #WT=without tail
system "trimest -sformat fastq-sanger -sequence R2_out.paired_$fileR2 -osformat fastq-sanger -outseq WT_R2_out.paired_$fileR2 -minlength 4 -mismatches 1";	
system "trimest -sformat fastq-sanger -sequence R1_out.unpaired_$fileR1 -osformat fastq-sanger -outseq WT_R1_out.unpaired_$fileR1 -minlength 4 -mismatches 1"; #WT=without tail
system "trimest -sformat fastq-sanger -sequence R2_out.unpaired_$fileR2 -osformat fastq-sanger -outseq WT_R2_out.unpaired_$fileR2 -minlength 4 -mismatches 1";	
#look at how many poly-A/T tails were removed
my $AF = `grep -c 'poly-A tail removed' WT_R1_out.paired_$fileR1`+`grep -c 'poly-A tail removed' WT_R1_out.unpaired_$fileR1`;
my $AR = `grep -c 'poly-A tail removed' WT_R2_out.paired_$fileR2`+ `grep -c 'poly-A tail removed' WT_R2_out.unpaired_$fileR2`;
my $TF = `grep -c 'poly-T tail removed' WT_R1_out.paired_$fileR1`+`grep -c 'poly-T tail removed' WT_R1_out.unpaired_$fileR1`;
my $TR = `grep -c 'poly-T tail removed' WT_R2_out.paired_$fileR2`+ `grep -c 'poly-T tail removed' WT_R2_out.unpaired_$fileR2`;
print CSV "$AF,$AR,$TF,$TR,";


########################################################################################################
########################################################################################################
#
#                                  DISCARD SMALL LENGTH READS
#
########################################################################################################
########################################################################################################
my $A_file="WT_R1_out.paired_$fileR1";
open A_IN, "< $A_file";

open (A_WT1, ">> WT_R1_out.unpaired_$fileR1"); #want to append to the unpaired file, but not overwrite the reads already there
open (A_WT2, ">> WT_R2_out.unpaired_$fileR2"); #want to append to the unpaired file, but not overwrite the reads already there

my $A_outputfile = "keep_intermediate.txt";
open (A_FILE, "> $A_outputfile");
my $A_length;


my ($A_line1, $A_line2, $A_line3, $A_line4, $A_line1_2, $A_line2_2, $A_line3_2, $A_line4_2, $A_line1_3, $A_line2_3, $A_line3_3, $A_line4_3,$A_line1_4, $A_line2_4, $A_line3_4, $A_line4_4,$A_line1_5, $A_line2_5, $A_line3_5, $A_line4_5);
my @A_results;
my @A_hash1;
my @A_hash2;
my %A_hash1;
my %A_hash2;
my $A_readID;

## in forward file
while (<A_IN>){	
	$A_line1=$_;
	chomp;
	$A_line2 = scalar <A_IN>;
	$A_line3 = scalar <A_IN>;
	$A_line4 = scalar <A_IN>;
	chomp $A_line2;
	 $A_length = length ($A_line2);
	if ($A_length >=50){ print A_FILE "$A_line1$A_line2\n$A_line3$A_line4" #if seq length >50, print to the paired keep file
	} else{
		push(@A_hash1,$A_line1); # if seq length <50, don't print to keep file, and put in a hash
		
	}	
	}

@A_hash2 = @A_hash1;
map{s/ 1/ 2/} @A_hash2; # need to search for these forward ids in the reverse ids
%A_hash2 = map { $_ => 1 } @A_hash2; #convert array to hash, give a value b/c hash needs it even tho it wont be used

## in reverse file
my $A_file2="WT_R2_out.paired_$fileR2";
open A_IN2, "< $A_file2";
my $A_outputfile2 = "A_WT_R2_out.paired_$fileR2";
open (A_FILE2, "> $A_outputfile2");
my %A_hash2_2;
my %A_hash1_2;
my @A_hash2_2;
my @A_hash1_2;

while (<A_IN2>){
	$A_line1_2=$_;
	chomp;
	$A_line2_2 = scalar <A_IN2>;
	$A_line3_2 = scalar <A_IN2>;
	$A_line4_2 = scalar <A_IN2>;
	chomp $A_line2_2;
	$A_length = length ($A_line2_2);
	if ($A_length >=50){
		if   (exists $A_hash2{$A_line1_2}){ #if seq length >50 and in forward file <50, print to the unpaired file
			 print A_WT2 "$A_line1_2$A_line2_2\n$A_line3_2$A_line4_2"
			 }
		else {
			print A_FILE2 "$A_line1_2$A_line2_2\n$A_line3_2$A_line4_2" #if seq length >50 and in forward file >50, print to the paired keep file
			}
		}
		else { push(@A_hash2_2,$A_line1_2); #if seq length <50, don't print to keep file, and put in a hash
	}
}

@A_hash1_2 = @A_hash2_2;
map{s/ 2/ 1/} @A_hash1_2; #need to search for these reverse ids in the forward ids
%A_hash1_2 = map { $_ => 1 } @A_hash1_2; #convert array to hash, give a value b/c hash needs it even tho it won't be used
	

close A_FILE;
my $A_outputfile3 = "A_WT_R1_out.paired_$fileR1";
open (A_FILE3, "> $A_outputfile3");
open (A_FILE, "< $A_outputfile");	
while (<A_FILE>){
	$A_line1_3=$_;
	chomp;
	$A_line2_3 = scalar <A_FILE>;
	$A_line3_3 = scalar <A_FILE>;
	$A_line4_3 = scalar <A_FILE>;
	chomp $A_line2_3;
	my $A_length = length ($A_line2_3);
	if   (exists $A_hash1_2{$A_line1_3}){   #all lines in here are already >=50 so don't need that additional screening
			 print A_WT1 "$A_line1_3$A_line2_3\n$A_line3_3$A_line4_3" #print to unpaired file if founs in the hash from the reverse file
			 }
		else {
			print A_FILE3 "$A_line1_3$A_line2_3\n$A_line3_3$A_line4_3" #print to final paired keep file
			}
		}
		
close A_WT1;
close A_WT2;
		
open (A_WT1, "< WT_R1_out.unpaired_$fileR1"); 
my $A_final_unpairedF = "A_WT_R1_out.unpaired_$fileR1";
open (UNPAIREDF, "> $A_final_unpairedF");

while (<A_WT1>){	
	$A_line1_4=$_;
	chomp;
	$A_line2_4 = scalar <A_WT1>;
	$A_line3_4 = scalar <A_WT1>;
	$A_line4_4 = scalar <A_WT1>;
	chomp $A_line2_4;
	 $A_length = length ($A_line2_4);
	if ($A_length >=50){ print UNPAIREDF "$A_line1_4$A_line2_4\n$A_line3_4$A_line4_4" #if seq length >50, print to the unpaired keep file
	}
}

open (A_WT2, "< WT_R2_out.unpaired_$fileR2");	
my $A_final_unpairedR = "A_WT_R2_out.unpaired_$fileR2";
open (UNPAIREDR, "> $A_final_unpairedR");

while (<A_WT2>){	
	$A_line1_5=$_;
	chomp;
	$A_line2_5 = scalar <A_WT2>;
	$A_line3_5 = scalar <A_WT2>;
	$A_line4_5 = scalar <A_WT2>;
	chomp $A_line2_5;
	 $A_length = length ($A_line2_5);
	if ($A_length >=50){ print UNPAIREDR "$A_line1_5$A_line2_5\n$A_line3_5$A_line4_5" #if seq length >50, print to the unpaired keep file
	}
}

#run FASTQC
system "fastqc A_WT_R1_out.paired_$fileR1 --outdir fastqc_reports";
system "fastqc A_WT_R2_out.paired_$fileR2 --outdir fastqc_reports";

close A_IN;
close A_IN2;
close A_WT1;
close A_WT2;
close A_FILE;
close A_FILE2;
close A_FILE3;
########################################################################################################
########################################################################################################
#
#                                  TRINITY
#
########################################################################################################
########################################################################################################
system "Trinity.pl --seqType fq --JM 100G --left A_WT_R1_out.paired_$fileR1 --right A_WT_R2_out.paired_$fileR2 --single A_WT_R1_out.unpaired_$fileR1 A_WT_R2_out.unpaired_$fileR2 --output trinity_out_dir_$fileR1 --full_cleanup --CPU 10"; 
########################################################################################################
########################################################################################################
#
#                                  LONGEST ISOFORM
#
########################################################################################################
########################################################################################################
## this script extracts the longest isoforms from an assembly

my $file_LI= "trinity_out_dir_$fileR1.Trinity.fasta"; 
my $line_LI;
my @results_LI;
my $full_contig_info;
my %hash;
my %sumhash;

open IN_LI, "< $file_LI" or die $!;
my $outputfile = "List_of_Longest_Contigs.txt";
open (FILE, "> $outputfile");
my $key;
my $value;
my $new_key;
my @other_results;
my $contig;

while (<IN_LI>){
	$line_LI = $_;
	chomp $line_LI;
	if ($line_LI =~/^>/){ 
		@results_LI = split (/ |(?=s)|=/, $line_LI);
		
		$full_contig_info = $results_LI[0];
		my $seq_no = $results_LI[1];
		my $length = $results_LI[3];
		$key = $full_contig_info;
		$value = $length;
		$new_key="$full_contig_info$seq_no";
		
		if (exists $hash{$key}) {
			if ($value >= $hash{$key}) { 
				$sumhash{$key} = "$value\t$new_key";
				$hash{$key} = $value;
				}
				
			} else {
				$hash{$key} = $value;
				$sumhash{$key} = "$value\t$new_key"};
	} 
	

}

foreach (keys %sumhash) 
{
    print FILE "$_\t$sumhash{$_}\n";
};


my $line2_LI;
my @results2_LI;
my $longest_contig;
my %longest_contig_hash;
 open FILE, "< $outputfile" or die $!;
while (<FILE>){
	$line2_LI = $_;
	chomp $line2_LI;
	@results2_LI = split (/\t/, $line2_LI);
	$longest_contig = $results2_LI[2];
	$longest_contig_hash{$longest_contig}=0;
}
	
my $outputfile2 = "LI_$fileR1";
open (FILE2, "> $outputfile2");

close IN_LI;	
open IN_LI, "< $file_LI" or die $!;


my $line3_LI;
while (<IN_LI>) { 
	$line3_LI = $_;
	chomp $line3_LI;
	if ($line3_LI =~/^>/ ) { @other_results = split (/ /, $line3_LI);
		$contig=$other_results[0]};
		if (exists $longest_contig_hash{$contig}){
	print FILE2 "$line3_LI\n"}
}


########################################################################################################
########################################################################################################
#
#                         ASSEMBLY QUALITY (N50 Script)
#
########################################################################################################
########################################################################################################

system "n50.pl LI_$fileR1 -csv > n50_report_LI_$fileR1.txt";
my $csv = "LI_$fileR1.csv"; #the n50 report for an individual sample
#map {s/\.fasta//} $csv; #take out "fasta" because this is not in the output file name from the n50 script

my $fileCSV = "$csv";  #needed to take out "fasta" earlier and now make it csv
open INCSV, "<$fileCSV"; 

my $line_CSV;
my $line2_CSV;
my @results_CSV;
my @array_CSV;

while (<INCSV>){
	$line_CSV = $_; #the headers
	chomp $line_CSV;
	$line2_CSV = scalar <INCSV>; #the stats
	@results_CSV = split (/,/, $line2_CSV);
	@array_CSV = 0..25;   #don't need repetitive scaffold/contig counts so only print the first set
	foreach (@array_CSV){ 
		print CSV "$results_CSV[$_]," #the numbers 0-25 will fill in for the $_
		}
		print CSV "\n";
}

system "gzip $fileR1";
system "gzip $fileR2";	
system "gzip R1_out.paired_$fileR1"; 
system "gzip R1_out.unpaired_$fileR1"; 
system "gzip R2_out.paired_$fileR2";
system "gzip R2_out.unpaired_$fileR2";
system "gzip WT_R1_out.paired_$fileR1";
system "gzip WT_R1_out.unpaired_$fileR1";
system "gzip WT_R2_out.paired_$fileR2";
system "gzip WT_R2_out.unpaired_$fileR2";

	
}

close IN;
close IN_LI;
close INCSV;
close TRIM_STATS;
close CSV;
close FILE;
close FILE2;

exit;
	