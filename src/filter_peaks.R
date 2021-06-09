setwd("/home/avogar/Projects/bioinfa/project/hse21_H3K9me3_ZDNA_human/src")

source('lib.R')

names <-c('H3K9me3_MCF7.ENCFF501UHK.hg19',
          'H3K9me3_MCF7.ENCFF518MOR.hg19')

for (name in names)
{
    bed_df <- read.delim(paste0(DATA_DIR, name, '.bed'), as.is = TRUE, header = FALSE)
    colnames(bed_df) <- c('chrom', 'start', 'end', 'name', 'score')
    bed_df$len <- bed_df$end - bed_df$start
    head(bed_df)
    
    ggplot(bed_df) +
      aes(x = len) +
      geom_histogram() +
      ggtitle(name, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
      theme_bw()
    ggsave(paste0('filter_peaks.', name, '.init.hist.png'), path = OUT_DIR, device = 'png')
    
    # Remove long peaks
    bed_df <- bed_df %>%
      arrange(-len) %>%
      filter(len < 5000)
      
    ggplot(bed_df) +
      aes(x = len) +
      geom_histogram() +
      ggtitle(name, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
      theme_bw()
    ggsave(paste0('filter_peaks.', name, '.filtered.hist.png'), path = OUT_DIR, device = 'png')
    
    bed_df %>%
      select(-len) %>%
      write.table(file=paste0(DATA_DIR, name ,'.filtered.bed'),
                col.names = FALSE, row.names = FALSE, sep = '\t', quote = FALSE)
}
