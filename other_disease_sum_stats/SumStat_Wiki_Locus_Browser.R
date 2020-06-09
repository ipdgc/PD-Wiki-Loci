library(readr)


##1. Upload files

gwas_risk_variants <- read_csv("gwas_risk_variants.csv")
AD_sumstats_Jansenetal_2019sept <- read_delim("AD_sumstats_Jansenetal_2019sept.txt", 
                                              "\t", escape_double = FALSE, col_types = cols(dir = col_skip()), 
                                              trim_ws = TRUE)
alsMetaSummaryStats_march21st2018 <- read_delim("alsMetaSummaryStats_march21st2018.tab", 
                                              "\t", escape_double = FALSE, col_types = cols(Direction = col_skip()), 
                                              trim_ws = TRUE)

##2. Prepare files for merging

df = gwas_risk_variants[, c(9,8,1,3,2,4,6,7,5)]
df$CHR_BP = paste(df$CHR, "_", df$BP)

AD = AD_sumstats_Jansenetal_2019sept[, c(6:13)]

alsMetaSummaryStats_march21st2018$uniq_id = paste(alsMetaSummaryStats_march21st2018$CHR, 
                                                  "_", alsMetaSummaryStats_march21st2018$BP)

##Merge data frames by SNP rsID or by chr_bp combination

df_ad = merge(df, AD, by.x = 1, by.y = 1)
df_als = merge(df, alsMetaSummaryStats_march21st2018, by.x = 6, by.y = 18)

##Cleaning merged datasets and writing the files
df_als  = df_als [, -c(1, 10:12, 20:22)]

df_ad_f = df_ad[, c(1:5, 7:11, 15, 16, 14)]
df_als_f = df_als[, c(1:9, 11,10, 16)]

colnames(df_als_f) = c("RSID", "REF", "ALT", "CHR", "BP", "LOC_NUM", "NEAR_GENE", "GWAS", "Z", "P", "SE", "EAF")

write.table(df_ad_f, "sum_stat_AD.txt", quote = FALSE, col.names = TRUE, row.names = FALSE, sep = "\t")
write.table(df_als_f, "sum_stat_ALS.txt", quote = FALSE, col.names = TRUE, row.names = FALSE, sep = "\t")
