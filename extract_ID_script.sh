#!/bin/bash

# script requires standard .gen and .sample files and a file named variants.txt
# variants.txt is a file containing chr and bp - 1 variant per line

# This section loops over lines in variants.txt and assigns 2 variables: chr and bp
IFS=$'\n'
for line in `cat variants.txt`; do
chr=`echo $line | awk '{print $1}'`
echo $chr
bp=`echo $line | awk '{print $2}'`
echo $bp

#code to find heterozygotes
zcat /projects/UK10K/REL-2012-06-02/Genfiles/ALSPAC/${chr}.beagle.anno.csq.20130126.gen.gz | awk -v chr=$chr -v bp=$bp '$1==chr && $3==bp' | awk '{for (i=7; i<NF; i +=3) { if ($i==1) {print ((i-4)/3)+2}}}' > ~/Jorge_Rare_IDs/${chr}.${bp}_hets.cols.txt
awk 'FNR==NR{a[$1]; next}(FNR in a){print $1}' ~/Jorge_Rare_IDs/${chr}.${bp}_hets.cols.txt /projects/UK10K/REL-2012-06-02/Genfiles/ALSPAC/REL-2012-06-02.v2.phenotypes_ALSPAC_230113.sample > ~/Jorge_Rare_IDs/${chr}.${bp}_hets.ids.txt
rm ~/Jorge_Rare_IDs/${chr}.${bp}_hets.cols.txt

#code to find rare homozygotes
zcat /projects/UK10K/REL-2012-06-02/Genfiles/ALSPAC/${chr}.beagle.anno.csq.20130126.gen.gz |  awk -v chr=$chr -v bp=$bp '$1==chr && $3==bp' | awk '{for (i=8; i<NF; i +=3) { if ($i==1) {print ((i-5)/3)+2}}}' > ~/Jorge_Rare_IDs/${chr}.${bp}_homs.cols.txt
awk 'FNR==NR{a[$1]; next}(FNR in a){print $1}' ~/Jorge_Rare_IDs/${chr}.${bp}_homs.cols.txt /projects/UK10K/REL-2012-06-02/Genfiles/ALSPAC/REL-2012-06-02.v2.phenotypes_ALSPAC_230113.sample > ~/Jorge_Rare_IDs/${chr}.${bp}_homs.ids.txt
rm ~/Jorge_Rare_IDs/${chr}.${bp}_homs.cols.txt

done
