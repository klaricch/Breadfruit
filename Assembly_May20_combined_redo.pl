#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

# this script takes makes a combined assembly of the multiple samples 
# on command line: script/pl

#prep n50 csv report file:
my $column_names= "Assembly,Number of contigs,Total size of contigs,Longest contig,Shortest contig,Number of contigs > 1K nt,Percentage of contigs > 1K nt,Number of contigs > 10K nt,Percentage of contigs > 10K nt,Number of contigs > 100K nt,Percentage of contigs > 100K nt,Number of contigs > 1M nt,Percentage of contigs > 1M nt,Number of contigs > 10M nt,Percentage of contigs > 10M nt,Mean contig size,Median contig size,N50 contig length,L50 contig count,contig %A,contig %C,contig %G,contig %T,contig %N,contig %non-ACGTN,Number of contig non-ACGTN nt,Contigs with best hit in protein database,Unique peptides found,Average Ortholog hit ratio, Peptides with best hit in assembly,Unique contigs with hits,Reciprocal best hits,Average collapse factor,";
open CSV, "+>> N50_Stats_combined.csv";
print CSV "$column_names\n";

my $species = "altilis";

########################################################################################################
########################################################################################################
#
#                                  TRINITY
#
########################################################################################################
########################################################################################################
#CAMANSI #incorrect
#system "Trinity.pl --seqType fq --JM 100G --left A_WT_R1_out.paired_EW2_GCCAAT_L003_R1_001.fastq A_WT_R1_out.paired_EW4_TAGCTT_L003_R1_001.fastq A_WT_R1_out.paired_RNA2_ATCACG_L001_R1_001.fastq A_WT_R1_out.paired_RNA35_TAGCTT_L002_R1_001.fastq A_WT_R1_out.paired_RNA37_CTTGTA_L002_R1_001.fastq A_WT_R1_out.paired_RNA5_CGATGT_L001_R1_001.fastq --right A_WT_R2_out.paired_EW2_GCCAAT_L003_R2_001.fastq  A_WT_R2_out.paired_EW4_TAGCTT_L003_R2_001.fastq A_WT_R2_out.paired_RNA2_ATCACG_L001_R2_001.fastq A_WT_R2_out.paired_RNA35_TAGCTT_L002_R2_001.fastq A_WT_R2_out.paired_RNA37_CTTGTA_L002_R2_001.fastq A_WT_R2_out.paired_RNA5_CGATGT_L001_R2_001.fastq --single A_WT_R1_out.unpaired_EW2_GCCAAT_L003_R1_001.fastq A_WT_R1_out.unpaired_EW4_TAGCTT_L003_R1_001.fastq A_WT_R1_out.unpaired_RNA2_ATCACG_L001_R1_001.fastq A_WT_R1_out.unpaired_RNA35_TAGCTT_L002_R1_001.fastq A_WT_R1_out.unpaired_RNA37_CTTGTA_L002_R1_001.fastq A_WT_R1_out.unpaired_RNA5_CGATGT_L001_R1_001.fastq A_WT_R2_out.unpaired_EW2_GCCAAT_L003_R2_001.fastq A_WT_R2_out.unpaired_EW4_TAGCTT_L003_R2_001.fastq A_WT_R2_out.unpaired_RNA2_ATCACG_L001_R2_001.fastq A_WT_R2_out.unpaired_RNA35_TAGCTT_L002_R2_001.fastq A_WT_R2_out.unpaired_RNA37_CTTGTA_L002_R2_001.fastq A_WT_R2_out.unpaired_RNA5_CGATGT_L001_R2_001.fastq --output trinity_out_dir_camansi --full_cleanup --CPU 10 &> run_camansi.txt"; 

#HYBRID #inc

 

