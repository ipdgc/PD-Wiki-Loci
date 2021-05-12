import os
import sys
import pandas as pd

#################
## Load data
#################
case_control_df = pd.read_csv("amp_pd_case_control.csv",index_col=0,header=0)
print(case_control_df.shape)
## Only keep Case/Control
case_control_df = case_control_df.loc[case_control_df['case_control_other_latest'].isin(['Case','Control']),:]
print(case_control_df.shape)

mutation_df = pd.read_csv("PD_mutation.csv",index_col=0,header=0)
print(mutation_df.shape)
## Only keep genetics carriers
mutation_df = mutation_df.loc[mutation_df['has_known_PD_mutation_in_WGS']=='Yes',:]
print(mutation_df.shape)

samples_df = pd.read_csv("rna_seq_samples.csv",index_col='sample_id',header=0)
print(samples_df.shape)
## Only keep baseline samples
samples_df = samples_df.loc[(samples_df['visit_month'] < 1.0),:]
print(samples_df.shape)

## load the gene expression matrix
gene_expr_df = pd.read_csv("gene_expr_matrix_tpm_row_genes.txt",index_col=0,header=0,sep="\t")
print(gene_expr_df.shape)

##################################
## get sub gene expression matrix
###################################

## merge sample information, classify samples into groups: Case, Control ,Genetic carrier
samples_full_df = pd.merge(samples_df,case_control_df, how="inner", left_on='participant_id', right_index= True)
samples_full_df = pd.merge(samples_full_df,mutation_df, how="left", left_on='participant_id', right_index= True)
samples_full_df['group'] = samples_full_df['case_control_other_latest']
samples_full_df.loc[samples_full_df['has_known_PD_mutation_in_WGS']=='Yes','group'] = 'Genetic carrier'
samples_full_df.to_csv("sample_info.csv")

## read gene list
gene_list_df= pd.read_csv("Gene_list.csv",index_col=0,header=0)
gene_ls = list(set(gene_list_df.index)) #2361

## map Ensembl ID to gene symbols
gene_annotation_df = pd.read_csv("genes_annotation.tsv",index_col=None,header=0,sep="\t")

join_df = pd.merge(gene_list_df,gene_annotation_df,how="inner", left_index=True,right_on=['gene_name'])
join_df.set_index('gene_id', inplace=True)
ensemblid_genename_df = join_df.loc[:,['gene_name']]

## baseline expression matrix
gene_baseline_expr_df = pd.merge(gene_expr_df,ensemblid_genename_df,"inner",left_index=True,right_index=True)
gene_baseline_expr_df.drop_duplicates(['gene_name'],inplace=True)
gene_baseline_expr_df.index = gene_baseline_expr_df['gene_name']

gene_baseline_expr_row_samples_df = gene_baseline_expr_df.T
gene_baseline_expr_row_samples_df = pd.merge(gene_baseline_expr_row_samples_df,samples_full_df,"inner",left_index=True,right_index=True)
gene_baseline_expr_row_samples_df.to_csv("gene_expression_and_sample_info.csv")

###################
## Violin plot
###################

import seaborn as sns
import matplotlib.pyplot as plt
sns.set(style='ticks')

gene_baseline_expr_row_samples_df = pd.read_csv("gene_expression_and_sample_info.csv",index_col=0,header=0)

result_folder = "violin_plots"
if not os.path.exists(result_folder):
    os.mkdir(result_folder)

gene_ls = gene_baseline_expr_row_samples_df.columns[:-6]
for gene_i in gene_ls:
    gene_df = gene_baseline_expr_row_samples_df.loc[:,[gene_i,"group"]]
    gene_df[gene_i]=gene_df[gene_i].astype('float64')
    ax = sns.violinplot(x="group", y=gene_i, data=gene_df,order=["Case","Control","Genetic carrier"])
    ax.set_xlabel("Group")
    ax.set_ylabel("Expression of " + gene_i + " (TPM)")
    plt.savefig(result_folder+ "/"+gene_i+".png")
    plt.close()