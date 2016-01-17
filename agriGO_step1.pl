#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#moves orhtolog alignments into a new direcoty if the same file names existsed in the other dircoty

my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/\.phy/,readdir(DIR));
closedir DIR;

foreach my $pep_file(@pep_files){
	system "cp /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/$pep_file /home/zerega/data/kristen/protein_ortho/with_reference/paml_files/corrected_paml_files_GTRGAMMA/prep2/ortholog_reference";
}
exit;




#chack equalness