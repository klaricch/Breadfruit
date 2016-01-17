#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script prepares the nexus file for phylonet
# on command line" script.pl <path to gene trees>my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @gene_files = readdir(DIR); #grep part unnecessary
closedir DIR;
my $id;
my $line;

open OUT, ">test.nex";
print OUT "#NEXUS\n\nBEGIN TREES;\n\n";foreach my $gene(@gene_files){
	$gene =~ /(\d+)_raxml/;
	$id = $1;
	print OUT "TREE $id = ";
	#system "cp /data/species_trees/gene_trees/$gene .";
	open IN, "< /data/species_trees/gene_trees/$gene";
	while (<IN>){
		$line =$_;
		chomp $line;
		print OUT "$line\n";
	}
	close IN;
}

print OUT "END;\n\nBEGIN PHYLONET;\n\n";
close OUT;
#stuff

print OUT "END;"