#!/bin/sh
module load singularity

InputIDs=("TCell1Unstim4d" "TCell1Unstim16h")

for ID in ${InputIDs[@]}; do

        echo ${ID}

        DEMUXLET_OUTDIR=/project/lbarreiro/USERS/daniel/demuxlet/${ID}

	singularity exec --bind /project/lbarreiro/USERS/daniel/ /project/lbarreiro/USERS/daniel/demuxlet/Demuxafy.sif bash Demuxlet_summary.sh $DEMUXLET_OUTDIR/demuxlet.best > $DEMUXLET_OUTDIR/demuxlet_summary.tsv


done

