#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#on command line: script.pl 

#will need to change this script for the reference/pooled assemblies
#list should be the full file names of the annotation reports




my @file;
my $file=$ARGV[0];
my $sample;
my $sample_name;

print "$file\n";
$file =~ /trinotate_annotation_report_(.*)\.xls/;
$sample_name = $1;
print "$sample_name\n";


$file =~ /trinotate_annotation_report_LI_(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w).*\.xls/;
$sample = ($1);
print "$sample\n";


my $line;
my @results;
my ($count_cellular_component, $count_molecular_function, $count_biological_process) = 0;
my ($count_total_contigs, $count_twice_rep_contigs, $count_gene_ontologies, $count_blastx, $count_blastp, $count_pfam) = 0;
my %seen;
my @full_pfam;
my $pfam_term;
my @pfam_ids;
my $pfam_id;
my $pfam_ids;
my @pfam_array;
my $pfam_set;
my %PI_hash;
open IN, "< /home/zerega/data/kristen/annotations/$file" or die "cannot open $!";
while (<IN>){
	$line = $_;
	chomp $line;
	@results = split (/\t/, $line);
	my $gene_id = $results[0];
	my $transcript_id = $results[1];
	my $top_blastx_hit = $results[2];
	my $rnammer = $results[3];
	my $prot_id = $results[4];
	my $prot_coords = $results[5];
	my $top_blastp_hit = $results[6];
	my $pfam = $results[7];
	my $singalp = $results[8];
	my $TmHmm = $results[9];
	my $eggnog = $results[10];
	my $gene_ontology = $results[11];
	
	
	#if (defined($gene_id)) {
	#	$count_total_contigs++; #count how many total contigs there are
	#	if ($seen{$gene_id}++) {$count_twice_rep_contigs++};  
	#}	
	#if ($gene_ontology =~ /^GO/) {
	#	$count_gene_ontologies++}; #count how many transcripts were annotated with GO terms
	#if ($top_blastx_hit =~ /^sp/) {$count_blastx++}; #count how many transcripts were annotated with GO terms
	#if ($top_blastp_hit =~ /^sp/) {$count_blastp++}; #count how many transcripts were annotated with GO terms
	if ($pfam =~ /^PF/ ) {$count_pfam++;
	#print "$pfam\n";
	@full_pfam = split ("`", $pfam);
	foreach $pfam_term(@full_pfam){
		@pfam_ids = split (/\^/, $pfam_term);
		$pfam_id = $pfam_ids[0];
			#print "$pfam_id\n";
			push (@pfam_array, $pfam_id);
			
		}
		$pfam_set=join ("_", @pfam_array);
		#print "$pfam_set\n";
		@pfam_array = (); 
		$PI_hash{$prot_id}=$pfam_set;#reset the array to empty
	}; #count how many transcripts were annotated with Pfam terms 

}
close IN;
open LOOKUP, "< pfam_lookup.txt" or die "cannot open $!";
my $lookup_line;
my @lookup_results;
my %lookup_hash;
while (<LOOKUP>){
	$lookup_line = $_;
	chomp $lookup_line;
	@lookup_results = split (/\t/, $lookup_line);
	my $lookup_contig = $lookup_results[0];
	my $lookup_pfam = $lookup_results[1];
	$lookup_hash{$lookup_contig} = $lookup_pfam;
}
close LOOKUP;
	
##DONT OVERWRITE IF PFAM FILE TWICE
#now have to ference the lookup table
my $key;

my $cds_line;
my $cds_id;
my $cds_file;
my %cds_hash;
open CDS_IN, "< /home/zerega/data/kristen/annotations/$sample_name.transdecoder.cds" or die "cannot open $!"; #want to pull out of .cds
while (<CDS_IN>){
	$/= ">";
	$cds_line=$_;
	chomp $cds_line;
	$cds_line =~ /(\S+)\s/;
	$cds_id = $1;
	if (exists $PI_hash{$cds_id}){
	foreach $key (keys %lookup_hash){
		if ($lookup_hash{$key} eq $PI_hash{$cds_id}){
			$cds_file = "$key.cds";
			open CDS_OUT, ">>$key.cds";
			print CDS_OUT ">$sample\_$cds_line";
		}
	}
	close CDS_OUT;
}

}

close CDS_IN;

my $pep_line;
my $pep_id;
my $pep_file;
my %pep_hash;
open PEP_IN, "< /home/zerega/data/kristen/annotations/$sample_name.transdecoder.pep" or die "cannot open $!"; #want to pull out of .pep
while (<PEP_IN>){
	$/= ">";
	$pep_line=$_;
	chomp $pep_line;
	$pep_line =~ /(\S+)\s/;
	$pep_id = $1;
	if (exists $PI_hash{$pep_id}){
	foreach $key (keys %lookup_hash){
		if ($lookup_hash{$key} eq $PI_hash{$pep_id}){
			$pep_file = "$key.pep";
			open PEP_OUT, ">>$key.pep";
			print PEP_OUT ">$sample\_$pep_line";
		}
	}
	close PEP_OUT;
}

}

close PEP_IN;

exit;
	####remove start codons?
	
	#no 2 cds ids should be the same
