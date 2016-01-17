#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file_name= $ARGV[0];
my $seq;
my %seen;

open (FINAL, ">FINAL_$file_name");
open(CURRENT, "< $file_name"); 
		while (<CURRENT>){
			$/ =">";
			$seq=$_;
			$seq=~s/fve\:/fve_/;
			#chomp $seq;
			unless ($seen{$seq}++) {  
			print FINAL "$seq";
			}
		}
		close FINAL;
		close CURRENT;
		exit;