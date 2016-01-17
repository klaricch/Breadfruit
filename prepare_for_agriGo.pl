#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#final set to prepare for agrigo...for each GO term of an ortholog ID; put the GO term on its own line matched with the ortholog ID
#scriplt.pl <agriGO_annotation_report>
my $file;$file = $ARGV[0];
open IN, "< $file";
my $count = 0;

open OUT, ">agriGO_reference_set.txt";
my $line;
my @results;
my $contig;
my $element;
my @annotations;
my $annotation;while (<IN>){
	$line = $_;
	chomp $line;

	@results = split(/\t/,$line);
	$contig = $results[0];
	foreach $element(@results){
		if ($element =~ /GO/){
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
	
	