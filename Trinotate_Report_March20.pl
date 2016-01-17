#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script will run TransDecoder and all necessary components of Trinotate
#on command line Trinotate.pl <file with name of LI fasta assemblies>
my $file = $ARGV[0];
open IN, "< $file";
my $line;
my $result;
my $sample;
while (<IN>) {
	$line = $_;
	chomp $line;
	$sample = $line;
	
#run TransDecoder and pfam
system "/data/mjohnson/transdecoder/TransDecoder -t $sample --CPU 15 --reuse --search_pfam /data/mjohnson/transdecoder/pfam/Pfam-AB.hmm.bin";

#run hmmscan
#system "hmmscan --cpu 15 --domtblout Pfam_output_$sample.out /data/mjohnson/trinotate/Pfam-A.hmm $sample.transdecoder.pep > pfam_$sample.log";
#run blastx
#system "blastx -query $sample -db /data/mjohnson/trinotate/uniprot_sprot.fasta -num_threads 15 -max_target_seqs 1 -evalue .00001 -outfmt 6 > blastx_$sample.outfmt6";

#run blastp
#system "blastp -query $sample.transdecoder.pep -db /data/mjohnson/trinotate/uniprot_sprot.fasta -num_threads 15 -max_target_seqs 1 -evalue .00001 -outfmt 6 > blastp_$sample.outfmt6";
#generate gene_trans_map
#system "/data/mjohnson/trinity/trinityrnaseq_r20131110/util/get_Trinity_gene_to_trans_map.pl $sample > $sample.gene_trans_map";
#get pregenerate sqlite database 
#system "wget http://sourceforge.net/projects/trinotate/files/TRINOTATE_RESOURCES/TrinotateSqlite.sprot.20131110.db.gz/download -O Trinotate.sqlite.gz";
#gunzip the database
#system "gunzip Trinotate.sqlite.gz";
	
#load fasta, pep, and gene_trans_map	
#system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite init --gene_trans_map $sample.gene_trans_map --transcript_fasta $sample --transdecoder_pep $sample.transdecoder.pep";
#load blastx	
#system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_blastx blastx_$sample.outfmt6";
#load blastp
#system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_blastp blastp_$sample.outfmt6";	

#load pfam
#system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_pfam Pfam_output_$sample.out";
#generate report
#system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite report > trinotate_annotation_report_$sample.xls";
#remove sqlite database to prepare for next round
#system "rm Trinotate.sqlite";#system "rm Trinotate.sqlite.gz";
}
close IN;
exit;