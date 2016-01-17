#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script parses a trinotate annotation report and outputs the 
#total contigs(double counts contigs that have annotations at more than one position in the transcript)
#the number of unique contigs(equal to number of contigs in the assembly) 
#and total counts of GO annotations for each of the 3 GO categories

#on command line: Parse_Trinotate_Report <trinnotate_annotaion_report file>

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

##DONT OVERWRITE IF PFAM FILE TWICE

my $cds_line;
my $cds_id;
my $cds_file;
open CDS_IN, "< /home/zerega/data/kristen/annotations/$sample_name.transdecoder.cds"; #want to pull out of .cds
while (<CDS_IN>){
	$/= ">";
	$cds_line=$_;
	chomp $cds_line;
	$cds_line =~ /(\S+)\s/;
	$cds_id = $1;
	print $cds_id;
	if (exists $PI_hash{$cds_id}){
	$cds_file = $PI_hash{$cds_id};
	open CDS_OUT, "> $cds_file.cds"; ##change this to >> after the initial creation of the files
		print CDS_OUT ">$cds_line";  #add in sample name
close CDS_OUT;
}
}
close CDS_IN;
	
	
$/= "\n";
my $pep_line;
my $pep_id;
my $pep_file;
open PEP_IN, "< /home/zerega/data/kristen/annotations/$sample_name.transdecoder.pep"; #want to pull out of .cds
while (<PEP_IN>){
	$/= ">";
	$pep_line=$_;
	chomp $pep_line;
	$pep_line =~ /(\S+)\s/;
	$pep_id = $1;
	print $pep_id;
	if (exists $PI_hash{$pep_id}){
	$pep_file = $PI_hash{$pep_id};
	open PEP_OUT, "> $pep_file.pep"; ##change this to >> after the initial creation of the files
		print PEP_OUT ">$pep_line";  #add in sample name
close PEP_OUT;
}
}
close PEP_IN;


$/= "\n";










#look at this one:comp153337_c0_seq24
##ALIGN
##TRIM DOWN FILE
##RAXML
##CONTROL FILE
##RUN PAML
# what if something has the smae PFAM within a sample?

## NOW NEED TO JOING THE PFAMS

#my $unique_contigs = $count_total_contigs - $count_twice_rep_contigs-1;  #minus 1 because don't want to count the header
#HOW MANY WERE ANNOTATED
#grabbing only the first?
#print "total contigs: $count_total_contigs\n";
#print "unique_contigs: $unique_contigs\n";
#print "blastx: $count_blastx\n";
#print "blastp: $count_blastp\n";
#print "pfam: $count_pfam\n";
#print "gene ontologies: $count_gene_ontologies\n";


close IN;
exit;