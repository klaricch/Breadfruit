#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $coverage_file = $ARGV[0];open IN, "< $coverage_file";
open OUT, "> coverage_file_for_R.csv";
#keep adding to previous amount
my %hash;
my @array = (0..500);
foreach my $number(@array){
	$hash{$number} = 0;
}
print @array;

my $cumulative=0;
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
print "$cumulative\n";
#$hash{501} = $cumulative; #don't really want this point in our plot

foreach my $key(sort {$a<=>$b} keys %hash){ #{$a<=>$b} is necessary for numerical sorting
	print OUT "$key,$hash{$key}\n";
}

close IN;
close OUT;
exit;
	
	
	
	