#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


##################################################################################################
##################################################################################################
#
#			RUN_ESTCAN and BLASTP
#
##################################################################################################
##################################################################################################

my $file = $ARGV[0];
my $line1;
my $contigID;
my $fvegeneID;
my @list;
my @results;
my $line2;
my @results1;
my $contig;
open ASSEMBLYLIST, "< $file" or die "can't open $!";
my $sample_name;
my $assembly_name;
while (<ASSEMBLYLIST>){
	$assembly_name = $_;
	chomp $assembly_name;
	if ($assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/){($sample_name)= $assembly_name=~/(RNA\d+_\w\d\w|EW\d+_\w\d\w)/};# "if" statement to ensure its defined
	#print "$assembly_name\n";
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
		close INC;
		close OUTC;
		my %hash2 = ();
		open IN1, "<SORTED_fve_carotenoid_blast_$sample_name.txt" or die "can't open$!"; #blast results table
		while (<IN1>) {
			$line1 = $_;
			chomp $line1;
			@results = split (/\t/,$line1);
			$fvegeneID = $results[0]; 
			$contigID = $results[1]; 
			unless (exists $hash2{$contigID}){ # only want to add the first instance of the contig, so if a key for one already exists, just skip it
			$hash2{$contigID} = $fvegeneID;
			push (@list, $contigID)
			}
		}
		print "$sample_name\n";
		#foreach (@list){print "$_\n"};
		foreach (sort keys %hash2){
			print "$_\t$hash2{$_}\n";
		};
		close IN1;
		#chomp "/home/zerega/data/kristen/assemblies/$assembly_name.pep";
		open IN2, " < $assembly_name.pep" or die "can't open $!"; # longest isoform contig assembly (amino acid .pep version)
		
		while (<IN2>){
			$/ =">";
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
			$/ ="\n";
			close IN2;
		}



exit;
	