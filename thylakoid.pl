#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $file = $ARGV[0];
my $file2 = $ARGV[1];
open IN, "<$file";
my $line;
my @results;
my $gene_column;
my @genes;
my %hash;
my $ortholog;
my $line2;
my @results2;
my $blast_field;
my @blast_info;
my $b1;
my $b2;
my $gene_id;
my $description;
my $id;
while (<IN>) { 
	$line = $_;
	chomp $line;
	@results = split(/,/, $line);
	$ortholog = $results[0];
	open ORTH, ">$ortholog\_blast_description.csv";
	$gene_column = $results[10];
	@genes = split(/\|/,$gene_column);
	foreach my $gene(@genes){
		$hash{$gene} = 0;
	}
	 
	open IN2, "<$file2";

while (<IN2>){
	$line2=$_;
	@results2= split(/\t/, $line2);
	$id = $results2[0];
	my $blast_field = $results2[3];
	@blast_info = split(/\^/, $blast_field);
	$b1 = $blast_info[0];
	$b1 =~ /sp\|.*\|(.*)/;
	$gene_id = $1;
	$b2 = $blast_info[5];
	$b2=~ /.*Full\=(.*);/;
	$description = $1;
	if (exists $hash{$id}) {
		print ORTH "$id,$gene_id,$description\n";
	}
}
close IN2;
close ORTHO;
%hash =();
@genes=();

}



	

close IN;

exit;