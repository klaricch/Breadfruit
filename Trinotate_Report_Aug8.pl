#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;

#this script will run TransDecoder and all necessary components of Trinotate
#on command line Trinotate.pl <file with name of LI fasta assemblies>
my $sample = $ARGV[0];


	
#run TransDecoder and pfam
system "/data/mjohnson/transdecoder/TransDecoder -t $sample --CPU 5 --reuse --search_pfam /data/mjohnson/transdecoder/pfam/Pfam-AB.hmm.bin";

#run hmmscan
system "hmmscan --cpu 5 --domtblout Pfam_output_$sample.out /data/mjohnson/trinotate/Pfam-A.hmm $sample.transdecoder.pep > pfam_$sample.log";
#run blastx
system "blastx -query $sample -db /data/mjohnson/trinotate/uniprot_sprot.fasta -num_threads 5 -max_target_seqs 1 -evalue .00001 -outfmt 6 > blastx_$sample.outfmt6";

#run blastp
system "blastp -query $sample.transdecoder.pep -db /data/mjohnson/trinotate/uniprot_sprot.fasta -num_threads 5 -max_target_seqs 1 -evalue .00001 -outfmt 6 > blastp_$sample.outfmt6";
#generate gene_trans_map
system "/data/mjohnson/trinity/trinityrnaseq_r20131110/util/get_Trinity_gene_to_trans_map.pl $sample > $sample.gene_trans_map";
#get pregenerate sqlite database 
system "wget http://sourceforge.net/projects/trinotate/files/TRINOTATE_RESOURCES/20140708/Trinotate.20140708.swissTrEMBL.sqlite.gz/download -O Trinotate.sqlite.gz";
#gunzip the database
system "gunzip Trinotate.sqlite.gz";
	
#load fasta, pep, and gene_trans_map	
system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite init --gene_trans_map $sample.gene_trans_map --transcript_fasta $sample --transdecoder_pep $sample.transdecoder.pep";
#load blastx	
system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_blastx blastx_$sample.outfmt6";
#load blastp
system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_blastp blastp_$sample.outfmt6";	

#load pfam
system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite LOAD_pfam Pfam_output_$sample.out";
#generate report
system "/data/mjohnson/trinotate/Trinotate_r20131110/Trinotate Trinotate.sqlite report > trinotate_annotation_report_$sample.xls";
#remove sqlite database to prepare for next round
#system "rm Trinotate.sqlite";#system "rm Trinotate.sqlite.gz";


exit;