#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script runs mafft (aa alignment) and pal2nal (aa assisted nuc alignment) and outputs the alignment in paml format
# on command line: script.pl <path_to_pep_and_cds_files>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.pep$/,readdir(DIR));
my @cds_files = grep(/\.cds$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;foreach my $pep_file (@pep_files) { 
	system "mafft --thread 10 $pep_file> aligned_$pep_file.aln"; 
	$pep_file =~ /(.*)\.pep/;
	$name = $1;
	$cds_file = "$name.cds";
	system "pal2nal.pl aligned_$pep_file.aln $cds_file -output paml -nogap > paml_ready_$name.txt";
	
	
}

#-no mistach?
exit;