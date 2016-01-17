#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#this script takes the output files from Paml's M1 M2 test, compares the likelihoods, and moves the alignment,tree, and output files
#indicating positive selection at p<=.05 to a new directory
#on command line: script.pl <path_to_directory>
my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
my $likelihood1;
my $lnL1;
my $likelihood2;
my $chi2_value;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	$likelihood1 = `awk '/lnL/{i++}i==1{print; exit}' sites_test_out_7_8_$name`; #or can use grep -m 1 
	$likelihood2 = `awk '/lnL/{i++}i==2{print; exit}' sites_test_out_7_8_$name`;
	print "$likelihood1";
	print "$likelihood2";
	$likelihood1 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL1 = $1;
	print "$lnL1\n";
	$likelihood2 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL2 = $1;
	print "$lnL2\n";
	$chi2_value = $lnL2-$lnL1;
	print "$chi2_value\n\n";
	
	if ($chi2_value >= 5.9915){ #chi2 with two degrees freedom p<= .05 significance 
		system "cp $name\.phy /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/survive_M1_M2_M7_M8/ref_test/survive";
		system "cp sites_test_out_7_8_$name /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/survive_M1_M2_M7_M8/ref_test/survive";
		system "cp RAxML_bestTree\.$name\.tree /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/survive_M1_M2_M7_M8/ref_test/survive";
	}
} 
exit;
