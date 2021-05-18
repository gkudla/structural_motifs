#!/bin/bash

# this script finds enriched double-stranded structural motifs in a CLASH dataset
# input: Sander's data table with chimera annotations, with sequences of chimera fragments in columns 30 and 31
# output: many outputs including .pdf graph with frequencies and fold enrichment of motifs

# to run this, place Sander's data table in an empty directory, and type:
# structural_motifs.sh <input_filename>

NUM_FILES=`ls -1 | wc -l`
BARENAME=${1/.txt/}

if [ "$NUM_FILES" -ne "1" ] || [ ! -f $1 ] || [ "$BARENAME" == "$1" ] ; then 
echo To run this script, type structural_motifs.sh inputfile.txt
echo make sure there is exactly one file - the input data table, with .txt extension - in the current directory
exit 1
fi

awk 'FNR>1' $1 | cut -f1,30 | tab2fasta.awk > bit1.fasta
awk 'FNR>1' $1 | cut -f1,31 | tab2fasta.awk > bit2.fasta

hybrid-min bit1.fasta bit2.fasta 2>&1 > /dev/null
Ct2B_GK_3.pl bit1.fasta-bit2.fasta.ct > hybrids.vienna

fasta2tab.awk bit2.fasta | shuf53 | tab2fasta.awk > bit2.shuffled.fasta
hybrid-min bit1.fasta bit2.shuffled.fasta 2>&1 > /dev/null
Ct2B_GK_3.pl bit1.fasta-bit2.shuffled.fasta.ct > hybrids.shuffled.vienna 

#
cat hybrids.vienna | structural_motifs.awk > hybrids.structural_motifs.txt
cat hybrids.structural_motifs.txt | sort -k1,1 | groupBy -g 1 -c 2 -o count_distinct | sort -k2,2nr > hybrids.structural_motifs.counts.txt

#
cat hybrids.shuffled.vienna | structural_motifs.awk > hybrids.shuffled.structural_motifs.txt
cat hybrids.shuffled.structural_motifs.txt | sort -k1,1 | groupBy -g 1 -c 2 -o count_distinct | sort -k2,2nr > hybrids.shuffled.structural_motifs.counts.txt

#
N_STRUCT=`cat hybrids.vienna | count_structures.awk`

#
cat hybrids.structural_motifs.counts.txt | awk '{print $1 "\thybrids=" $2}' > hybrids.structural_motifs.forTable.txt
cat hybrids.shuffled.structural_motifs.counts.txt | awk '{print $1 "\tshuffled=" $2}' > hybrids.shuffled.structural_motifs.forTable.txt
make_hybrid_annotation_table.pl hybrids.struct*.forTable.txt hybrids.shuf*.forTable.txt | sed "s/NA/0/g" | awk -v n_struct=$N_STRUCT 'BEGIN{OFS="\t"}!/^#/{print NR,$1,$2,n_struct-$2,$3,n_struct-$3}' > structural_motifs.txx
head -1000 structural_motifs.txx > structural_motifs.1000.txx
Subopt_Fisher_tests.R structural_motifs.1000.txx > structural_motifs.1000.results.txx
#
cat structural_motifs.1000.results.txx | awk 'BEGIN{print "motif\tlogCounts\tlogFoldChange\tp.label\tpadj"}{logCnt=log(($5+$3)/2)/log(2);LFC=log(($3+1)/($5+1))/log(2);if($8<0.05){pval="p<0.05"}else{pval="."};print $2 "\t" logCnt "\t" LFC "\t" pval "\t" $8}' > structural_motifs.1000.forR.txx
#
plot_structural_motifs.R $BARENAME 





