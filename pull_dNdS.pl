#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script pulls the dNdS value from the M2 output files
#on command line: script.pl <path_to_M2_codeml_output>


my $dir= $ARGV[0];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/sites/,readdir(DIR));
closedir DIR;
my @sites;
my @columns;
my $position;
my $amino_acid;
my $Pr;
my $post_mean;
my $SE;

my $temp_file = "dNdS.csv";
open OUT, "> $temp_file";
foreach my $file(@pep_files){
 print $file;
open IN, "< $file";
$file =~ /_(\d+)$/;
my $name = $1;
my $line;
my $line2;
my $line3;
my $line4;
my $line5;
my $dNdS;

my $printable;
while (<IN>) {
 $line = $_;
 chomp $line;
    if ($line =~ /dN\s+\&\s+dS\s+for\s+each\s+branch/) {
      $line2 =scalar (<IN>);
      $line3 =scalar (<IN>);
       $line4 =scalar (<IN>);
       $line5 = scalar (<IN>);
      print "$line2\n$line3\n$line4\n$line5\n";
      @columns =split (/\s+/,$line5);
      $dNdS = $columns[5];

      
  }
  }
print OUT "$name,$dNdS\n";

close IN;
}
close OUT;
exit;
	