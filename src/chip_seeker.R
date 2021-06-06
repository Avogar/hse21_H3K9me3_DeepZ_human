setwd("/home/avogar/Projects/bioinfa/project/hse21_H3K9me3_G4_human/src")

source('lib.R')

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

#BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
#BiocManager::install("ChIPseeker")
#BiocManager::install("org.Hs.eg.db")
#BiocManager::install("clusterProfiler")


library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(org.Hs.eg.db)
library(clusterProfiler)

names <-c('H3K9me3_MCF7.ENCFF501UHK.hg19.filtered',
          'H3K9me3_MCF7.ENCFF518MOR.hg19.filtered',
          'G4')

for (name in names)
{  
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
  bed_fn <- paste0(DATA_DIR, name, '.bed')
  peakAnno <- annotatePeak(bed_fn, tssRegion=c(-3000, 3000), TxDb=txdb, annoDb="org.Hs.eg.db")
  
  png(paste0(OUT_DIR, 'chip_seeker.', name, '.plotAnnoPie.png'))
  plotAnnoPie(peakAnno)
  dev.off()
}
