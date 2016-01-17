#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


my @sites;
my @columns;
my $position;
my $amino_acid;
my $Pr;
my $post_mean;
my $SE;
my @classes;


my $file = $ARGV[0];
$file =~ /branch_site_test_estimated_(\d+)\_(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
my $ortholog_group = $1;
my $lineage = $2;
print "$ortholog_group, $lineage,";
open IN, "< $file";
my $line;
my $temp_file = "BEB_$file";
#open OUT, "> $temp_file";
my $printable;
my $printable2;
while (<IN>) {
    if ($_ =~ /BEB/) { #print lines after BEB
      #print  $_;
      $printable = 1;
    } elsif ($_ =~ /The/) { #but don't print lines after The
      $printable = 0;
    } elsif ($printable) {
      if ($_ =~ /\d+/ && $_ !~ /(BEB)|(Positively)|(amino)|(Pr)/ ) {push (@sites,$_)};
    }
  
    ########
        elsif ($_ =~ /site\sclasses/) { #print lines after BEB
      print  $_;
      $printable2 = 1;
    } elsif ($_ =~ /BEB/) { #but don't print lines after The
      $printable2 = 0;
      print $_;
    } elsif ($printable2) {
      if ($_ =~ /\d+/ && $_ !~ /(site)/ ) {push (@classes,$_)};
    }
  }

foreach my $site(@sites){
  @columns =split (/\s+/,$site);
  $position = $columns[1];
$amino_acid =$columns[2];
$Pr= $columns [3];
#$post_mean = $columns[4]; #not present in branch-sites
#$SE = $columns [6]; #not present in branch sites
if ($Pr =~ /\*/){
print  "$position,$amino_acid,$Pr,";
}
}

my $class0;
my $class1;
my $class2a;
my $class2b;
my @columns2;#foreach my $class(@classes){
#  print "$class\n";
#  @columns2 =split (/\s+|\sw\s+/,$class); #split on space or space and "w"
#  $class0 = $columns2[1];
#$class1 =$columns2[2];
#$class2a= $columns2 [3];
#$class2b = $columns2[4]; #not present in branch-sites
#$SE = $columns [6]; #not present in branch sites

#print  "$class0,$class1,$class2a,$class2b,"; # want this three times (proportion, forground,and background, so don't print newline yet)

#}
#print "\n";


close IN;
close OUT;
exit;
	