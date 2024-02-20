library(data.table)
library(tidyverse)
library(janitor)
library(ggpubr)

final.df <- data.frame(method=as.character(), condition=as.character(),
                       n_assigned=as.numeric(),n_unassigned=as.numeric(),
                       n_assigned_perc=as.numeric(),n_assigned_perc=as.numeric(),
                       total=as.numeric())

for (m in c('vireo', 'demuxalot', 'souporcell')){
  if (m=='vireo'){
    tmp <- fread('vireo/vireo_summary_s16h.csv') %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    final.df <- rbind(final.df, c('vireo', 'stim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))
    
    tmp <- fread('vireo/vireo_summary_s4d.csv') %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    final.df <- rbind(final.df, c('vireo', 'stim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))
    
    tmp <- fread('vireo/vireo_summary_u16h.csv') %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    final.df <- rbind(final.df, c('vireo', 'unstim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))
    
    tmp <- fread('vireo/vireo_summary_u4d.csv') %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    final.df <- rbind(final.df, c('vireo', 'unstim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))
    
  } else if (m=='demuxalot'){
    tmp <- fread('demuxalot/TCell1Stim16h/demuxalot_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('demuxalot', 'stim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))    
    
    tmp <- fread('demuxalot/TCell1Stim4d/demuxalot_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('demuxalot', 'stim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))     
    
    tmp <- fread('demuxalot/TCell1Unstim16h/demuxalot_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('demuxalot', 'unstim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))    
    
    tmp <- fread('demuxalot/TCell1Unstim4d/demuxalot_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('demuxalot', 'unstim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))     
    
  } else if (m=='souporcell'){
    tmp <- fread('souporcell/TCell1Stim16h/souporcell_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('souporcell', 'stim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))    
    
    tmp <- fread('souporcell/TCell1Stim4d/souporcell_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('souporcell', 'stim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned)) 
    
    tmp <- fread('souporcell/TCell1Unstim16h/souporcell_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('souporcell', 'unstim16h', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))    
    
    tmp <- fread('souporcell/TCell1Unstim4d/souporcell_summary.tsv', header=T) %>% clean_names()
    unassigned <- tmp %>% filter(classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()
    assigned <- tmp %>% filter(!classification %in% c('doublet', 'unassigned')) %>%
      pull(assignment_n) %>% sum()    
    final.df <- rbind(final.df, c('souporcell', 'unstim4d', assigned, unassigned,
                                  assigned/(assigned+unassigned), 
                                  unassigned/(assigned+unassigned),
                                  assigned+unassigned))      
  }
}

colnames(final.df) <- c('method', 'condition', 'n_assigned', 'n_unassigned',
                       'n_assigned_perc', 'n_unassigned_perc', 'total')
for (i in 3:ncol(final.df)){
  final.df[,i] <- as.numeric(final.df[,i])
}

ggplot(final.df, aes(x=condition, y=n_assigned_perc, fill=method)) + 
  geom_col(position='dodge') + theme_bw()
ggsave('n_assigned_perc_vs_condition_by_method.pdf', height=4, width=6)
fwrite(final.df, file='summary_all_methods.txt', sep='\t')