#ALTILIS #correct
system "Trinity.pl --seqType fq --JM 100G --left A_WT_R1_out.paired_RNA49_A3El_TAGCTT_L003_R1_001.fastq A_WT_R1_out.paired_RNA21_A2Mf_GCCAAT_L001_R1_001.fastq A_WT_R1_out.paired_RNA24_A2Ml_CAGATC_L001_R1_001.fastq A_WT_R1_out.paired_RNA25_A3ml_ACTTGA_L003_R1_001.fastq A_WT_R1_out.paired_RNA26_A3ml_GATCAG_L003_R1_001.fastq A_WT_R1_out.paired_RNA38_A3Wl_ATCACG_L002_R1_001.fastq A_WT_R1_out.paired_RNA39_A3El_CGATGT_L002_R1_001.fastq A_WT_R1_out.paired_RNA4_A3Ef_GCCAAT_L003_R1_001.fastq A_WT_R1_out.paired_EW1_A2Mf_AGTTCC_L003_R1_001.fastq A_WT_R1_out.paired_EW3_A3Ef_CGATGT_L003_R1_001.fastq --right A_WT_R2_out.paired_RNA49_A3El_TAGCTT_L003_R2_001.fastq A_WT_R2_out.paired_RNA21_A2Mf_GCCAAT_L001_R2_001.fastq A_WT_R2_out.paired_RNA24_A2Ml_CAGATC_L001_R2_001.fastq A_WT_R2_out.paired_RNA25_A3ml_ACTTGA_L003_R2_001.fastq A_WT_R2_out.paired_RNA26_A3ml_GATCAG_L003_R2_001.fastq A_WT_R2_out.paired_RNA38_A3Wl_ATCACG_L002_R2_001.fastq A_WT_R2_out.paired_RNA39_A3El_CGATGT_L002_R2_001.fastq A_WT_R2_out.paired_RNA4_A3Ef_GCCAAT_L003_R2_001.fastq A_WT_R2_out.paired_EW1_A2Mf_AGTTCC_L003_R2_001.fastq A_WT_R2_out.paired_EW3_A3Ef_CGATGT_L003_R2_001.fastq --single A_WT_R1_out.unpaired_RNA49_A3El_TAGCTT_L003_R1_001.fastq A_WT_R1_out.unpaired_RNA21_A2Mf_GCCAAT_L001_R1_001.fastq A_WT_R1_out.unpaired_RNA24_A2Ml_CAGATC_L001_R1_001.fastq A_WT_R1_out.unpaired_RNA25_A3ml_ACTTGA_L003_R1_001.fastq A_WT_R1_out.unpaired_RNA26_A3ml_GATCAG_L003_R1_001.fastq A_WT_R1_out.unpaired_RNA38_A3Wl_ATCACG_L002_R1_001.fastq A_WT_R1_out.unpaired_RNA39_A3El_CGATGT_L002_R1_001.fastq A_WT_R1_out.unpaired_RNA4_A3Ef_GCCAAT_L003_R1_001.fastq A_WT_R1_out.unpaired_EW1_A2Mf_AGTTCC_L003_R1_001.fastq A_WT_R1_out.unpaired_EW3_A3Ef_CGATGT_L003_R1_001.fastq A_WT_R2_out.unpaired_RNA49_A3El_TAGCTT_L003_R2_001.fastq A_WT_R2_out.unpaired_RNA21_A2Mf_GCCAAT_L001_R2_001.fastq A_WT_R2_out.unpaired_RNA24_A2Ml_CAGATC_L001_R2_001.fastq A_WT_R2_out.unpaired_RNA25_A3ml_ACTTGA_L003_R2_001.fastq A_WT_R2_out.unpaired_RNA26_A3ml_GATCAG_L003_R2_001.fastq A_WT_R2_out.unpaired_RNA38_A3Wl_ATCACG_L002_R2_001.fastq A_WT_R2_out.unpaired_RNA39_A3El_CGATGT_L002_R2_001.fastq A_WT_R2_out.unpaired_RNA4_A3Ef_GCCAAT_L003_R2_001.fastq A_WT_R2_out.unpaired_EW1_A2Mf_AGTTCC_L003_R2_001.fastq A_WT_R2_out.unpaired_EW3_A3Ef_CGATGT_L003_R2_001.fastq --output trinity_out_dir_altilis --full_cleanup --CPU 10 &> run_altilis.txt"; 

########################################################################################################
########################################################################################################
#
#                                  LONGEST ISOFORM
#
########################################################################################################
########################################################################################################
## this script extracts the longest isoforms from an assembly

my $file_LI= "trinity_out_dir_$species.Trinity.fasta"; 
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
	
my $outputfile2 = "LI_$species";
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

system "n50.pl LI_$species -csv > n50_report_LI_$species.txt";
my $csv = "LI_$species.csv"; #the n50 report for an individual sample
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
}

########################################################################################################
########################################################################################################
#
#                         	ORTHOLOG HIT RATIO STATS
#
########################################################################################################
########################################################################################################
system "/home/zerega/data/kristen/scripts/usearch_annotation_stats.sh LI_$species /home/zerega/data/kristen/ortholog_hit_ratio_files/csa.trans.estscan.pep.10072011.fasta > O_intermediate_file.txt";

open O_IN, "< O_intermediate_file.txt";
my ($O_line1, $O_line2_A, $O_line3_A, $O_line4_A, $O_line5_A, $O_line2_R, $O_line3_R, $O_line4_R, $O_line5_R, $O_line6_R); 
my @O_numbers;
my $O_number;

while (<O_IN>){
	$O_line1 = $_;
	if ($O_line1 =~ /Annotation/){ #Annotation Statistics
		$O_line2_A = scalar <O_IN>, $O_line3_A =scalar <O_IN>; $O_line4_A = scalar <O_IN>, $O_line5_A = scalar <O_IN>;
		push (@O_numbers, $O_line3_A, $O_line4_A, $O_line5_A);
	} 
	
	if ($O_line1 =~ /Reverse/){ #Reverse Search Statistics
		$O_line2_R = scalar <O_IN>, $O_line3_R =scalar <O_IN>; $O_line4_R = scalar <O_IN>, $O_line5_R = scalar <O_IN>, $O_line6_R = scalar <O_IN>;
		push (@O_numbers, $O_line3_R, $O_line4_R, $O_line5_R, $O_line6_R);
	}
}


foreach $O_number(@O_numbers){ #only need the numbers from the results
	$O_number =~ /(\d+\.*\d+)/; #match digit one or more times, . zero or more times, digit one or more times >>>>> so that includes whole numbers and decimals
	print CSV "$1,"
}
print CSV "\n";


close O_IN;



close IN_LI;
close INCSV;
close CSV;
close FILE;
close FILE2;

exit;
	