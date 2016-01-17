#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

####ADD IN COUNT AND P VALUE
####IF SIGNIFICANT ADD IN PULL OUT BEB SITES
####IF SIGNIFICANT ADD IN PRINT TO A SUMMARY FILE

#this script takes an alignment file in phylip format and runs the branch site model on it marking each branch individually as foreground
#script should be should be run in parallel
#on command line: script.pl <alignment.phy>
my $pep_file = $ARGV[0];

#HASH
my %lane_hash =(
RNA16_H3ml => 'lane1',
RNA17_A3El => 'lane1',
RNA21_A2Mf => 'lane1',
RNA24_A2Ml => 'lane1',
RNA2_C2mf => 'lane1',
RNA32_H2Wf => 'lane1',
RNA5_C2Ef => 'lane1',
RNA7_M2mf => 'lane1',
RNA34_A3Wf => 'lane2',
RNA35_C2Mf => 'lane2',
RNA36_H2Wf => 'lane2',
RNA37_C2mf => 'lane2',
RNA38_A3Wl => 'lane2',
RNA39_A3El => 'lane2',
RNA40_H3ml => 'lane2',
RNA48_H2ml => 'lane2',
RNA10_H3El => 'lane3',
RNA25_A3ml => 'lane3',
RNA26_A3ml => 'lane3',
RNA49_H3El => 'lane3',
RNA4_A3Ef => 'lane3',
EW1_A2Mf => 'lane4', ####CHECK WHAT TO DO FOR THESE SAMPLES!
EW2_C2Mf => 'lane4',
EW3_A3Ef => 'lane4',
EW4_C2Mv => 'lane4',
);

#open SUM_OUT, ">> sites_test_summary.csv";
my $cds_file;
my $name;
my $line;
my $line_tree;

my $omega;
my $kappa;
my $pre_omega;
my $pre_kappa;
my $branch;
my $before;
my $after;
my $count =0;
my @array;
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;

	foreach my $key(keys %lane_hash){
	open IN_TREE, "< RAxML_bestTree\.$name\.tree";

		
	while (<IN_TREE>){
		$line_tree = $_; #shoudl be only one line in this file;
		if ($line_tree =~ /$key/){
			$count ++;
			push (@array, $key);
			open OUT_TREE, "> $name\_$key.tree";
			$line_tree =~ /(.*$key\_cds\.comp\d+_c\d+_seq\d+\|m\.\d+\:)(\d+.?\d+)(.*)/; 
			$before = $1;
			$after = $3;
			print "$before\n";
			print "$2\n";
			print "$after\n\n";
			$branch = $2;
			$branch =~ s/(.*)/$1 \#1/;
			print "$branch\n\n";
			print OUT_TREE "$before$branch$after";
			
			open OUT_FIXED, "> codeml_branch_site_test_fixed_$name\_$key.ctl";
			open IN_FIXED, "< codeml_branch_site_test_fixed.ctl";
			while (<IN_FIXED>){
				$line=$_;
				chomp $line;
				if ($line =~ /seqfile/){
					print "ys\n";
					$line =~ s/stewart\.aa/$pep_file/;
					}
					if ($line =~ /treefile/){
						print "ys\n";
						$line =~ s/stewart\.trees/$name\_$key\.tree/;
						}
						if ($line =~ /outfile/){
							print "ys\n";
							$line =~ s/mlc/branch_site_test_fixed_$name\_$key/;
							}
							print OUT_FIXED "$line\n";
							}
####################################################################################################
			open OUT_ESTIMATED, "> codeml_branch_site_test_estimated_$name\_$key.ctl";
			open IN_ESTIMATED, "< codeml_branch_site_test_estimated.ctl";
			while (<IN_ESTIMATED>){
				$line=$_;
				chomp $line;
				if ($line =~ /seqfile/){
					print "ys\n";
					$line =~ s/stewart\.aa/$pep_file/;
					}
					if ($line =~ /treefile/){
						print "ys\n";
						$line =~ s/stewart\.trees/$name\_$key\.tree/;
						}
						if ($line =~ /outfile/){
							print "ys\n";
							$line =~ s/mlc/branch_site_test_estimated_$name\_$key/;
							}
							print OUT_ESTIMATED "$line\n";
							}							
							system "codeml codeml_branch_site_test_fixed_$name\_$key.ctl";
							system "codeml codeml_branch_site_test_estimated_$name\_$key.ctl";
							close IN_FIXED;
							close OUT_FIXED;
							close IN_ESTIMATED;
							close OUT_ESTIMATED;
							}
	}
	close IN_TREE;
	close OUT_TREE;
}

my $key2;
my $likelihood1;
my $likelihood2;
my $lnL1;
my $lnL2;
my $chi2_value;foreach $key2(@array){
	$likelihood1 = `grep "lnL" branch_site_test_fixed_$name\_$key2`; #or can use grep -m 1 
	$likelihood2 = `grep "lnL" branch_site_test_estimated_$name\_$key2`;

	$likelihood1 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL1 = $1;
	print "$lnL1\n";
	$likelihood2 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL2 = $1;
	print "$lnL2\n";
	$chi2_value = $lnL2-$lnL1;
	print "$chi2_value\n\n";
}
exit;
	#open OUT, "> codeml_sites_test_1_2_$name.ctl";
	#open IN, "< codeml_sites_test_1_2.ctl";
	#while (<IN>){
	#	$line=$_;
	#	chomp $line;
	#	if ($line =~ /seqfile/){
	#		print "ys\n";
	#		$line =~ s/stewart\.aa/$pep_file/;
	#		}
	#		if ($line =~ /treefile/){
	#		print "ys\n";
	#		$line =~ s/stewart\.trees/RAxML_bestTree\.$name\.tree/;
	#		}
	#		if ($line =~ /outfile/){
	#		print "ys\n";
	#		$line =~ s/mlc/sites_test_out_1_2_$name/;
	#		}
	#		
	#	print OUT "$line\n";
	#		}
	#		system "codeml codeml_sites_test_1_2_$name.ctl";
			#$pre_omega = `grep "omega" M0_out_$name`;
			#$pre_omega =~ /(\d+\.?\d+)/; #can wirte this part more concisely
			#$omega = $1;
			#$pre_kappa = `grep "kappa" M0_out_$name`;
			#$pre_kappa =~ /(\d+\.?\d+)/;
			#$kappa = $1;
			#print SUM_OUT "$name,$kappa,$omega\n";
	#	close IN;
	#	close OUT;
	#}

		

exit;