#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file3 = $ARGV[0];
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
}

close ASSEMBLYLIST;
exit;