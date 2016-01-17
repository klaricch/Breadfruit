#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script reads the file names of the current directory and outputs them to a text file
#on command line: Files.pl

my $file;
my $outputfile = "List_of_Samples.txt";
open (FILE, "> $outputfile");
my $dir = $ARGV[0];
my %file_hash;


opendir DH, $dir or die "Cannot open $dir : $!";
foreach $file (readdir DH){
	if ($file =~ /.gz$/){ 
	$file =~ s/.gz//; #don't want the gunzipped files in this list
	$file_hash{$file} = 0;
	
}
}

foreach (sort keys %file_hash) 
{
    print FILE "$_\n";
}

closedir DH;
exit;