#loading libraries
library(tidyverse)
"%&%" <- function(a,b) paste(a,b, sep = "")

#arguments and paths
project_folder <- '/project/lbarreiro/'
fastq_folder <- project_folder %&% 'USERS/cecily/czi_pilot/data/20230824_LH00315_0007_B227CMNLT3-LB-CC-1s'
milticonfig_topper_file <-  project_folder %&% 'USERS/daniel/topper_multi_config.csv'
alignment_path <- project_folder %&% 'USERS/daniel'

#retrieve fastq file names
fastq <- list.files(fastq_folder, 
                    pattern = 'fastq.gz$',
                    full.names = T,
                    recursive = T)

#get fastq ID
ct_seq <- gsub('_.*','',gsub('LB-CC-10X-1s-','',basename(fastq)))

#organize files in a df to submit jobs
ct_seq_df <- do.call(rbind,lapply(ct_seq, function(x){unlist(strsplit(x,'-'))})) %>% as.data.frame()
ct_seq_df$V1 <- paste(ct_seq_df$V1,ct_seq_df$V2,ct_seq_df$V3, sep='')
ct_seq_df <- ct_seq_df %>% select(V1, V4)
colnames(ct_seq_df) <- c('ct', 'info')
ct_seq_df$fastq_id <- gsub('_.*','',basename(fastq))
ct_seq_df$run_id <- gsub('-GEX|-CSP|-TCR','',ct_seq_df$fastq_id)
ct_seq_df <- ct_seq_df %>% 
  group_by(fastq_id) %>% 
  slice_head(n = 1)

#group by celltype
by_ct_seq_df_list <- lapply(unique(ct_seq_df$ct), function(x){ct_seq_df[ct_seq_df$ct==x,]})

#job file header
align_sbatch_topper <- '#!/bin/sh' %&% '\n' %&% '#SBATCH --time=32:00:00' %&%  '\n' %&% 
  '#SBATCH --mem=64G' %&% '\n' %&% '#SBATCH --partition=caslake' %&% '\n' %&% 
  '#SBATCH --account=pi-lbarreiro' %&% '\n'

#running jobs
for(i_ct_info in by_ct_seq_df_list){
  i_ct_name <- unique(i_ct_info$ct) #get cell type
  i_run_id <- unique(i_ct_info$run_id) #get run id
  i_ct_aligned_data <- file.path(alignment_path, i_ct_name)
  dir.create(i_ct_aligned_data) #create output dir
  
  if(length(i_ct_name)==1){
    i_ct_config_data <- data.frame(fastq_id=i_ct_info$fastq_id,
                                   fastqs=fastq_folder,
                                   lanes='1|2|3',
                                   feature_types=ifelse(i_ct_info$info=='GEX','gene expression',
                                                        ifelse(i_ct_info$info=='CSP','antibody capture','vdj-t')),
                                   subsample_rate='')
    
    i_ct_config_file <- file.path(alignment_path, i_ct_name%&%'_INcomplete_config.csv')
    write.csv(i_ct_config_data, file=i_ct_config_file, quote=F, row.names=F) #save incomplete config
    
    complete_i_ct_config <- file.path(alignment_path, i_ct_name%&%'_complete_config.csv')
    system('cat '%&% milticonfig_topper_file %&% ' ' %&% i_ct_config_file %&% ' > ' %&% complete_i_ct_config) #save complete config
    
    #sbtach file topper
    i_align_sbatch_topper <- align_sbatch_topper %&% '\n' %&% '#SBATCH --error=' %&% 
      file.path(alignment_path, i_ct_name %&% '_align.error') %&% '\n' %&% 
      '#SBATCH --out=' %&% file.path(alignment_path, i_ct_name %&% '_align.out') %&% '\n' %&% '\n'

    #write command line
    i_align_call <- 'cd ' %&% i_ct_aligned_data %&% '\n\n' %&% 
      '/project/lbarreiro/SHARED/PROGRAMS/cellranger-7.0.1/cellranger multi ' %&% 
      '--id=' %&% i_run_id %&% ' ' %&% '--csv=' %&% complete_i_ct_config %&% ' ' %&% 
      '--jobmode=slurm' %&% '\n\n'
    
    #create sbatch file and write into it
    i_align_file <- file.path(alignment_path, i_run_id%&%'_cellranger_multi_job.sbatch')
    cat(i_align_sbatch_topper %&% '\n\n' %&% i_align_call, file=i_align_file, append=F)
    
    #launch job!
    i_align_launch_call <- 'sbatch ' %&% i_align_file
    system(i_align_launch_call) #launches the job into midway
    cat('submitted:', i_run_id, '\n')
  }
}