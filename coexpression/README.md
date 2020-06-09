# Add Co-Expression Data
#### Authors: Teresa Perinan, Kajsa Brolin
#### Date started: June 2020
#### Data: Coexpression data provided by Juan Botia and Mina Ryten

Description: Gene-based measures of tissue-specific gene expression and co-expression using the GTEx7 V6 gene expression dataset (47 tissues including all brain, accessible from https://www.gtexportal.org/home/). For each tissue, the following three columns can be found:

1) Expression specific: The gene is defined as having tissue-specific expression (=1) if the gene expression in that tissue was 3.5 fold higher than the average expression of all genes in that tissue.

2) Adjacent specific: The adjacency as a global network measure of connectivity for the gene is specific within the tissue. 1 is defined as the adjacency is 3.5 fold greater than the average expression of all genes in the tissue. 

3) Module membership: The module membership (local network measure of connectivity) within the co-expression network, is specific within the tissue. 1 is defined as that the module membership is 3.5 fold greater than the average module membership.

#### References:

Juan A. Botía et al: doi: 10.1186/s12918-017-0420-6

Juan A. Botía et al: doi: https://doi.org/10.1101/288845 (preprint)


#### RUN

·      locally

·      python ```coexpression/Coexpression_Wiki_Locus_Browser.py```

#### INPUT

·      a ```genes_by_locus.csv``` file in the parent directory containing all genes of interest and their locus number

·      a ```G2PMLData4IPDGC.csv``` in the parent directory containing the columns gene, ExprSpecificTISSUE, AdjSpecificAdjTISSUE and RankedMMSpecificRankMMTISSUE

#### OUTPUT

·      a ```Genes_g2pml_present_genes_by_locus.csv``` file in the parent directory containing the columns GENE, GWAS, LOC_NUM, TISSUE Expression, TISSUE Adjacency and TISSUE Module Membership grouped for each tissue

