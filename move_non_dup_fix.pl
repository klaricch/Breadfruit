#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#this script moves phylip alignment files and their best tree result as long as the sequences in the alignment files are not all exactly identical
#on command line: script.pl <path-to_files>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
my %seen;
my $duplicates;  
my $total_seqs;
foreach my $pep_file (@pep_files) {
	$duplicates = 1;#start at 1, not 0 so that the first duplciate is counted as 2
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	open IN, "< $pep_file";
	while (<IN>){
		
		$line=$_;
		chomp $line;
		if (1..1){ #want to pull on the first numebr on line one, which is the number fo sequences
		$line =~ /\s+(\d+)\s+/;
		$total_seqs = $1;
		}
		if ($seen{$line}++) {$duplicates++};
	}
	if ($total_seqs != $duplicates) { #dont want to copy the file over if the duplicate # of seqs equals the total # of seqs
		
		
			

		system "cp $name.phy /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/fix";
		system "cp RAxML_bestTree\.$name\.tree /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/fix";
	};

		
				close IN;
	}

exit;