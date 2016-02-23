#!/usr/bin/env bash


datasets="$HOME/molb/wk2data-sets/data-sets"

tfbs_bed="$datasets/bed/encode.tfbs.chr22.bed.gz"

histone_bed=$datasets/bed/encode.h3k4me3.hela.chr22.bed.gz

gzcat $tfbs_bed | awk '$4 == "CTCF"' > ctcf-peaks.bed

largest_overlap=$(bedtools intersect -a ctcf-peaks.bed -b \
 $histone_bed -wo \
  |awk '{print $NF}' \
   |sort -nr | head -n1)
printf "answer-1= %s\n" $largest_overlap > answers.yml



GC_content=$(bedtools nuc -fi $datasets/fasta/hg19.chr22.fa \
-bed $datasets/fasta/problem2interval.bed \
| tail -n1 \
| cut -f 5)
printf "answer-2= %s\n" $GC_content >> answers.yml



length_ctcf_peak=$(bedtools map -a $datasets/bed/ctcf-sites.bed -b \
$datasets/bedtools/ctcf.hela.chr22.bg -c 4 -o mean \
| sort -k5n -r \
| tail -n1 \
| awk '{print $3-$2}')
printf "answer-3= %s\n" $length_ctcf_peak >> answers.yml

gene_promoter=$(bedtools flank -l 1000 -r 0 -s -i \
$datasets/bedtools/tss.hg19.chr22.bed -g $datasets/genome/hg19.genome \
 | bedtools sort -i - \
 | bedtools map -a - -b $datasets/bedtools/ctcf.hela.chr22.bg -c 4 -o \
 median \
 | awk '$4 != "."' \
 | sort -k7n \
 | tail -n1 \
 | cut -f4)
 echo "answer-4: $gene_promoter" >> answers.yml



bedtools flank -l 1000 -r 0 -s -i \
$datasets/bedtools/tss.hg19.chr22.bed -g $datasets/genome/hg19.genome \
 | bedtools sort -i - \
 | bedtools map -a - -b $datasets/bedtools/ctcf.hela.chr22.bg -c 4 -o median \
 | wc -l 

<<A
 
 | awk '$7 != "."' \
 | sort -k7n | tail


<<
 | tail -n1 \
 | cut -f4


# echo "answer-4: $gene_promoter" >> answers.yml



