#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.paml$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
my $too_many_gaps = 0;
foreach my $pep_file (@pep_files) {
	$too_many_gaps = 0;
	$pep_file =~ /(\d+)\.paml/;
	$name = $1;
	open OUT, "> $name.fasta";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ /^(\d+)/){

			print OUT "\n$line  ";
			} else {
				print OUT "$line"
			}
		}


		system "mv $name.fasta /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/test/blergh";
	
	}
close IN;
close OUT;

exit;