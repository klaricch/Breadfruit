#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
open LIST, "< $file";

my $line;
my @results;
my $fveID;
my @fve_list;
my $fve; 
my %seen;
push(@fve_list,"fve\:101290784",
		"fve\:101292752",
		"fve\:101292810",
		"fve\:101293791",
		"fve\:101294153",
		"fve\:101295928",
		"fve\:101296114",
		"fve\:101297853",
		"fve\:101297926",
		"fve\:101299092",
		"fve\:101299429",
		"fve\:101300786",
		"fve\:101301466",
		"fve\:101302159",
		"fve\:101303237",
		"fve\:101304444",
		"fve\:101304999",
		"fve\:101306058",
		"fve\:101306850",
		"fve\:101308016",
		"fve\:101308227",
		"fve\:101309436",
		"fve\:101311145",
		"fve\:101311757",
		"fve\:101311997",
		"fve\:101315210",
		"fve\:101315223"
		);

my $column_names= join( ',', @fve_list );
open CSV, "> fve_gene_count.csv";
print CSV "sample,$column_names\n";
while (<LIST>){
	chomp;
	print "$_\n";
	open IN, "< $_";
	print CSV "$_,";
while (<IN>){
	$line= $_;
	chomp $line;
	@results = split(/\t/,$line);
	$fveID = $results[0];
	$seen{$fveID}++;
}

foreach (@fve_list){
	if (exists $seen{$_}){
		print CSV "$seen{$_},";
	}
	else{
		print CSV "0,";
	}
	$seen{$_} = 0; #reset the counter
}
print CSV "\n";
}close IN;
exit;