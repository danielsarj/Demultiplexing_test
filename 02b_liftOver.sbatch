#!/bin/sh
#SBATCH --time=1:00:00
#SBATCH --mem=32G
#SBATCH --partition=caslake
#SBATCH --account=pi-lbarreiro
#SBATCH --error=/project/lbarreiro/USERS/daniel/LiftVCFb37tob38.error
#SBATCH --out=/project/lbarreiro/USERS/daniel/LiftVCFb37tob38.out

#script to lift VCFs from b37 to b38
module load java 

FOLDER_FILES=/project/lbarreiro/USERS/daniel/VCFs/

java -jar /project/lbarreiro/USERS/tauras/Programs/picard.jar LiftoverVcf \
-I ${FOLDER_FILES}5samples.pilot.cecily.vcf.gz \
-O ${FOLDER_FILES}5samples.pilot.cecily.liftedb38.vcf.gz \
-CHAIN ${FOLDER_FILES}refs/hg19ToHg38.over.chain.gz \
-REJECT ${FOLDER_FILES}rejected_variants.vcf.gz \
-R ${FOLDER_FILES}refs/GRCh38_sub_primary_assembly_genome.fa \
-WARN_ON_MISSING_CONTIG true
