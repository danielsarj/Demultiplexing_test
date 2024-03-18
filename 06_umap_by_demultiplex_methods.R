#load libraries
library(data.table)
library(tidyverse)
library(janitor)
library(ggpubr)

#load umap coords
u4d <- fread('../TCellUnstim4d_UMAPprojection.csv')
s4d <- fread('../TCellStim4d_UMAPprojection.csv')
u16h <- fread('../TCellUnstim16h_UMAPprojection.csv')
s16h <- fread('../TCellStim16h_UMAPprojection.csv')

#for every method, get barcode and donor_id
#join to umap coords and make a scatter plot
for (m in c('vireo', 'demuxalot', 'souporcell', 'demuxlet')){
  if (m=='vireo'){
    tmp <- fread('../vireo/Stim4d_donor_ids.tsv') %>% select(cell, donor_id) %>%
      inner_join(s4d, by=c('cell'='Barcode')) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    s4d_vireo <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim4d - Vireo')
    ggsave('../stim4dvireo.pdf', s4d_vireo, width=6, height=4)
    
    tmp <- fread('../vireo/Stim16h_donor_ids.tsv') %>% select(cell, donor_id) %>%
      inner_join(s16h, by=c('cell'='Barcode')) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    s16h_vireo <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim16h - Vireo')
    ggsave('../stim16hvireo.pdf', s16h_vireo, width=6, height=4)
    
    tmp <- fread('../vireo/Unstim4d_donor_ids.tsv') %>% select(cell, donor_id) %>%
      inner_join(u4d, by=c('cell'='Barcode')) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    u4d_vireo <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim4d - Vireo')
    ggsave('../unstim4dvireo.pdf', u4d_vireo, width=6, height=4)
    
    tmp <- fread('../vireo/Unstim16h_donor_ids.tsv') %>% select(cell, donor_id) %>%
      inner_join(u16h, by=c('cell'='Barcode')) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    u16h_vireo <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim16h - Vireo')
    ggsave('../unstim16hvireo.pdf', u16h_vireo, width=6, height=4)
    
  } else if (m=='demuxalot'){
    tmp <- fread('../demuxalot/TCell1Stim4d/assignments_refined.tsv.gz', header=T) %>% 
      inner_join(s4d, by=c('BARCODE'='Barcode')) %>% clean_names() %>% rename(donor_id=x0) %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    s4d_demuxalot <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim4d - Demuxalot')
    ggsave('../stim4ddemuxalot.pdf', s4d_demuxalot, width=6, height=4)
    
    tmp <- fread('../demuxalot/TCell1Stim16h/assignments_refined.tsv.gz', header=T) %>% 
      inner_join(s16h, by=c('BARCODE'='Barcode')) %>% clean_names() %>% rename(donor_id=x0) %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    s16h_demuxalot <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim16h - Demuxalot')
    ggsave('../stim16hdemuxalot.pdf', s16h_demuxalot, width=6, height=4)
    
    tmp <- fread('../demuxalot/TCell1Unstim4d/assignments_refined.tsv.gz', header=T) %>% 
      inner_join(u4d, by=c('BARCODE'='Barcode')) %>% clean_names() %>% rename(donor_id=x0) %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    u4d_demuxalot <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim4d - Demuxalot')
    ggsave('../unstim4ddemuxalot.pdf', u4d_demuxalot, width=6, height=4)
    
    tmp <- fread('../demuxalot/TCell1Unstim16h/assignments_refined.tsv.gz', header=T) %>% 
      inner_join(u16h, by=c('BARCODE'='Barcode')) %>% clean_names() %>% rename(donor_id=x0) %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    u16h_demuxalot <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim16h - Demuxalot')
    ggsave('../unstim16hdemuxalot.pdf', u16h_demuxalot, width=6, height=4)
    
  } else if (m=='souporcell'){
    tmp <- fread('../souporcell/TCell1Stim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp$assignment <- as.numeric(tmp$assignment)
    tmp <- tmp %>% inner_join(fread('../souporcell/TCell1Stim4d/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(donor_id=Genotype_ID) %>% drop_na() %>% inner_join(s4d, by=c('barcode'='Barcode')) %>% clean_names()
    s4d_souporcell <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim4d - Souporcell')
    ggsave('../stim4dsouporcell.pdf', s4d_souporcell, width=6, height=4)
    
    tmp <- fread('../souporcell/TCell1Stim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp$assignment <- as.numeric(tmp$assignment)
    tmp <- tmp %>% inner_join(fread('../souporcell/TCell1Stim16h/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(donor_id=Genotype_ID) %>% drop_na() %>% inner_join(s16h, by=c('barcode'='Barcode')) %>% clean_names()
    s16h_souporcell <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Stim16h - Souporcell')
    ggsave('../stim16hsouporcell.pdf', s16h_souporcell, width=6, height=4)
    
    tmp <- fread('../souporcell/TCell1Unstim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp$assignment <- as.numeric(tmp$assignment)
    tmp <- tmp %>% inner_join(fread('../souporcell/TCell1Unstim4d/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(donor_id=Genotype_ID) %>% drop_na() %>% inner_join(u4d, by=c('barcode'='Barcode')) %>% clean_names()
    u4d_souporcell <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim4d - Souporcell')
    ggsave('../unstim4dsouporcell.pdf', u4d_souporcell, width=6, height=4)
    
    tmp <- fread('../souporcell/TCell1Unstim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp$assignment <- as.numeric(tmp$assignment)
    tmp <- tmp %>% inner_join(fread('../souporcell/TCell1Unstim16h/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(donor_id=Genotype_ID) %>% drop_na() %>% inner_join(u16h, by=c('barcode'='Barcode')) %>% clean_names()
    u16h_souporcell <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim16h - Souporcell')
    ggsave('../unstim16hsouporcell.pdf', u16h_souporcell, width=6, height=4)
  } else if (m=='demuxlet'){
    tmp <- fread('../demuxlet/TCell1Unstim16h/demuxlet.best', header=T) %>% filter(DROPLET.TYPE=='SNG') %>% 
      select(BARCODE, BEST.GUESS) %>% clean_names() %>% rename(donor_id=best_guess)
    tmp <- tmp %>% separate(col=donor_id, sep=',', into=c('donor_id','a','b')) %>% select(barcode, donor_id)
    tmp <- tmp %>% inner_join(u16h, by=c('barcode'='Barcode')) %>% clean_names()
    u16h_demuxlet <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim16h - Demuxlet')
    ggsave('../unstim16hdemuxlet.pdf', u16h_demuxlet, width=6, height=4)
    
    tmp <- fread('../demuxlet/TCell1Unstim4d/demuxlet.best', header=T) %>% filter(DROPLET.TYPE=='SNG') %>% 
      select(BARCODE, BEST.GUESS) %>% clean_names() %>% rename(donor_id=best_guess)
    tmp <- tmp %>% separate(col=donor_id, sep=',', into=c('donor_id','a','b')) %>% select(barcode, donor_id)
    tmp <- tmp %>% inner_join(u4d, by=c('barcode'='Barcode')) %>% clean_names()
    u4d_demuxlet <- ggplot(tmp, aes(x=umap_1,y=umap_2, color=donor_id)) + geom_point() + 
      theme_bw() + ggtitle('Unstim4d - Demuxlet')
    ggsave('../unstim4ddemuxlet.pdf', u4d_demuxlet, width=6, height=4)
  }
}

#join plots
ggarrange(s16h_vireo, s16h_demuxalot, s16h_souporcell,
          s4d_vireo, s4d_demuxalot, s4d_souporcell,
          common.legend=T)
ggsave('../stim_umap_allmethods.pdf',width=12, height=8)

ggarrange(u16h_vireo, u16h_demuxalot, u16h_souporcell,
          u4d_vireo, u4d_demuxalot, u4d_souporcell,
          common.legend=T)
ggsave('../unstim_umap_allmethods.pdf',width=12, height=8)

ggarrange(u16h_vireo, u16h_demuxalot, u16h_souporcell, u16h_demuxlet,
          u4d_vireo, u4d_demuxalot, u4d_souporcell, u4d_demuxlet,
          common.legend=T, nrow=2, ncol=4)
ggsave('../unstim_umap_allmethods_wdemuxlet.pdf',width=12, height=8)

