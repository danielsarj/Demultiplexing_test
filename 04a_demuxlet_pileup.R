#loading libraries/functions
"%&%" <- function(a,b) paste(a,b, sep = "")

#arguments and paths
project_folder <- '/project/lbarreiro/USERS/daniel/'
demuxlet_folder <- project_folder %&% 'demuxlet/'
vcf_file <- project_folder %&% 'VCFs/5samples.pilot.cecily.liftedb38.sorted.newheader.vcf.gz'

#read input file
input_f <- read.csv(demuxlet_folder %&% 'input_files.txt', sep=' ', header=F)

for (i in 1:nrow(input_f)){
  barcode_file <- input_f$V2[i]
  bam_file <- input_f$V3[i]
  demuxlet_outdir <- demuxlet_folder %&% input_f$V1[i]
  system('mkdir ' %&% demuxlet_outdir)

  #job file header
  sbatch_topper <- '#!/bin/sh' %&% '\n' %&% '#SBATCH --time=36:00:00' %&% '\n' %&%
    '#SBATCH --mem=120G' %&% '\n' %&% '#SBATCH --partition=caslake' %&% '\n' %&%
    '#SBATCH --account=pi-lbarreiro' %&% '\n' %&% '#SBATCH --nodes=10' %&% '\n' %&%
    '#SBATCH --ntasks=10' %&% '\n' %&% '#SBATCH --cpus-per-task=12' %&% '\n' %&%
    '#SBATCH --error='%&% demuxlet_folder %&%'demuxlet_pileup_' %&% input_f$V1[i] %&% '.error' %&% '\n' %&%
    '#SBATCH --out='%&% demuxlet_folder %&%'demuxlet_pileup_' %&% input_f$V1[i] %&% '.out' %&%
    '\n\n' %&% 'module load singularity'

  #command line
  command_line <- 'singularity exec --bind ' %&% project_folder %&% ' ' %&%
    demuxlet_folder %&% 'Demuxafy.sif popscle dsc-pileup --sam ' %&%
    bam_file %&% ' --vcf ' %&% vcf_file %&% ' --group-list ' %&% barcode_file  %&%
    ' --out ' %&% demuxlet_outdir %&% '/pileup'

  #create sbatch file and write into it
  job_file <- file.path(demuxlet_folder, input_f$V1[i] %&% '_pileup.sbatch')
  cat(sbatch_topper %&% '\n\n' %&% command_line, file=job_file, append=F)

  #launch job!
  launch_call <- 'sbatch ' %&% job_file
  system(launch_call) #launches the job into midway
  cat('Submitted:', input_f$V1[i], '\n')
}

