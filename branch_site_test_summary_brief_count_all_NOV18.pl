#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

##USE THIS SCRIPT
my $annotation_report = $ARGV[0];
my $line;
my @columnst;
my $prot_ID;
my $gene_ontology;
my @full_GO;
my $GO_term;
my $GO;
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

open OUTS, ">counts_summary_NOV18.csv";
#Gene Counts
my $RNA16_H3ml_count =0;
my $RNA17_A3El_count =0;
my $RNA21_A2Mf_count =0;
my $RNA24_A2Ml_count =0;
my $RNA2_C2mf_count =0;
my $RNA32_H2Wf_count =0;
my $RNA5_C2Ef_count =0;
my $RNA7_M2mf_count =0;
my $RNA34_A3Wf_count =0;
my $RNA35_C2Mf_count =0;
my $RNA36_H2Wf_count =0;
my $RNA37_C2mf_count =0;
my $RNA38_A3Wl_count =0;
my $RNA39_A3El_count =0;
my $RNA40_H3ml_count =0;
my $RNA48_H2ml_count =0;
my $RNA10_H3El_count =0;
my $RNA25_A3ml_count =0;
my $RNA26_A3ml_count =0;
my $RNA49_H3El_count =0;
my $RNA4_A3Ef_count =0;
my $EW1_A2Mf_count =0;
my $EW2_C2Mf_count =0;
my $EW3_A3Ef_count =0;
my $EW4_C2Mv_count =0;

my %gene_hash =(
RNA16_H3ml => 0,
RNA17_A3El => 0,
RNA21_A2Mf => 0,
RNA24_A2Ml => 0,
RNA2_C2mf => 0,
RNA32_H2Wf => 0,
RNA5_C2Ef => 0,
RNA7_M2mf => 0,
RNA34_A3Wf => 0,
RNA35_C2Mf => 0,
RNA36_H2Wf => 0,
RNA37_C2mf => 0,
RNA38_A3Wl => 0,
RNA39_A3El => 0,
RNA40_H3ml => 0,
RNA48_H2ml => 0,
RNA10_H3El => 0,
RNA25_A3ml => 0,
RNA26_A3ml => 0,
RNA49_H3El => 0,
RNA4_A3Ef => 0,
EW1_A2Mf => 0, 
EW2_C2Mf => 0,
EW3_A3Ef => 0,
EW4_C2Mv => 0,
);

my %sites_hash =(
RNA16_H3ml => 0,
RNA17_A3El => 0,
RNA21_A2Mf => 0,
RNA24_A2Ml => 0,
RNA2_C2mf => 0,
RNA32_H2Wf => 0,
RNA5_C2Ef => 0,
RNA7_M2mf => 0,
RNA34_A3Wf => 0,
RNA35_C2Mf => 0,
RNA36_H2Wf => 0,
RNA37_C2mf => 0,
RNA38_A3Wl => 0,
RNA39_A3El => 0,
RNA40_H3ml => 0,
RNA48_H2ml => 0,
RNA10_H3El => 0,
RNA25_A3ml => 0,
RNA26_A3ml => 0,
RNA49_H3El => 0,
RNA4_A3Ef => 0,
EW1_A2Mf => 0, 
EW2_C2Mf => 0,
EW3_A3Ef => 0,
EW4_C2Mv => 0,
);
#Site Counts
my $RNA16_H3ml_sites =0;
my $RNA17_A3El_sites =0;
my $RNA21_A2Mf_sites =0;
my $RNA24_A2Ml_sites =0;
my $RNA2_C2mf_sites =0;
my $RNA32_H2Wf_sites =0;
my $RNA5_C2Ef_sites =0;
my $RNA7_M2mf_sites =0;
my $RNA34_A3Wf_sites =0;
my $RNA35_C2Mf_sites =0;
my $RNA36_H2Wf_sites =0;
my $RNA37_C2mf_sites =0;
my $RNA38_A3Wl_sites =0;
my $RNA39_A3El_sites =0;
my $RNA40_H3ml_sites =0;
my $RNA48_H2ml_sites =0;
my $RNA10_H3El_sites =0;
my $RNA25_A3ml_sites =0;
my $RNA26_A3ml_sites =0;
my $RNA49_H3El_sites =0;
my $RNA4_A3Ef_sites =0;
my $EW1_A2Mf_sites =0;
my $EW2_C2Mf_sites =0;
my $EW3_A3Ef_sites =0;
my $EW4_C2Mv_sites =0;


my %hash;
my $key;
my $GOt;
my $idt;
my $blastt;
my @blast_cat;
my $b1;
my $b2;
my $description;
my $gene_id;
#STORE THE ORTHOLOG IS INTO A HASH FROM THE FULL ORTHOLOG ANNOTATION REPORT

