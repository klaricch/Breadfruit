#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

## this script takes a trinotate annotation report xls file and a directory as and outputs the count of how many ortholog groups contain
## a transcript from the reference assmebly that has recieved a GO term (tell if the ortholog group is annotated)
## on command line: script.pl <annotation report> <path_to_ortholog_groups>

my $annotation_report = $ARGV[0];
my $line;
my @columns;
my $prot_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;




my %hash;
my $key;



open IN, "< $annotation_report";

while (<IN>){
	$line=$_;
	chomp $line;
	@columns = split (/\t/, $line);
	$prot_ID = $columns[4];
	$gene_ontology = $columns[11];

	
	if ($prot_ID =~ /prot/) { #don't include header
		next;
	}
	if ($gene_ontology =~ /^\./) { #don't include transcripts without GO annotations
		next;
	}
	$hash{$prot_ID} =0;
	

	

}



###########################################################
###########################################################

my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line2;
my $key2;
my %hash2;
my $count=0;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	foreach $key2(keys %hash){
		$key2 =~ s/cds/$name\_cds/;
		#print "$key2\n";
		$hash2{$key2} =0;
	}

	open IN2, "< $pep_file";
	while (<IN2>){
		$line2=$_;
		chomp $line2;
		if ($line2 =~ /^$name\_c/){
			#print "$line2\n";
		if (exists $hash2{$line2}){
			$count++;
		}
	}

		
	
		}
		close IN2;
	}


close IN;
print "$count\n";

exit;
	