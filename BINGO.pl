#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
open IN, "< $file";
my $out = "BINGO_$file";
open OUT, "> $out";

print OUT "(species=Custom_species)(type=biological_process)(curator=GO)\n";
my $line;
while (<IN>){
	$line = $_;
	chomp $line;
	$line =~ s/\tGO\:/=/;
	print  OUT "$line\n";
}
close IN;
exit;
	