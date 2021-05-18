#!/usr/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)
inputFile <- args[1]
d <- read.table(inputFile,header=FALSE,sep="\t")
e <- d[,3:6]
pval <- apply(e, 1, function(x) {fisher.test(matrix(x, 2, 2))$p.value;} )
padj <- p.adjust(pval, method="BH")
h <- cbind(d,pval,padj)
i <- data.frame(h)
j <- i[order(padj),]

write.table(j, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

