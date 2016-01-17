#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


#on command line: script.pl <path to directory with phy files>

opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

my $id;
my $line;
	$pep =~ /(\d+)\.phy/;
	$id = $1;
	open OUT, ">$id.fas";
	open IN, "<$pep";
	while (<IN>){
		$line = $_;
		chomp $line;
		if ($line =~ /^$id/){
			print OUT ">$line\n";
		}
		if ($line =~ /^(A|T|G|C)/){
			print OUT "$line\n"
		}
	}
	close IN;
	close OUT;
}
exit;
	