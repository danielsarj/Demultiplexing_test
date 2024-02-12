#loading libraries/functions
"%&%" <- function(a,b) paste(a,b, sep = "")

#arguments and paths
project_folder <- '/project/lbarreiro/USERS/daniel/'
demuxalot_folder <- project_folder %&% 'demuxalot/'
vcf_file <- project_folder %&% 'VCFs/5samples.pilot.cecily.liftedb38.sorted.newheader.vcf.gz'
inds <- project_folder %&% 'VCFs/sample_ids.txt'

#read input file
input_f <- read.csv(demuxalot_folder %&% 'input_files.txt', sep=' ', header=F)

for (i in 1:nrow(input_f)){
  barcode_file <- input_f$V2[i]
  bam_file <- input_f$V3[i]
  demuxalot_outdir <- demuxalot_folder %&% input_f$V1[i]
  system('mkdir ' %&% demuxalot_outdir)

  #job file header
  sbatch_topper <- '#!/bin/sh' %&% '\n' %&% '#SBATCH --time=36:00:00' %&% '\n' %&%
    '#SBATCH --mem=120G' %&% '\n' %&% '#SBATCH --partition=caslake' %&% '\n' %&% 
    '#SBATCH --account=pi-lbarreiro' %&% '\n' %&% '#SBATCH --nodes=3' %&% '\n' %&%
    '#SBATCH --ntasks=3' %&% '\n' %&% '#SBATCH --cpus-per-task=12' %&% '\n' %&%
    '#SBATCH --error='%&% demuxalot_folder %&%'/demuxalot_' %&% input_f$V1[i] %&% '.error' %&% '\n' %&%
    '#SBATCH --out='%&% demuxalot_folder %&%'/demuxalot_' %&% input_f$V1[i] %&% '.out' %&%
    '\n\n' %&% 'module load singularity'

  #command line
  command_line <- 'singularity exec --bind ' %&% project_folder %&% ' ' %&%
    demuxalot_folder %&% 'Demuxafy.sif Demuxalot.py -a ' %&%
    bam_file %&% ' -n ' %&% inds  %&% ' -v ' %&% vcf_file %&% ' -b ' %&% barcode_file  %&%
    ' -o ' %&% demuxalot_outdir %&% ' -r True'

  #create sbatch file and write into it
  job_file <- file.path(demuxalot_folder, input_f$V1[i] %&% '.sbatch')
  cat(sbatch_topper %&% '\n\n' %&% command_line, file=job_file, append=F)

  #launch job!
  launch_call <- 'sbatch ' %&% job_file
  system(launch_call) #launches the job into midway
  cat('Submitted:', input_f$V1[i], '\n')
}

