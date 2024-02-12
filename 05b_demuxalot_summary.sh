#!/bin/sh
module load singularity

InputIDs=("TCell1Stim4d" "TCell1Stim16h" "TCell1Unstim4d" "TCell1Unstim16h")

for ID in ${InputIDs[@]}; do

	echo ${ID}

        DEMUXALOT_OUTDIR=/project/lbarreiro/USERS/daniel/demuxalot/${ID}

singularity exec --bind /project/lbarreiro/USERS/daniel/ /project/lbarreiro/USERS/daniel/demuxalot/Demuxafy.sif bash demuxalot_summary.sh $DEMUXALOT_OUTDIR/assignments_refined.tsv.gz > $DEMUXALOT_OUTDIR/demuxalot_summary.tsv

done

