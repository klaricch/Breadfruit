#!/usr/bin/env python
#===============================================================================
# script calculate N50 value for assembly
#===============================================================================

from __future__ import division
import sys
from Bio import SeqIO
from Bio.Alphabet import IUPAC

def get_seq_lengths(filename):
	sumLength = 0
	contigsLength = []
	contigsLength = [len(record.seq) for record in SeqIO.parse(open(filename),'fasta')]
	contigsLength.sort()
	contigsLength.reverse()	
	sumLength = sum(contigsLength)
	return sumLength,contigsLength
	
def n50(contigsLength,sumLength,percentile):

	teoN50 = sumLength / (100/percentile)
    
	#checking N50
	testSum = 0
	N50 = 0
	for con in contigsLength:
		testSum += con
		if teoN50 <= testSum:
			N50 = con
			break
	return N50

def main():
	
	if len(sys.argv) < 2:
		print "Usage: python n50.py fastafile percentile1 [percentile2] ...\n"
		print "You may use more than one percentile\n"
		return

	contigsMultifasta = sys.argv[1]	
	percentages = sys.argv[2:]
	if len(percentages) == 0:
		percentages.append(50)
	
	sumLength,contigsLength = get_seq_lengths(contigsMultifasta)
	
	print "\nTotal length: %i" % sumLength
	print "Number of contigs: %i" %len(contigsLength) 
	for p in percentages:
		try:
			pct = int(p)
		except ValueError:
			print "Percentiles must be integers!\n"
			return
		N50 = n50(contigsLength,sumLength,pct)	
		print 'N%i: %s' % (pct,str(N50)) 
		
if __name__ == '__main__':main()		
		