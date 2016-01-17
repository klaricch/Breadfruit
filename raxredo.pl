#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.paml$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /([0-9]+)\.paml/;
	$name = $1;
	print "$name\n";
	open OUT, "> $name.phy";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		#if ($line =~ />/){
		#	$line =~ s/>//;
		#	}
		
		
		
			print OUT "$line\n";
			}
		close IN;
		close OUT;
		system "mv $name.phy /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/test2/blergh";
		}

exit;