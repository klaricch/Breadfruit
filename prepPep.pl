#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.transdecoder\.pep$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
foreach my $pep_file (@pep_files) {
	$pep_file =~ /(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
	$name = $1;
	open OUT, "> $name\_pepseqs.faa";
	open IN, "< $pep_file";
	$/= ">";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />/){
			$line =~ s/>//;
			}
		
		
		
			print OUT ">$name\_$line";
			}
		close IN;
		close OUT;
		$/= "\n"; #maybe unneccessay
		system "mv $name\_pepseqs.faa /home/zerega/data/kristen/protein_ortho/";
		}

exit;