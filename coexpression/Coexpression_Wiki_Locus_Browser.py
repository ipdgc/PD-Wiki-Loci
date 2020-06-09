
# coding: utf-8

# In[13]:


import pandas as pd


# Read evidence genes

# In[14]:


genes = pd.read_csv("coexpression/genes_by_locus.csv", sep=";")


# Read coexpression data

# In[15]:


g2pml = pd.read_csv("coexpression/G2PMLData4IPDGC.csv", sep=";")


# Merge evidence genes and coexpression data

# In[19]:


merged = pd.merge(genes, g2pml, on="GENE")


# In[21]:


merged.to_csv("coexpression/Genes_g2pml_present_genes_by_locus.csv", index=False, sep=";")

