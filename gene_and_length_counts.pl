#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

my %gene_hash =(
RNA16_H3ml => 0,
RNA17_A3El => 0,
RNA21_A2Mf => 0,
RNA24_A2Ml => 0,
RNA2_C2mf => 0,
RNA32_H2Wf => 0,
RNA5_C2Ef => 0,
RNA7_M2mf => 0,
RNA34_A3Wf => 0,
RNA35_C2Mf => 0,
RNA36_H2Wf => 0,
RNA37_C2mf => 0,
RNA38_A3Wl => 0,
RNA39_A3El => 0,
RNA40_H3ml => 0,
RNA48_H2ml => 0,
RNA10_H3El => 0,
RNA25_A3ml => 0,
RNA26_A3ml => 0,
RNA49_H3El => 0,
RNA4_A3Ef => 0,
EW1_A2Mf => 0, 
EW2_C2Mf => 0,
EW3_A3Ef => 0,
EW4_C2Mv => 0,
);

my %sites_hash =(
RNA16_H3ml => 0,
RNA17_A3El => 0,
RNA21_A2Mf => 0,
RNA24_A2Ml => 0,
RNA2_C2mf => 0,
RNA32_H2Wf => 0,
RNA5_C2Ef => 0,
RNA7_M2mf => 0,
RNA34_A3Wf => 0,
RNA35_C2Mf => 0,
RNA36_H2Wf => 0,
RNA37_C2mf => 0,
RNA38_A3Wl => 0,
RNA39_A3El => 0,
RNA40_H3ml => 0,
RNA48_H2ml => 0,
RNA10_H3El => 0,
RNA25_A3ml => 0,
RNA26_A3ml => 0,
RNA49_H3El => 0,
RNA4_A3Ef => 0,
EW1_A2Mf => 0, 
EW2_C2Mf => 0,
EW3_A3Ef => 0,
EW4_C2Mv => 0,
);

open OUT, ">total_counts_summary.csv";
my $length;foreach my $pep(@pep_files){
	foreach my $key(keys %gene_hash){
		if (`grep -c "$key" $pep`==1){
			$gene_hash{$key}++;
			open IN, "$pep";
			while (<IN>){
				chomp $_;
				if (3..3){$length=length $_;
				}
			}
			$sites_hash{$key} = $sites_hash{$key}+$length;
		}
		close IN;
	}
}

foreach my $item(sort keys %gene_hash){
	print OUT "$item,$gene_hash{$item},$sites_hash{$item}\n";
}
exit;

	