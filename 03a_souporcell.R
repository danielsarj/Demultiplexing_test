#loading libraries/functions
"%&%" <- function(a,b) paste(a,b, sep = "")

#arguments and paths
project_folder <- '/project/lbarreiro/USERS/daniel/'
souporcell_folder <- project_folder %&% 'Souporcell/'
fasta_file <- project_folder %&% 'VCFs/refs/GRCh38.primary_assembly.genome.fa'
n_samples <- '5'
n_threads <- '5'

#read input file
input_f <- read.csv(souporcell_folder %&% 'input_files.txt', sep=' ', header=F)

for (i in 1:nrow(input_f)){
  barcode_file <- input_f$V2[i]
  bam_file <- input_f$V3[i]
  souporcell_outdir <- souporcell_folder %&% input_f$V1[i]
  system('mkdir ' %&% souporcell_outdir)
  
  #job file header
  sbatch_topper <- '#!/bin/sh' %&% '\n' %&% '#SBATCH --time=36:00:00' %&% '\n' %&% 
    '#SBATCH --mem=120G' %&% '\n' %&% '#SBATCH --partition=caslake' %&% '\n' %&% 
    '#SBATCH --account=pi-lbarreiro' %&% '\n' %&% '#SBATCH --nodes=3' %&% '\n' %&%
    '#SBATCH --ntasks=3' %&% '\n' %&% '#SBATCH --cpus-per-task=12' %&% '\n' %&%
    '#SBATCH --error='%&% souporcell_folder %&%'/souporcell_' %&% input_f$V1[i] %&% '.error' %&% '\n' %&% 
    '#SBATCH --out='%&% souporcell_folder %&%'/souporcell_' %&% input_f$V1[i] %&% '.out' %&% 
    '\n\n' %&% 'module load singularity'

  #command line
  command_line <- 'singularity exec --bind ' %&% project_folder %&% ' ' %&%
    souporcell_folder %&% 'souporcell_latest.sif souporcell_pipeline.py -i ' %&% 
    bam_file %&% ' -f ' %&% fasta_file %&% ' -b ' %&% barcode_file %&% ' -t ' %&% 
    n_threads %&% ' -o ' %&% souporcell_outdir %&% ' -k ' %&% n_samples
 
  #create sbatch file and write into it
  job_file <- file.path(souporcell_folder, input_f$V1[i] %&% '_souporcell_job.sbatch')
  cat(sbatch_topper %&% '\n\n' %&% command_line, file=job_file, append=F)
    
  #launch job!
  launch_call <- 'sbatch ' %&% job_file
  system(launch_call) #launches the job into midway
  cat('Submitted:', input_f$V1[i], '\n')
}
