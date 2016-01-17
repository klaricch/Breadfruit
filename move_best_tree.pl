#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script reads an input directory and copies only ortholog groups that have a best tree output and its corresponding alignment
#file to a new directory
#useful if not all .phy files in a directory did not produce a best tree file
#on command line: script.pl <path_to_files>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/(bestTree)(.*)\.tree$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.tree/;
	$name = $1;
	system "cp $pep_file /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep1";
		system "cp $name.phy /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep1";
		}

exit;