#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;



open IN, "< $list";
while (<IN>){
	$line=$_;
	chomp $line;
	system "FastTree $line > Tree_$line.tree";
}
close IN;
exit;