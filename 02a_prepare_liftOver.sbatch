#!/bin/sh
#SBATCH --time=32:00:00
#SBATCH --mem=32G
#SBATCH --partition=caslake
#SBATCH --account=pi-lbarreiro
#SBATCH --error=/project/lbarreiro/USERS/daniel/LiftVCFb37tob38.error
#SBATCH --out=/project/lbarreiro/USERS/daniel/LiftVCFb37tob38.out

#script to prepare files to lift VCFs from b37 to b38

#copy reference genome files to my folder
cp /project/lbarreiro/SHARED/REFERENCES/Homo_sapiens/GATK/GRCh38/GRCh38.primary_assembly.genome.fa /project/lbarreiro/USERS/daniel/VCFs/refs
cp /project/lbarreiro/USERS/ilia/time_course/MLS_genotypes/GRCh38/for_liftover/GRCh37_to_GRCh38.chain.gz /project/lbarreiro/USERS/daniel/VCFs/refs

#move into folder
cd /project/lbarreiro/USERS/daniel/VCFs/refs/

#load modules
module load java 
module load samtools

#subset reference fasta file for chromosomes 1-22, X
samtools faidx GRCh38.primary_assembly.genome.fa chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX > GRCh38.sub.primary_assembly.genome.fa

#create dictionary file
java -jar /project/lbarreiro/USERS/tauras/Programs/picard.jar CreateSequenceDictionary -R /project/lbarreiro/USERS/daniel/VCFs/refs/GRCh38.sub.primary_assembly.genome.fa -O /project/lbarreiro/USERS/daniel/VCFs/refs/GRCh38.sub.primary_assembly.genome.dict

#change vcf file chromosome names
/project/lbarreiro/USERS/daniel/SOFTWARE/bcftools-1.19/bcftools annotate --rename-chrs ChrConversion.txt /project/lbarreiro/USERS/daniel/VCFs/5samples.pilot.cecily.vcf | /project/lbarreiro/USERS/daniel/SOFTWARE/htslib-1.19/bgzip > /project/lbarreiro/USERS/daniel/VCFs/5samples.pilot.cecily.vcf.gz

