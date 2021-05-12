########################
## Ruifeng Hu
## BWH, Harvard Medical School, Boston
## GP2/IPDGC Hackathon 2021
## 05-12-2021
#########################

import os
import sys
import pandas as pd

###################
## Violin plot
###################

import seaborn as sns
import matplotlib.pyplot as plt
sns.set(style='ticks')

gene_baseline_expr_row_samples_df = pd.read_csv("gene_expression_and_sample_info.tsv",index_col=0,header=0,sep="\t")

result_folder = "violin_plots"
if not os.path.exists(result_folder):
    os.mkdir(result_folder)

gene_ls = gene_baseline_expr_row_samples_df.columns[:-6]

for gene_i in gene_ls:
    print(f"ploting {gene_i} ...")
    gene_df = gene_baseline_expr_row_samples_df.loc[:,[gene_i,"group"]]
    gene_df[gene_i]=gene_df[gene_i].astype('float64')
    ax = sns.violinplot(x="group", y=gene_i, data=gene_df,order=["Case","Control","Genetic carrier"])
    ax.set_xlabel("Group")
    ax.set_ylabel("Expression of " + gene_i + " (TPM)")
    plt.savefig(result_folder+ "/"+gene_i+".png")
    plt.close()

