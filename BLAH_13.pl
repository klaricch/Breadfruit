#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script takes aa contig ids and pull out the matching nucleotide seq from the original assembly
#on command line script.pl <amino acid sequences of phytozome genes> <file of aa Blast results> <nucleotide assembly---protein assembly>
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
my $contig;
my $outputfile1;
my @complete_file_array;
my $complete_file;
my %seen;
my $seq;

my $file=$ARGV[0];  #amino acid sequences files of targeted genes---one file with all fve aa seqs
open IN, "< $file";
$/ =">"; while (<IN>){
	$line=$_;
	if ($line=~/fve:(\d+)(.+)K\d+(.+)(\(A\))/){
		chomp $line; #chomping off ">"
		my $file_name = $1; #assign content of $1 to a new variable becuase $1 is read only
		my $name = "fve:$file_name";
		$hash{$name} = 0;
		my $outputfile = "tree_seq_fve_$file_name.fasta";
		push (@complete_file_array, "tree_seq_fve_$file_name.fasta");
		open (FILE," > $outputfile");
		$/ = "\n";
		chomp $line;
		print FILE ">$line";
		
				open (PHYTOZOME_FINAL, ">final_phytozome_fve_$file_name.txt");
		open(PHYTOZOME, "< phytozome_fve_$file_name.txt"); #add in phytozome results
		while (<PHYTOZOME>){
			$/ =">";
			$seq=$_;
			#chomp $seq;
			unless ($seen{$seq}++) {  #phytozome sometime contains ID's and corresponding seqs that are exactly the same, preventing FastTtree from running, so only need to print one copy of such seqs
			print PHYTOZOME_FINAL "$seq";
			}
			#open close py final and print to all seq
		}
		close PHYTOZOME_FINAL; #close writable file
		open (PHYTOZOME_FINAL, "<final_phytozome_fve_$file_name.txt");    #open readable file
		while (<PHYTOZOME_FINAL>){
			print FILE $_;
		}
	}
}
$/ = "\n"; #make sure delimiter is reset

my $file3 = $ARGV[1];
open ASSEMBLYLIST, "< $file3";
my $sample_name;
my $assembly_name;
while (<ASSEMBLYLIST>){
	$assembly_name = $_;
	chomp $assembly_name;
	($sample_name)= $assembly_name=~/(RNA\d+|EW\d+)/;
	system "run_estscan.pl /home/zerega/data/kristen/assemblies/$assembly_name"; 
	system "makeblastdb -in /home/zerega/data/kristen/assemblies/$assembly_name.pep -dbtype prot -out $assembly_name.pep_database";
	system "blastp -evalue .00001 -db $assembly_name.pep_database -query /home/zerega/data/kristen/carotenoids/AminoAcidSequences_fve_carotenoid_genes_list.txt -outfmt 6 -out fve_carotenoid_blast_$sample_name.txt";

my %hash2; 
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
while (<IN2>){
	$line2 = $_;
	chomp $line2;
	if ($line2 =~ /^>/) {
		@results1 = split (/\s/,$line2);
	$contig = $results1[0];
	$contig =~ s/>//;
	if (exists $hash2{$contig}){
		for ($hash2{$contig}){s/:/_/};
		my $outputfile1 = "tree_seq_$hash2{$contig}.fasta";
		open (FILE1," +>> $outputfile1");  #"+>>" will create a file if doesn't exist but will not overwrite a file if it already exists
		$line2 =~ s/>/>$sample_name|/; #add ample name to component name so can distinguish samples on the tree		print FILE1"$line2\n";   #NEED TO ADD NEWLINE INSTEAD OF OVERWRITING
		print FILE1 scalar <IN2>;
	}
}
}
close IN1;
close IN2;
}
	
foreach $complete_file(@complete_file_array){
	system "mafft $complete_file >mafftoutput_$complete_file";    
	system "FastTree mafftoutput > Tree_$complete_file.tree";
}
#my $contiglist=join("|", @list); 

#my $file1=$ARGV[1];
#open IN1, "< $file1";

#while (<IN1>){
#	if ($_ =~/^>/ && $_ =~/$contiglist/) {
#		print FILE $_;
#		do {$line2 = scalar <IN1>;
#		print FILE $line2} until ($line2 =~/^>/);
		
		
#	}
#}

#define a line2close IN;

close FILE;
close FILE1;
close ASSEMBLYLIST;
exit;