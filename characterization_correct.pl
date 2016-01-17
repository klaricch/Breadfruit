#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script goes through all the files in a direcotory and fixes the categorization changes
#on command line: script.pl <path to directory of files>
my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = readdir(DIR); #grep part unnecessary
closedir DIR;

my $line;foreach my $pep_file(@pep_files){
	system "mv $pep_file p_$pep_file"; #rename old version to begin with p
	open IN, "< p_$pep_file";
	open OUT, ">$pep_file"; #fixed version will retain original name so that other scripts won't be affected
	while (<IN>){
	$line = $_;
	chomp $line;
	if ($line =~ /RNA49_H3El/){
		$line =~ s/RNA49_H3El/RNA49_A3El/;
	}
		if ($line =~ /RNA34_A3Wf/){
		$line =~ s/RNA34_A3Wf/RNA34_C2Wf/;
	}
		if ($line =~ /RNA17_A3El/){
		$line =~ s/RNA17_A3El/RNA17_H3ml/;
	}
	print OUT "$line\n";
}
close IN;
}
exit;

	
	

