setwd("/home/avogar/Projects/bioinfa/project/hse21_H3K9me3_G4_human/src")

source('lib.R')

names <-c('H3K9me3_MCF7.ENCFF501UHK.hg19',
          'H3K9me3_MCF7.ENCFF501UHK.hg38',
          'H3K9me3_MCF7.ENCFF518MOR.hg19',
          'H3K9me3_MCF7.ENCFF518MOR.hg38',
          'G4',
          'H3K9me3_MCF7.intersect_with_G4')

for (name in names)
{
    bed_df <- read.delim(paste0(DATA_DIR, name, '.bed'), as.is = TRUE, header = FALSE)
    colnames(bed_df) <- c('chrom', 'start', 'end')
    bed_df$len <- bed_df$end - bed_df$start
    
    ggplot(bed_df) +
      aes(x = len) +
      geom_histogram() +
      ggtitle(name, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
      theme_bw()
    ggsave(paste0('len_hist.', name, '.pdf'), path = OUT_DIR)
}
