#!/usr/bin/python
# Read in two ublast results in blast tabular format:
# 	Transcriptome assembly to Protein database (Blastx-like)
# 	Protein database to transcriptome assembly (tBlastN-like)
#
#  The script also needs the location of the original protein file, 
#		to get the Subject length for Ortholog Hit Ratios
 	
# Output statistics:
# 	Number of unique best hits in assembly
# 	Number of proteins with hits in assembly
# 	Number of Reciprocal Best Hits
# 	Ortholog Hit Ratio

# python annotation_stats.py blastx.results tblastn.results
#!/usr/bin/env python
# The order of the files is important because they do not typically have the same format.

from __future__ import division
import sys
from Bio import SeqIO

blastx_filename = sys.argv[1]
tblastn_filename = sys.argv[2]
protein_filename = sys.argv[3]

blastx_dict = {}
tblastn_dict = {}
OHR = []

#Read the protein file into a Dict for easy hashing.
protein_dict = SeqIO.to_dict(SeqIO.parse(protein_filename,'fasta'))


#Read the blastx-like results
blastx_file = open(blastx_filename)
for line in blastx_file:
	hit = line.split('\t')
	
	#NOTE: Change the next two lines if the delimiters are different for your files!
	contig = hit[0].split(' ')[0]
	peptide = hit[1] #.split('|')[0].upper()
	#OHR = Alignment Length / Subject Length	
	OHR.append(float(hit[3])/len(protein_dict[peptide].seq))
	
	blastx_dict[contig] = peptide
blastx_file.close()

#Read tblastn-like results
tblastn_file = open(tblastn_filename)
for line in tblastn_file:
	hit = line.rstrip().split('\t')
	
	#NOTE: Change the next two lines if the delimiters are different for your files!
	peptide = hit[0].rstrip() #.split("|")[0].upper()
	contig = hit[1] #.split("|")[0].upper()
	#print contig,peptide
	tblastn_dict[peptide] = contig

#print blastx_dict.keys()[0:10]
#print tblastn_dict.keys()[0:10]

#Find Reciprocal Best Hits
RBH = 0
for i in blastx_dict.keys():
	try:
		j = tblastn_dict[blastx_dict[i]]
		if i == j:
			RBH += 1
	except KeyError:
		continue

#Find Collapse Factor
cf_dict={}
for prot in tblastn_dict:
	contig = tblastn_dict[prot]
	if contig in cf_dict:
		cf_dict[contig] +=1
	else:
		cf_dict[contig] = 1
avg_cf = sum(cf_dict.values())/len(cf_dict)

	
print "Annotation statistics"
print "---------------------"	
print "%i contigs had a best hit in the protein database!" % len(blastx_dict)
print "There were %i unique peptides found." % len(set(blastx_dict.values()))
print "The average Ortholog Hit Ratio was %.2f" % (sum(OHR)/len(OHR))
print "\nReverse Search Statistics"
print "---------------------------"
print "%i peptides had a best hit in the assembly!" %len(tblastn_dict)
print "There were %i unique contigs with hits." % len(set(tblastn_dict.values()))	
print "There were %i reciprocal best hits!" % RBH	
print "The average collapse factor was %.2f" % avg_cf
