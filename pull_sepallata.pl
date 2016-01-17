#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#takes the ortholog annotation key, pulls out ortholog ID of any gene that matches "SEPATALLA" in the best
#blast hit column, goes through the .phy files of the given directpory and moves those that match to a 
#new mads box directory
#on command line: script.pl <ortholog_annoation_key> <path to phy alignment files>

my $file = $ARGV[0];
open IN, "<$file";
my $line;
my @results;
my $GO;
my $blast;
my $id;
my %blast_hash;
while (<IN>){
	$line =$_;
	chomp $line; 
	@results = split(/\t/,$line);
	$id = $results[0];
	$GO = $results[2];
	$blast = $results[3];
	if ($blast =~ /SEPALLATA/){
		$blast_hash{$id}=0;
		print "$id\n";
	}
}

my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

my $name;foreach my $pep_file(@pep_files){
	$pep_file =~ /(\d+)\.phy/;
	$name = $1;
	if (exists $blast_hash{$name}){
		system "cp $pep_file /home/zerega/data/kristen/sepallata_orthologs/";
		system "cp RAxML_bestTree.$name.tree /home/zerega/data/kristen/sepallata_orthologs/";
	}
}
close IN;
exit;
	
	