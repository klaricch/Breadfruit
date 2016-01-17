#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

##DONE!!!!

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @file= readdir DIR;
closedir DIR;

my @sample;my $sample;
push (@sample,
		"EW1",
		"EW2",
		"EW3",
		"EW4",
		"RNA10", 
		"RNA16",
		"RNA17",
		"RNA21",
		"RNA24",
		"RNA25",
		"RNA26",
		"RNA32",
		"RNA34",
		"RNA35",
		#"RNA36",
		"RNA37",
		"RNA38", 
		"RNA39",
		"RNA40",
		"RNA48",
		"RNA49",
		"RNA2",
		"RNA4",
		"RNA5",
		"RNA7"
		);





my %keep_hash;my @files_to_keep = @file;
foreach my $file (@file){
	$keep_hash{$file} = 0
}
my $grep_value;
my $key;

foreach my $file (@file) { 
	foreach $sample(@sample){
		print "$sample\n";
		$grep_value = `grep $sample $file`;
		if ($grep_value =~ /$sample/){
			print "YAY\n"} else{
				delete $keep_hash{$file};
				}
			}
		};
foreach $key (keys %keep_hash){
	system "cp $key minus36_kept";
}

				
exit;
