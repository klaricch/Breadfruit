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
my $outputfile = "MERRRR2.txt";
open FILE, "> $outputfile";
$/ =">"; while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		my $name = "fve:$file_name";
		$line =~ s/:/_/;
		chomp $line;
		$hash{$name} = 0;
		chomp $line;
		print FILE ">$line";
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
	open OUTCAR, "> fve_carotenoid_blast_$sample_name.csv";
	while (<CAR>){
		#$_=~s/\t/,/;
		my @results_car = split(/\t/,$_);
		my $length_car = $results_car[3];
		if ($length_car >= 100){
			$_=~ s/\t/,/g;
			print OUTCAR "$_";
		}
	}
	close CAR;
	close OUTCAR;


my %hash2;##################################################################################################
##################################################################################################
#
#			ADD CONTIGS HIT BY BLAST SEARCH TO THE FINAL FILE
#
##################################################################################################
##################################################################################################
open IN1, "<fve_carotenoid_blast_$sample_name.txt"; #blast results table
while (<IN1>) {
	$line1 = $_;
	chomp $line1;
	@results = split (/\t/,$line1);
	$fvegeneID = $results[0]; 
	$contigID = $results[1];                      
	if (exists $hash{$fvegeneID}){
		$hash2{$contigID} = $fvegeneID;
		 push (@list, $contigID)};                       
}
 
open IN2, " < /home/zerega/data/kristen/assemblies/$assembly_name.pep"; # longest isoform contig assembly (amino acid .pep version)
$/ =">";
while (<IN2>){
	$line2 = $_;
	chomp $line2;
		@results1 = split (/\s/,$line2);
	my $contig = $results1[0];
	
	if (exists $hash2{$contig}){
		$line2 =~ s/^comp/>$sample_name|comp/; #add sample name to component name so can distinguish samples on the tree		
				print FILE"$line2"; 
	}
}

close IN1;
close IN2;
$/ ="\n";
}
}

##################################################################################################
##################################################################################################
#
#			MAFFT and FAST TREE
###################################################################################################
##################################################################################################	

	system "mafft $outputfile >mafftoutput_$outputfile";    
	system "FastTree mafftoutput_$outputfile > Tree_$outputfile.tree";
close IN;

close FILE;
close ASSEMBLYLIST;
exit;