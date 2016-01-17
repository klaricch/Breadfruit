#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

##USE THIS SCRIPT
my @sites;
my @columns;
my $position;
my $amino_acid;
my $Pr;
my $post_mean;
my $SE;
my @classes;
my @classesfb;


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
  if ($_ =~ /site\sclasses/) { #print lines after BEB
      #print  $_;
      $printable2 = 1;
    }
    elsif ($_ =~ /BEB/) { #print lines after BEB
      #print  $_;
      $printable = 1;
      $printable2 =0
    } elsif ($_ =~ /The/) { #but don't print lines after The
      $printable = 0;
    } elsif ($printable) {
      if ($_ =~ /\d+/ && $_ !~ /(BEB)|(Positively)|(amino)|(Pr)/ ) {push (@sites,$_)};
    }
      elsif ($printable2) {
            if ($_ =~ /\d+/ && $_ !~ /(site)/ && $_ !~ /w/ ) {push (@classes,$_)};
       if ($_ =~ /\d+/ && $_ =~ /w/ && $_ !~ /(site)/ ) {push (@classesfb,$_)};
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
my @columns2;
foreach my $class(@classes){

  @columns2 =split (/\s+/,$class); #split on space or space and "w"
  $class0 = $columns2[1];
$class1 =$columns2[2];
$class2a= $columns2 [3];
$class2b = $columns2[4]; #not present in branch-sites


print  "$class0,$class1,$class2a,$class2b,"; # want this three times (proportion, forground,and background, so don't print newline yet)

}


my $class0fb;
my $class1fb;
my $class2afb;
my $class2bfb;
my @columns2fb;
foreach my $classfb(@classesfb){

  @columns2fb =split (/\s+/,$classfb); #split on space or space and "w"
  $class0fb= $columns2fb[2];
$class1fb =$columns2fb[3];
$class2afb= $columns2fb [4];
$class2bfb = $columns2fb[5]; #not present in branch-sites


print  "$class0fb,$class1fb,$class2afb,$class2bfb"; # want this three times (proportion, forground,and background, so don't print newline yet)

}
print "\n";


close IN;
close OUT;
exit;
	