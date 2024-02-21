library(data.table)
library(tidyverse)
library(janitor)
library(ggpubr)
library(ggVennDiagram)
"%&%" <- function(a,b) paste(a,b, sep = "")

for (m in c('Stim16h', 'Stim4d', 'Unstim16h', 'Unstim4d')){
  if (m=='Stim16h'){
    tmp <- fread('vireo/Stim16h_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode %&% '_' %&% tmp$vireo_id
    
    tmp_2 <- fread('demuxalot/TCell1Stim16h/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode %&% '_' %&% tmp_2$demuxalot_id
    
    
    tmp_3 <- fread('souporcell/TCell1Stim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% inner_join(fread('souporcell/TCell1Stim16h/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(souporcell_id=Genotype_ID) %>% drop_na() %>% clean_names()
    tmp_3 <- tmp_3$barcode %&% '_' %&% tmp_3$souporcell_id
    
    a <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                  category.names=c('Vireo','Demuxalot','Souporcell'),
                  label='both',
                  label_percent_digit=1,
                  force_upset=F) + scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Stim16h')
    ggsave('stim16h_venn.pdf', plot=a, height=6, width=6)

  } else if (m=='Stim4d'){
    tmp <- fread('vireo/Stim4d_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode %&% '_' %&% tmp$vireo_id
    
    tmp_2 <- fread('demuxalot/TCell1Stim4d/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode %&% '_' %&% tmp_2$demuxalot_id
    
    
    tmp_3 <- fread('souporcell/TCell1Stim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% inner_join(fread('souporcell/TCell1Stim4d/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(souporcell_id=Genotype_ID) %>% drop_na() %>% clean_names()
    tmp_3 <- tmp_3$barcode %&% '_' %&% tmp_3$souporcell_id
    
    b <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                  category.names=c('Vireo','Demuxalot','Souporcell'),
                  label='both',
                  label_percent_digit=1,
                  force_upset=F) +scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Stim4d')
    
    ggsave('stim4d_venn.pdf', plot=b, height=6, width=6)
    
  } else if (m=='Unstim16h'){
    tmp <- fread('vireo/Unstim16h_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode %&% '_' %&% tmp$vireo_id
    
    tmp_2 <- fread('demuxalot/TCell1Unstim16h/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode %&% '_' %&% tmp_2$demuxalot_id
    
    
    tmp_3 <- fread('souporcell/TCell1Unstim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% inner_join(fread('souporcell/TCell1Unstim16h/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(souporcell_id=Genotype_ID) %>% drop_na() %>% clean_names()
    tmp_3 <- tmp_3$barcode %&% '_' %&% tmp_3$souporcell_id
    
    c <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                  category.names=c('Vireo','Demuxalot','Souporcell'),
                  label='both',
                  label_percent_digit=1,
                  force_upset=F) +scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Unstim16h')
    
    ggsave('unstim16h_venn.pdf', plot=c, height=6, width=6)
    
  } else {
    tmp <- fread('vireo/Unstim4d_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode %&% '_' %&% tmp$vireo_id
    
    tmp_2 <- fread('demuxalot/TCell1Unstim4d/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode %&% '_' %&% tmp_2$demuxalot_id
    
    
    tmp_3 <- fread('souporcell/TCell1Unstim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% inner_join(fread('souporcell/TCell1Unstim4d/Genotype_ID_key.txt', header=T), by=c('assignment'='Cluster_ID')) %>%
      select(barcode, Genotype_ID) %>% rename(souporcell_id=Genotype_ID) %>% drop_na() %>% clean_names()
    tmp_3 <- tmp_3$barcode %&% '_' %&% tmp_3$souporcell_id
    
    d <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                  category.names=c('Vireo','Demuxalot','Souporcell'),
                  label='both',
                  label_percent_digit=1,
                  force_upset=F) +scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Unstim4d')
    
    ggsave('unstim4d_venn.pdf', plot=d, height=6, width=6)
  }
}

ggarrange(c,d,a,b)
ggsave('allconditions_venn.pdf', height=10, width=10)

######

for (m in c('Stim16h', 'Stim4d', 'Unstim16h', 'Unstim4d')){
  if (m=='Stim16h'){
    tmp <- fread('vireo/Stim16h_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(!donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode
    
    tmp_2 <- fread('demuxalot/TCell1Stim16h/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(!demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode
    
    
    tmp_3 <- fread('souporcell/TCell1Stim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% filter(is.na(assignment))
    tmp_3 <- tmp_3$barcode
    
    a <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                       category.names=c('Vireo','Demuxalot','Souporcell'),
                       label='both',
                       label_percent_digit=1,
                       force_upset=F) + scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Stim16h - Unassigned')
    ggsave('stim16h_unassigned_venn.pdf', plot=a, height=6, width=6)
    
  } else if (m=='Stim4d'){
    tmp <- fread('vireo/Stim4d_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(!donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode
    
    tmp_2 <- fread('demuxalot/TCell1Stim4d/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(!demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode
    
    
    tmp_3 <- fread('souporcell/TCell1Stim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% filter(is.na(assignment))
    tmp_3 <- tmp_3$barcode
    
    b <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                       category.names=c('Vireo','Demuxalot','Souporcell'),
                       label='both',
                       label_percent_digit=1,
                       force_upset=F) + scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Stim4d - Unassigned')
    ggsave('stim4d_unassigned_venn.pdf', plot=a, height=6, width=6)
    
  } else if (m=='Unstim16h'){
    tmp <- fread('vireo/Unstim16h_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(!donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode
    
    tmp_2 <- fread('demuxalot/TCell1Unstim16h/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(!demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode
    
    
    tmp_3 <- fread('souporcell/TCell1Unstim16h/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% filter(is.na(assignment))
    tmp_3 <- tmp_3$barcode
    
    c <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                       category.names=c('Vireo','Demuxalot','Souporcell'),
                       label='both',
                       label_percent_digit=1,
                       force_upset=F) + scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Unstim16h - Unassigned')
    ggsave('unstim16h_unassigned_venn.pdf', plot=a, height=6, width=6)
    
    
  } else {
    tmp <- fread('vireo/Unstim4d_donor_ids.tsv') %>% select(cell, donor_id) %>% clean_names() %>%
      filter(!donor_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044')) %>%
      rename(barcode=cell, vireo_id=donor_id)
    tmp <- tmp$barcode
    
    tmp_2 <- fread('demuxalot/TCell1Unstim4d/assignments_refined.tsv', header=T) %>% 
      clean_names() %>% rename(demuxalot_id=x0) %>%
      filter(!demuxalot_id %in% c('AYM-4-002','CHI-0-105','MAP-9-083','QUE-4-034','QUE-4-044'))
    tmp_2 <- tmp_2$barcode
    
    
    tmp_3 <- fread('souporcell/TCell1Unstim4d/clusters.tsv', header=T) %>% select(barcode, assignment)
    tmp_3$assignment <- as.numeric(tmp_3$assignment)
    tmp_3 <- tmp_3 %>% filter(is.na(assignment))
    tmp_3 <- tmp_3$barcode
    
    d <- ggVennDiagram(list(tmp, tmp_2, tmp_3), 
                       category.names=c('Vireo','Demuxalot','Souporcell'),
                       label='both',
                       label_percent_digit=1,
                       force_upset=F) + scale_fill_gradient(low='grey',high='blue') +
      ggtitle('Unstim4d - Unassigned')
    ggsave('unstim4d_unassigned_venn.pdf', plot=a, height=6, width=6)
    
  }
}

ggarrange(c,d,a,b)
ggsave('allconditions_unassigned_venn.pdf', height=10, width=10)
