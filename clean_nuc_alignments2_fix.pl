#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#this script takes the pal2nal output alignemnt files and moves files that dont contain all blank sequences (from 100% overlap
# of pal2nals remove gaps option) to a new directory and fixes > in the file
#on command line: script.pl <path_to_pal2nal_output_files>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.txt$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
my $too_many_gaps = 0;
foreach my $pep_file (@pep_files) {
	$too_many_gaps = 0;
	$pep_file =~ /(\d+)\.txt/;
	$name = $1;
	open OUT, "> $name.paml";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />/){
			$line =~ />(.*)/;
			print OUT "$1\n";
			} else {
				print OUT "$line\n"
			}
			if ($line =~ /^$/){$too_many_gaps = 1}
		}
		
		if ($too_many_gaps == 0){

		system "mv $name.paml /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/fix";
	
	}
		}

exit;