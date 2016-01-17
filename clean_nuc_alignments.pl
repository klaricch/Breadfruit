#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.txt$/,readdir(DIR));
closedir DIR;

my $cds_file;
my $name;
my $line;
my $exist_after_remove_gaps = 0;
foreach my $pep_file (@pep_files) {
	$exist_after_remove_gaps = 0;
	$pep_file =~ /(\d+)\.txt/;
	$name = $1;
	open OUT, "> $name.paml";
	open IN, "< $pep_file";
	while (<IN>){
		$line=$_;
		chomp $line;
		if ($line =~ />/){
			$line =~ />(.*)/;
			print OUT "$1\n";
			} else {
				print OUT "$line\n"
			}
			if(2..2){
			if ($_ =~ /\D+/){
				$exist_after_remove_gaps = 1;
			}
		}
		}
		#if secondon lien statment
		if ($exist_after_remove_gaps == 1){
		system "mv $name.paml /home/zerega/data/kristen/protein_ortho/with_reference/paml_files";
	}
	
		}

exit;