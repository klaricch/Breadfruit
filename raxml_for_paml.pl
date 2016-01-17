#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script runs RAxML with the GTRCAT substitution model
#run in parallel
#on command line: script.pl <phylip_alignment_file>

my $file = $ARGV[0];
$file =~ /(.*)\.phy/;
my $id =$1;


system "raxmlHPC -s $file -n $id.tree -m  GTRCAT";

exit;

