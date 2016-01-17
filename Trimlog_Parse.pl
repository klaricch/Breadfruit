#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
open IN, "<$file";

my $line;
my $read_length;
my $trim_start;
my @results;
my $adapter_trim_count = 0;
my $trim_start_count = 0;
while (<IN>) {
	$line = $_;
	chomp $line;
	@results = split (/\s/, $line);
	$read_length = $results[2];
	$trim_start = $results[3];
	if ($read_length !~ 101){
		$adapter_trim_count++;
	}
	if ($trim_start !~ 0) {
		$trim_start_count = 0;
	}

}

print "$adapter_trim_count\n";
print "$trim_start_count\n";exit;
	