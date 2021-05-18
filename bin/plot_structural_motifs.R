#!/usr/bin/Rscript

library(ggrepel)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)
title = args[1]
pdfname = paste(title,".pdf",sep="")

pdf( pdfname, width=9, height=6)

allData <- read.table( "structural_motifs.1000.forR.txx", header=TRUE, sep="\t", na.strings="NA", dec=".", strip.white=TRUE, comment.char='' )

allData$padj_rank <- as.integer(rownames(allData))

myplot <- ggplot(allData, aes(x=logCounts, y=logFoldChange, fill=p.label, size=1)) + geom_point(shape=21, color="black") + scale_fill_manual(values = c("grey50", "red")) + geom_text_repel(size=3, aes(label = ifelse(padj_rank<=20, as.character(motif),'')), nudge_x = 3, nudge_y=0.1, direction = "y", hjust = 1, segment.size = 0.2, force = 1.5) + theme(legend.position='none') + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))

print(myplot)

dev.off()



