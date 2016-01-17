#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script reads the file names of a provided list, unzips them, and transfer them
#on command line: script.pl <file with names of paired end reads (pairs separated by tabs)>

my $dir = $ARGV[0];
my $file;
my $unzipped_file;

opendir DH, $dir or die "Cannot open $dir : $!";
foreach $file (readdir DH){
	if ($file =~ /.gz$/){
	system "gunzip $file";
	$file =~ s/\.gz//;
	system "lftp sftp://kristen:moraceae\@10.0.8.1 -e 'cd homes/kristen/original_samples; put $file;bye'";
	system "rm $file";
}
}


closedir DH;
exit;