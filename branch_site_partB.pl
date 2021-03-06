#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;


##USE THIS SCRIPT

my $cds_file;
my $name;
my $line2;
my $key2;
my %hash2;
my $count=0;
my $ref_id;
my %final_hash;
my $annotation;
my $pep_file;




##################################################

my @sites;
my @columns;
my $position;
my $amino_acid;
my $Pr;
my $post_mean;
my $SE;
my @classes;
my @classesfb;
my %hash;


my $file = $ARGV[0];
$file =~ /branch_site_test_estimated_(\d+)\_(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
my $ortholog_group = $1;
my $lineage = $2;
my $summary_file = "branch_site_test_summary_all_samples.txt";
open OUT, ">> $summary_file";
print OUT "$ortholog_group\t$lineage\t";
##########


$pep_file = "$ortholog_group\.phy";
	$name = $ortholog_group;

	open IN2, "< $pep_file";
	while (<IN2>){
		$line2=$_;
		chomp $line2;
		if ($line2 =~ /^$name\_(c.*)/){
			$ref_id = $1;
			#print "$line2\n";
			
		if (exists $hash{$ref_id}){ #if the modified id is present, increase the count
		$annotation = "$ref_id\t$hash{$ref_id}\t";
		$final_hash{$name} = $annotation;
	} else {$final_hash{$name} = "$ref_id\t\.\t";} #if the term wasn's annotated, mark it with a period
	}
}
close IN2;



foreach my $item(keys %final_hash){
	print OUT "$final_hash{$item}\t";
}
#if parallelize, won't have to clear the hash








































open IN, "< $file";

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
print  OUT "$position\t$amino_acid\t$Pr\t";
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


print  OUT "$class0\t$class1\t$class2a\t$class2b\t"; # want this three times (proportion, forground,and background, so don't print newline yet)

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


print OUT "$class0fb\t$class1fb\t$class2afb\t$class2bfb"; # want this three times (proportion, forground,and background, so don't print newline yet)

}
print OUT "\n";


close IN;
close OUT;
exit;
	