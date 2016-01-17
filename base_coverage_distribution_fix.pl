#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $coverage_file = $ARGV[0];
open OUT, "> coverage_file_for_R.csv";
#keep adding to previous amount

my @array = (0..500);
foreach my $number(@array){
	$hash{$number} = 0;
}
print @array;


my $line;
my $coverage;
my $count;
my $filtered;
my @results;
while (<IN>){
	$line = $_;
	chomp $line;
	@results = split (/\s+/, $line);
	$coverage = $results[1]; #start at 1 instead of 0 because the file starts with spaces
	print "$coverage\n";
	$count = $results[2];
	$filtered = $results[3];
	if (exists $hash{$coverage}){ #give the hash a count, if the coverage no. doesn't exist in the file, it will remain zero
		$hash{$coverage} = $count;
	} 
	if ($coverage > 500){
		$cumulative = $cumulative + $count;
	}
}




	print OUT "$key,$hash{$key}\n";
}

close IN;
close OUT;
exit;
	
	
	
	