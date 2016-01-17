#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script takes the grabprotein proteinortho nuc output in fasta format, removes extra ">"s on the first line, adds .cds extension and moves the file
#on command line: script.pl <path_to_grabprotein_nuc_output>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.fasta$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.fasta/;
	$name = $1;
	open OUT, "> $name.cds";
	open IN, "< $pep_file";
	$/= ">";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />/){
			$line =~ s/>//;
			}
		
		
		
			print OUT ">$name\_$line";
			}
		close IN;
		close OUT;
		$/= "\n"; #maybe unneccessay
		system "mv $name.cds /home/zerega/data/kristen/protein_ortho/with_reference/orthologs";
		}

exit;