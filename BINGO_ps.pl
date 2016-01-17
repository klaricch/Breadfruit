#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
open IN, "< $file";
my $out = "BINGO_$file";
open OUT, "> $out";

my $line;
my $id;
my %hash;
while (<IN>){
	$line = $_;
	chomp $line;
	$line =~ /(\d+)\tGO(.*)/;
	$id = $1;
	if (exists $hash{$id}){
		next;
	}

	print  OUT "$id\n";
	$hash{$id}=0;
}
close IN;
exit;
	