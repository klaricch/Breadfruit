#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @estimated_files = grep(/estimated/,readdir(DIR));
closedir DIR;

opendir DIR, $dir or die "cannot open dir $dir: $!";
my @phy_files = grep(/phy/,readdir(DIR));
closedir DIR;


open OUT, ">fishers_prep_file.csv";

print OUT "sample,";foreach my $gene(@phy_files){
	print OUT "G$gene,";
}
print OUT "\n";

my %estimated_hash;
my $name;foreach my $es(@estimated_files){
	$es =~ /estimated_(\d+_(RNA\d+_\w\d\w|EW\d+_\w\d\w))/;
	$name =$1;
	$estimated_hash{$name} =0;
}
	
	#########24 and 34 problem##################

#HASH
my %lane_hash =(
RNA16_H3m => 'lane1',
RNA17_A3E => 'lane1',
RNA21_A2M => 'lane1',
RNA24_A2M => 'lane1',
RNA2_C2m => 'lane1',
RNA32_H2W => 'lane1',
RNA5_C2E => 'lane1',
RNA7_M2m => 'lane1',
RNA34_A3W => 'lane2',
RNA35_C2M => 'lane2',
RNA36_H2W => 'lane2',
RNA37_C2m => 'lane2',
RNA38_A3W => 'lane2',
RNA39_A3E => 'lane2',
RNA40_H3m => 'lane2',
RNA48_H2m => 'lane2',
RNA10_H3E => 'lane3',
RNA25_A3m => 'lane3',
RNA26_A3m => 'lane3',
RNA49_H3E => 'lane3',
EW1_A2M => 'lane4', 
EW2_C2M => 'lane4',
EW3_A3E => 'lane4',
EW4_C2M => 'lane4',
);
my $ob;
my $id;
foreach my $sample(keys %lane_hash){
	print OUT "$sample,";
	foreach my $phy(@phy_files){ #have to sort this or no?
	$phy =~ /(\d+)\.phy/;
	$id = $1;
	
	$ob = "$id\_$sample";
		if (`grep -c "$sample" $phy`==1){
			if (exists $estimated_hash{$ob}){ #need to include gene name in this
				print OUT "1,"
			}
			else {
				print OUT "0,";
			}
		}
		else {
			print OUT "blank,";
			}
		}
		print OUT "\n";
	}
	exit;

	
		