#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $line;
my $list = $ARGV[0];
open IN, "< $list";
while (<IN>){
	$line=$_;
	chomp $line;
	system "FastTree $line > Tree_$line.tree";
}
close IN;
exit;