#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $seq;
my %seen;

	open (PHYTOZOME_FINAL, ">final_phytozome_fve_101290784.txt");
		open(PHYTOZOME, "< phytozome_fve_101290784.txt"); #add in phytozome results
		while (<PHYTOZOME>){
			$/ =">";
			$seq=$_;
			#chomp $seq;
			unless ($seen{$seq}++) {
			print PHYTOZOME_FINAL "$seq";
			}
			#open close py final and print to all seq
		}

close PHYTOZOME_FINAL;
close PHYTOZOME;
exit;