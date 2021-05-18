---
title: "Formatting GWAS Meta Analysis Files for Conditional Locus Zoom Plot "
output: html_notebook
---

## Load in the required libraries. 
library(readr)
library(dplyr)
library(tidyr)

## Read the unformatted table.
meta5_sumstats<- read_tsv('/Users/ramiyasivakumar/hackathon/nallsEtAl2019_excluding23andMe_allVariants.tab')
head(meta5_sumstats)

## Last column must have N (number of samples). Sum up the values of 'N_cases' and 'N_controls' and store in N_sum.
N_sum <- meta5_sumstats$N_cases + meta5_sumstats$N_controls

## Create a new data frame using columns 1-7 from original table and the new N value.
nallsEtAl2019_excluding23andMe_allVariants <-data.frame(meta5_sumstats$SNP, meta5_sumstats$A1, meta5_sumstats$A2, meta5_sumstats$freq, meta5_sumstats$b, meta5_sumstats$se, meta5_sumstats$p, N_sum)
head(nallsEtAl2019_excluding23andMe_allVariants) 

## Split the values in column one into two parts(i.e chr1:1000000 --> chr1 1000000).
seperate_ma <- data.frame(do.call('rbind', strsplit(as.character(nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.SNP),':',fixed=TRUE)), nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.A1, nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.A2, nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.freq, nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.b, nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.se, nallsEtAl2019_excluding23andMe_allVariants$meta5_sumstats.p, nallsEtAl2019_excluding23andMe_allVariants$N_sum)
head(seperate_ma)

## Subset the data frame based on two criteria: X1 must be chr1 and X2 must be within a 2Mb window around variant.
chr1_ma <- subset(seperate_ma, X1 == 'chr1')
chr1_rs114138760_subset <- subset(chr1_ma, X2>153898185 & X2<155898185)
head(chr1_rs114138760_subset)

## Rename the header.
chr1_rs114138760_rename <- chr1_rs114138760_subset %>% 
  rename(
    A1 = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.A1,
    A2 = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.A2,
    freq = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.freq,
    b = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.b, 
    se = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.se, 
    p = nallsEtAl2019_excluding23andMe_allVariants.meta5_sumstats.p,
    N = nallsEtAl2019_excluding23andMe_allVariants.N_sum
    )

## Combine X1 and X2. 
rs114138760 <- chr1_rs114138760_rename %>% 
  unite(SNP, c("X1", "X2"), sep = ":")
head(rs114138760)

## Write the data frame into a tab seperated file. 
write.table(rs114138760, file='chr1_rs114138760.ma', quote=FALSE, sep='\t', row.names = FALSE)
