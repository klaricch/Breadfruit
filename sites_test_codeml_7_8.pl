#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#this script takes an alignment file in phylip format, runs PAML model 0,  and pulls omega and kappa for that ortholog group
#script shoudl be should be run in parallel, output written to M0_summary.csv
#on command line: script.pl <alignment.phy>
my $pep_file = $ARGV[0];

#open SUM_OUT, ">> sites_test_summary.csv";
my $cds_file;
my $name;
my $line;
my $omega;
my $kappa;
my $pre_omega;
my $pre_kappa;

	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	open OUT, "> codeml_sites_test_7_8_$name.ctl";
	open IN, "< codeml_sites_test_7_8.ctl";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ /seqfile/){
			print "ys\n";
			$line =~ s/stewart\.aa/$pep_file/;
			}
			if ($line =~ /treefile/){
			print "ys\n";
			$line =~ s/stewart\.trees/RAxML_bestTree\.$name\.tree/;
			}
			if ($line =~ /outfile/){
			print "ys\n";
			$line =~ s/mlc/sites_test_out_7_8_$name/;
			}
			
		print OUT "$line\n";
			}
			system "codeml codeml_sites_test_7_8_$name.ctl";

		close IN;
		close OUT;

		

exit;