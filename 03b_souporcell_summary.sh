#!/bin/sh
module load singularity

InputIDs=("TCell1Stim4d" "TCell1Stim16h" "TCell1Unstim4d" "TCell1Unstim16h")

for ID in ${InputIDs[@]}; do

	echo ${ID}

	SOUPORCELL_OUTDIR=/project/lbarreiro/USERS/daniel/Souporcell/${ID}

	singularity exec --bind /project/lbarreiro/USERS/daniel/ /project/lbarreiro/USERS/daniel/Souporcell/Demuxafy.sif bash souporcell_summary.sh $SOUPORCELL_OUTDIR/clusters.tsv > $SOUPORCELL_OUTDIR/souporcell_summary.tsv

done
