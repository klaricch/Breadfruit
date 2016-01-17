#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#this script takes an alignment file in phylip format, runs PAML model 0,  and pulls omega and kappa for that ortholog group
#script shoudl be should be run in parallel, output written to M0_summary.csv
#on command line: script.pl <alignment.phy>
my $pep_file = $ARGV[0];

open SUM_OUT, ">> M0_summary.csv";
my $cds_file;
my $name;
my $line;
my $omega;
my $kappa;
my $pre_omega;
my $pre_kappa;

	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	open OUT, "> codeml_M0_$name.ctl";
	open IN, "< codeml_M0.ctl";
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
			$line =~ s/mlc/M0_out_$name/;
			}
			
		print OUT "$line\n";
			}
			system "codeml codeml_M0_$name.ctl";
			$pre_omega = `grep "omega" M0_out_$name`;
			$pre_omega =~ /(\d+\.?\d+)/; #can wirte this part more concisely
			$omega = $1;
			$pre_kappa = `grep "kappa" M0_out_$name`;
			$pre_kappa =~ /(\d+\.?\d+)/;
			$kappa = $1;
			print SUM_OUT "$name,$kappa,$omega\n";
		close IN;
		close OUT;
		#system "mv $name.cds v fcvf/home/zerega/data/kristen/protein_ortho/with_reference/orthologs";
		

exit;