#!/bin/bash

# Usage: usearch_annotation_stats.sh assemblyfile referenceproteinfile

#Conduct usearch of given FASTA file against the Physco database.
usearch -usearch_global $1 -db $2 -id 0.8 -blast6out blastx.usearch_$1

#Find ORFs
usearch -findorfs $1 -xlat -orfstyle 7 -mincodons 16 -output orfs.fasta

#Conduct usearch of Physco proteins against the orf file
usearch -usearch_global $2 -db orfs.fasta -id 0.8 -blast6out tblastn.usearch_$1


#Do the annotation stats
/home/zerega/data/kristen/scripts/annotation_stats.py blastx.usearch_$1 tblastn.usearch_$1 $2

/home/zerega/data/kristen/scripts/n50.py $1 25 50 75
