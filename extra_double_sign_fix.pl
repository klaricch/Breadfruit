#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.pep$/,readdir(DIR));
closedir DIR;


my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(\d+)\.pep/;
	$name = $1;
	open OUT, "> $name\_fix.pep";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />>/){
			$line =~ s/>>/>/;
			print OUT "$line\n"
			} else {
				print OUT "$line\n"
			}
		}


		system "mv $name\_fix.pep /home/zerega/data/kristen/protein_ortho/with_reference/orthologs/fix3";
		close IN;
	
		
	}

opendir DIR, $dir or die "cannot open dir $dir: $!";
my @cds_files = grep(/\.cds$/,readdir(DIR));
closedir DIR;
	foreach my $cds_file(@cds_files) {
	$cds_file =~ /(\d+)\.cds/;
	$name = $1;
	open OUT_CDS, "> $name\_fix.cds";
	open IN_CDS, "< $cds_file";
	while (<IN_CDS>){
		$line=$_;
		chomp $line;
		if ($line =~ />>/){
			$line =~ s/>>/>/;
			print OUT_CDS "$line\n"
			} else {
				print OUT_CDS "$line\n"
			}
		}


		system "mv $name\_fix.cds /home/zerega/data/kristen/protein_ortho/with_reference/orthologs/fix3";
	
		
	}

exit;

