#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script:
#translates the longest isoform nucleotide assemblies into protein assmeblies and creates a blast database of the results
#takes a file of a.a seqeunces (such as fve carotenoid transcripts) and uses them as a query to blast against the assemblies
#combines the a.a. seq file,the results from blasting each a.a seq in pytozome, and the results of blasting against the assembly
#runs mafft and FastTree on the final combined file to later be visualized in FigTree
#on command line script.pl <a.a seqs of genes of interest> <list of nuc assemblies to be used> #requires pre-existing separate files of a.a. seq of phytozome individuals per each gene of interest

my @list;
my $fvegeneID;
my $contigID;
my @results;
my $line;
my $line1;
my $line2;
my $line3;
my %hash;
my @results1;
#my $contig;
my $outputfile1;
my @complete_file_array;
my $complete_file;
my %seen;
my $seq;

##################################################################################################
##################################################################################################
#
#			FILE ORGANIZATION and ADD IN PHYTOZOME RESULTS
#
##################################################################################################
##################################################################################################
my $file;
$file=$ARGV[0];  #amino acid sequences files of targeted genes---ex:one file with all fve aa seqs
open IN, "< $file";
$/ =">"; while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		my $name = "fve:$file_name";
		chomp $line;
		$hash{$name} = 0;
		my $outputfile = "all_seq_fve_$file_name.fasta";
		push (@complete_file_array, "all_seq_fve_$file_name.fasta");
		open (FILE," > $outputfile");
		$/ = "\n";
		chomp $line;
		print FILE ">$line";
		
				
		open(PHYTOZOME, "< phytozome_fve_$file_name.txt"); #add in phytozome results
		while (<PHYTOZOME>){
			$/ =">";
			print FILE "$_"; #print to the complete seqs file
		}
	}
}
$/ = "\n"; #make sure delimiter is reset


##################################################################################################
##################################################################################################
#
#			RUN_ESTCAN and BLASTP
#
##################################################################################################
##################################################################################################
my $file3 = $ARGV[1];
open ASSEMBLYLIST, "< $file3";
my $sample_name;
my $assembly_name;
while (<ASSEMBLYLIST>){
	$assembly_name = $_;
	chomp $assembly_name;
	if ($assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/){($sample_name)= $assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/;# "if" statement to ensure its defined
	print $sample_name;
	#system "run_estscan.pl /home/zerega/data/kristen/assemblies/$assembly_name"; 
	#system "makeblastdb -in /home/zerega/data/kristen/assemblies/$assembly_name.pep -dbtype prot -out $assembly_name.pep_database";
	system "blastp -evalue .00000000000000000001 -db $assembly_name.pep_database -query /home/zerega/data/kristen/carotenoids/AminoAcidSequences_fve_carotenoid_genes_list.txt -outfmt 6 -out pre_fve_carotenoid_blast_$sample_name.txt";
	open CAR, "< pre_fve_carotenoid_blast_$sample_name.txt";
	open OUTCAR, "> fve_carotenoid_blast_$sample_name.txt";
	while (<CAR>){
		my @results_car = split(/\t/,$_);
		my $length_car = $results_car[3];
		if ($length_car >= 100){
			print OUTCAR "$_";
		}
	}
	close CAR;
	close OUTCAR;

##################################################################################################
##################################################################################################
#
#			ADD CONTIGS HIT BY BLAST SEARCH TO THE FINAL FILE
#
##################################################################################################
##################################################################################################

open INC, "<fve_carotenoid_blast_$sample_name.txt"; #blast results table
my $outputfileC = "SORTED_fve_carotenoid_blast_$sample_name.txt";
open OUTC, "> $outputfileC";
my $lineC;
my @resultsC;
my $evalueC;
my %hashC;

while (<INC>){
	$lineC=$_;
	chomp $lineC;
	@resultsC = (split /\t/, $lineC);
	$evalueC = $resultsC[10]; #this column is the evalue
	$hashC{$evalueC} = $lineC;
}

foreach (sort { $a <=> $b } keys(%hashC) ) #sort the blast file based on evalue
{
    print OUTC "$hashC{$_}\n"; #printed the sorted results
}
my %hash2 = ();open IN1, "<SORTED_fve_carotenoid_blast_$sample_name.txt"; #blast results table
while (<IN1>) {
	$line1 = $_;
	chomp $line1;
	@results = split (/\t/,$line1);
	$fvegeneID = $results[0]; 
	$contigID = $results[1];  
	if (exists $hash{$fvegeneID}){
	unless (exists $hash2{$contigID}){ # only want to add the first instance of the contig, so if a key for one already exists, just skip it
		$hash2{$contigID} = $fvegeneID;
		 push (@list, $contigID)
		 }
	} 
      
		
		                       
}
 
 print "KEYS";
print keys %hash2;
print "\n";
open IN2, " < /home/zerega/data/kristen/assemblies/$assembly_name.pep"; # longest isoform contig assembly (amino acid .pep version)
$/ =">";
while (<IN2>){
	$line2 = $_;
	chomp $line2;
		@results1 = split (/\s/,$line2);
	my $contig = $results1[0];
	
	if (exists $hash2{$contig}){
		for ($hash2{$contig}){s/:/_/}; #change fve:### to fve_### so that can go to appropriately named file
		my $outputfile1 = "all_seq_$hash2{$contig}.fasta";
		open (FILE1," +>> $outputfile1");  #"+>>" will create a file if doesn't exist but will not overwrite a file if it already exists
		$line2 =~ s/^comp/>$sample_name|comp/; #add sample name to component name so can distinguish samples on the tree		
				print FILE1"$line2"; 
	}
}

close IN1;
close IN2;
$/ ="\n";
}
}

#THEN MERGE THEN DO THE FOLLOWING
##################################################################################################
##################################################################################################
#
#			MAFFT and FAST TREE
###################################################################################################
##################################################################################################	
#foreach $complete_file(@complete_file_array){
#	system "mafft $complete_file >mafftoutput_$complete_file";    
#	system "FastTree mafftoutput_$complete_file > Tree_$complete_file.tree";
#}
close IN;

close FILE;
close FILE1;
close ASSEMBLYLIST;
exit;