open IN_TRI, "< $annotation_report";

while (<IN_TRI>){
	$line=$_;
	chomp $line;
	@columnst = split (/\t/, $line);
	$idt = $columnst[0];
	$GOt = $columnst[2];
	$blastt = $columnst[3];

	
	        @blast_cat = split(/\^/, $blastt);
	$b1 = $blast_cat[0];
	$b1 =~ /sp\|.*\|(.*)/;
	$gene_id = $1;
	$b2 = $blast_cat[5];
	print "$b2\n";
	$b2=~ /.*Full\=(.*);/;
	$description = $1;
	$hash{$idt} ="$gene_id\t$description\t"; #key for each cds.comp|m
	

	

}
close IN_TRI;
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


#PRINT OUT THE ORTHOLOG ID, LINEAGE, AND ANNOTATION
my $dir= $ARGV[1];  #name of directory
opendir DIR, $dir or die "cannot open dir $dir: $!";
my @pep_files = grep(/estimated/,readdir(DIR));
closedir DIR;

foreach my $file(@pep_files){
  $file =~ /branch_site_test_estimated_(\d+)\_(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w)/;
my $ortholog_group = $1;
my $lineage = $2;
my %lineage_hash;
$gene_hash{$lineage}++;
$lineage =~ /(RNA\d+|EW\d+)_\w\d\w\w/;
my $sam = $1;
	my $likelihood1 = `grep "lnL" branch_site_test_fixed_$ortholog_group\_$lineage`; #or can use grep -m 1 
	my $likelihood2 = `grep "lnL" branch_site_test_estimated_$ortholog_group\_$lineage`;

	$likelihood1 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL1 = $1;
	$likelihood2 =~ /\)\:\s+(-?\d+\.?\d+)/;  #log likelihood can be negative or 0
	my $lnL2 = $1;
	my $chi2_value = $lnL2-$lnL1;

 my $count =0;

my $speciesF;
my $ploidyF;
my $regionF;
	$lineage =~ /_(\D)(\d)(\D)(\D)/;
	my $species = $1;
	my $ploidy = $2;
	my $region = $3;
my $summary_file = "branch_site_test_summary_all_samples_NOV18.txt";
open OUT, ">> $summary_file";
print OUT "$ortholog_group\t$sam\t";
##########

$pep_file = "$ortholog_group\.phy";
	$name = $ortholog_group;

			
		if (exists $hash{$name}){ 
		$annotation = "$hash{$name}\t";
		$final_hash{$name} = $annotation;
	} else {$final_hash{$name} = "\.\t";} #if the term wasn's annotated, mark it with a period
	





foreach my $item(keys %final_hash){
	print OUT "$final_hash{$item}\t$chi2_value\t";
}


#PRINT OUT THE SITE CLASS PARAMETERS

open IN, "< $file";

my $printable;
my $printable2;
while (<IN>) {
  if ($_ =~ /site\sclasses/) { #print lines after BEB
      #print  $_;
      $printable2 = 1;
    }
    elsif ($_ =~ /Wong/) { #print lines after BEB
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
  
  print "@classesfb\n";my $class0;
my $class1;
my $class2a;
my $class2b;
my @columns2;
foreach my $class(@classes){

  @columns2 =split (/\s+/,$class); #split on space 
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

  @columns2fb =split (/\s+/,$classfb); #split on space
  $class0fb= $columns2fb[2];
$class1fb =$columns2fb[3];
$class2afb= $columns2fb [4];
$class2bfb = $columns2fb[5]; #not present in branch-sites


print OUT "$class0fb\t$class1fb\t$class2afb\t$class2bfb\t"; # want this three times (proportion, forground,and background, so don't print newline yet)

}
#PRINT OUT THE SITES THAT WERE SIGNIFICANT

foreach my $site(@sites){
  @columns =split (/\s+/,$site);
  $position = $columns[1];
  print "$position\n";
$amino_acid =$columns[2];
$Pr= $columns [3];
#$post_mean = $columns[4]; #not present in branch-sites
#$SE = $columns [6]; #not present in branch sites
if ($Pr =~ /\*/){
  $count++;
  $sites_hash{$lineage}++;
##print  OUT "$position\t$amino_acid\t$Pr\t";
}
}

print OUT "$count\t$species\t$ploidy\t$region";
print OUT "\n";
%final_hash=(); #clear the hash;
@sites =();
@classes=();
@classesfb=();
}

foreach my $key(sort keys %gene_hash){
  print OUTS "$key,$gene_hash{$key},$sites_hash{$key}\n";
}



close IN;
close OUT;
close OUTS;
exit;
	