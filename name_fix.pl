#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
my $file = $ARGV[0];
$file =~ /(\d+)_fix\.(.*)/;
system "cp $file $1\.$2";
system "mv $1\.$2 /home/zerega/data/kristen/protein_ortho/with_reference/orthologs/fix4";
		
		exit;
