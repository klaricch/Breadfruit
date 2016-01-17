#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
$file =~ /(\d+)_fix\.(.*)/;
open IN, "< $file";
open OUT, " > $1\.$2";
my $line;

$/= ">";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />/){
			$line =~ s/>//;
			}
		if ($line =~ /LI_altilis|RNA4_/){
			next;
		} else{
		
		
		
			print OUT ">$line";
		}
			}
		close IN;
		close OUT;
		$/= "\n"; #maybe unneccessay
		system "mv $1\.$2 /home/zerega/data/kristen/protein_ortho/with_reference/orthologs/fix2";
		
