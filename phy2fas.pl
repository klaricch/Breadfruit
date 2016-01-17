#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script convert phylip alignments to fasta format
#on command line: script.pl <path to directory with phy files>
my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

my $id;
my $line;foreach my $pep(@pep_files){
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
	