#loading libraries/functions
"%&%" <- function(a,b) paste(a,b, sep = "")

#arguments and paths
project_folder <- '/project/lbarreiro/USERS/daniel/'
souporcell_folder <- project_folder %&% 'Souporcell/'
vcf_file <- project_folder %&% 'VCFs/5samples.pilot.cecily.liftedb38.sorted.newheader.vcf.gz'

#IDS
input_f <- c('TCell1Stim16h', 'TCell1Stim4d', 'TCell1Unstim16h', 'TCell1Unstim4d')

for (i in 1:length(input_f)){
  souporcell_outdir <- souporcell_folder %&% input_f[i]

  #job file header
  sbatch_topper <- '#!/bin/sh' %&% '\n' %&% '#SBATCH --time=36:00:00' %&% '\n' %&%
    '#SBATCH --mem=120G' %&% '\n' %&% '#SBATCH --partition=caslake' %&% '\n' %&%
    '#SBATCH --account=pi-lbarreiro' %&% '\n' %&% '#SBATCH --nodes=1' %&% '\n' %&%
    '#SBATCH --error='%&% souporcell_folder %&%'/souporcell_genocorr_' %&% input_f[i] %&% '.error' %&% '\n' %&%
    '#SBATCH --out='%&% souporcell_folder %&%'/souporcell_genocorr_' %&% input_f[i] %&% '.out' %&%
    '\n\n' %&% 'module load singularity'

  #command line
  command_line <- 'singularity exec --bind ' %&% project_folder %&% ' ' %&%
    souporcell_folder %&% 'Demuxafy.sif Assign_Indiv_by_Geno.R -r ' %&%
    vcf_file %&% ' -c ' %&% souporcell_outdir %&% '/cluster_genotypes.vcf ' %&%
    '-o ' %&% souporcell_outdir

  #create sbatch file and write into it
  job_file <- file.path(souporcell_folder, input_f[i] %&% '_souporcell_genocorr_job.sbatch')
  cat(sbatch_topper %&% '\n\n' %&% command_line, file=job_file, append=F)

  #launch job!
  launch_call <- 'sbatch ' %&% job_file
  system(launch_call) #launches the job into midway
  cat('Submitted:', input_f[i], '\n')
}

