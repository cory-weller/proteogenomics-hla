#!/usr/bin/env Rscript

library(rjson)
library(foreach)
library(data.table)

files <- list.files('HLA_TYPES', pattern='*.json', full.names=T, recursive=T)

o <- foreach(file=files, .combine='rbind') %do% {
    id <- strsplit(basename(file), split='-')[[1]][2]
    json_data <- fromJSON(file=file)$hla$alleles
    dat <- data.table('id'=id, 'allele'=json_data)
    return(dat)
}

fwrite(o, file='HLA-types.tsv', quote=F, row.names=F, col.names=T, sep='\t')