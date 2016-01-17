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
my $file = $ARGV[0];
open IN, "< $file";
my $line;
my $temp_file = "BEB_$file";
#open OUT, "> $temp_file";
my $printable;
while (<IN>) {
    if ($_ =~ /BEB/) { #print lines after BEB
      #print  $_;
      $printable = 1;
    } elsif ($_ =~ /The/) { #but don't print lines after The
      $printable = 0;
    } elsif ($printable) {
      if ($_ =~ /\d+/ && $_ !~ /(BEB)|(Positively)|(amino)|(Pr)/ ) {push (@sites,$_)};
    }
  }
print @sites;
foreach my $site(@sites){
  @columns =split (/\s+/,$site);
  $position = $columns[1];
$amino_acid =$columns[2];
$Pr= $columns [3];
$post_mean = $columns[4];
$SE = $columns [6];
if ($Pr =~ /\*/){
print  "$position,$amino_acid,$Pr,$post_mean+-$SE\n";
}
}


close IN;
close OUT;
exit;
	