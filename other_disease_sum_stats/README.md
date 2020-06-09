# Add Frequencies and Summary Statistics for other Neurological Diseases
Authors: Xylena Reed, Anastasia Illarionova

#### Data description:

GWAS summary statistics from studies of neurodegenerative disorders for 94 PD associated sentiel SNPs.
Data available from AD [1] and ALS [2] GWAS.

#### References:

[1] Jansen, I.E., Savage, J.E., Watanabe, K. et al. Genome-wide meta-analysis identifies new loci and functional pathways influencing Alzheimer’s disease risk. Nat Genet 51, 404–413 (2019). https://doi.org/10.1038/s41588-018-0311-9

[2] Nicolas, A., Kenna, K.P., Renton, A.E. et al. Genome-wide Analyses Identify KIF5A as a Novel ALS Gene. Neuron 97, 1268-1283.e6 (2018). https://doi.org/10.1016/j.neuron.2018.02.027.

---
## SCRIPT INFO

#### RUN

·      ```SumStat_Wiki_Locus_Browser.R```

#### INPUT

The following should be present in the working directory:

·      ```gwas_risk_variants.csv``` file containing PD GWAS sentinel SNPs with chromosome coordinates and locus numbers from the PD-Wiki-Browser 

·      ```AD_sumstats_Jansenetal_2019sept.txt``` file with a summary statistics from AD GWAS

·      ```alsMetaSummaryStats_march21st2018.tab``` file with a summary statistics from ALS GWAS

#### OUTPUT

·      ```sum_stat_AD.txt``` tab delimited file with AD summary statistics subseted for SNPs from gwas_risk_variants.csv file. "RSID", "REF", "ALT", "CHR", "BP", "LOC_NUM", "NEAR_GENE", "GWAS", "Z", "P", "BETA", "SE", "EAF" columns are kept.

·      ```sum_stat_ALS.txt``` tab delimited file with ALS summary statistics subseted for SNPs from gwas_risk_variants.csv file. "RSID", "REF", "ALT", "CHR", "BP", "LOC_NUM", "NEAR_GENE", "GWAS", "Z", "P", "SE", "EAF" columns are kept.
