#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script fixes newline characters in the pal2nal paml output files so that the phylip file is correctly formatted for use with RAxML and moves them
#on command line: script.pl <path_to_pal2nal_output_fixed_paml_files>

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.paml$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /([0-9]+)\.paml/;
	$name = $1;
	open OUT, "> $name.phy";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ /^\d+/){
			print OUT "\n$line\n";
			} else {
		
		
		
			print OUT "$line";
		}
			}
		close IN;
		close OUT;
		system "mv $name.phy /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files";
		}

exit;