
# coding: utf-8


import pandas as pd

# Read evidence genes

genes = pd.read_csv("coexpression/genes_by_locus.csv", sep=";")

# Read coexpression data

g2pml = pd.read_csv("coexpression/G2PMLData4IPDGC.csv", sep=";")


# Merge evidence genes and coexpression data

merged = pd.merge(genes, g2pml, on="GENE")

merged.to_csv("coexpression/Genes_g2pml_present_genes_by_locus.csv", index=False, sep=";")

