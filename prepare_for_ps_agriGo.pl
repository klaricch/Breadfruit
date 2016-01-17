#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#final set to prepare for agrigo by put each on its own line along with its identifier
#scriplt.pl <agriGO_annotation_report>
my $file;
open IN, "< $file";
my $count = 0;



my @results;
my $contig;
my $element;
my @annotations;
my $annotation;
	$line = $_;
	chomp $line;

	@results = split(/\t/,$line);
	$contig = $results[0];
	foreach $element(@results){
		if ($element =~ /GO\:/){
			push (@annotations, $element);
		}
	}
	foreach $annotation(@annotations){
		print OUT "$contig\t$annotation\n";
	}
	 @annotations=();
	
}
close IN;
exit;
	
	