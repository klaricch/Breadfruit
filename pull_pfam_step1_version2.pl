#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#on command line: script.pl <annotation report>

#will need to change this script for the reference/pooled assemblies

my $file = $ARGV[0];
open IN, "< $file";

my $sample_name;
$file =~ /trinotate_annotation_report_(.*)\.xls/;
$sample_name = $1;
print $sample_name;

my $sample;
$file =~ /trinotate_annotation_report_LI_(RNA\d+_\w\d\w\w|EW\d+_\w\d\w\w).*\.xls/;
$sample = ($1);
print $sample;


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
my %PI_hash_filename;
my $prot_id_filename;
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
		@pfam_array = (); #reset the array to empty
		$PI_hash{$pfam_set}=$prot_id;#
		($prot_id_filename = $prot_id) =~ (s/\|/_/);
		$PI_hash_filename{$pfam_set}=$prot_id_filename;
		
	}; #count how many transcripts were annotated with Pfam terms 

}
###but dont want to repeat if the smae pfam
my $key;
#create lookup file:
	open LOOKUP, "> pfam_lookup.txt"; ##change this to >> after the initial creation of the files
	foreach $key ( sort keys %PI_hash_filename){
		system "touch $PI_hash_filename{$key}.cds";
		system "touch $PI_hash_filename{$key}.pep";
		print LOOKUP "$PI_hash_filename{$key}\t$key\n";  #add in sample name
	}
close LOOKUP;
close IN;
exit;

