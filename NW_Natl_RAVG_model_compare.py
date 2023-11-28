"""
Program: NW_Natl_RAVG_model_compare.py
Author:Ali Reiner

The purpose of this program is visualize various RAVG models
This version uses a pre-generated lookup tables

requires .xlsx lookup tables as input

10/23/2023
"""

import numpy as np
import pandas as pd
#import os
import matplotlib.pyplot as plt
import seaborn as sns
import openpyxl



df_lookup=pd.read_excel(r'C:\ali_working\!GTAC\RAVG\NW_IA\output\Lookup.CBIcombinedV2.xlsx')
#print(df_lookup)
df_lookup2=df_lookup.rename(columns={'Lookup.NW.CBI.EA$yest.CBI.EA': 'NW.EA.CBI', 'Lookup.NW.CBI.IA$yest.CBI.IA': 'NW.IA.CBI'})
print(df_lookup2.head(3))

#clear plots
plt.clf()

# Create a Seaborn line plot with different markers for each product
sns.lineplot(x='RDNBR', y='NatEA.CBI', data=df_lookup2, color='teal', label='Nat EA CBI')
sns.lineplot(x='RDNBR', y='NatIA.CBI', data=df_lookup2, color='blue', label='Nat IA CBI')
sns.lineplot(x='RDNBR', y='NW.EA.CBI', data=df_lookup2, color='salmon', label='NW EA CBI')
sns.lineplot(x='RDNBR', y='NW.IA.CBI', data=df_lookup2, color='red', label='NW IA CBI')
# Set plot title and axes labels
plt.title('CBI Models')
plt.xlabel('RdNBR')
plt.ylabel('CBI')
 
# Show the plot
plt.show()



#Also do SW CBI plots in python so same graph format, note IA uses dNBR and EA RBR, so need separate graphs


# IA SW CBI plot

df_lookupSWIA=pd.read_excel(r'C:\ali_working\!GTAC\RAVG\NW_IA\output\SWdata\Lookup_CBI_IA.xlsx')
#rescale CBI from 1 to 3
df_lookupSWIA['meanCBI_3'] = df_lookupSWIA['meanCBI']*3

print(df_lookupSWIA.head(3))

#clear plots
plt.clf()

# Create a Seaborn line plot with different markers for each product
sns.lineplot(x='dNBR', y='meanCBI_3', data=df_lookupSWIA, color='purple', label='SW IA CBI')

# Set plot title and axes labels
plt.title('SW IA CBI Model')
plt.xlabel('dNBR')
plt.ylabel('CBI')
 
# Show the plot
plt.show()


# EA SW CBI plot

df_lookupSWEA=pd.read_excel(r'C:\ali_working\!GTAC\RAVG\NW_IA\output\SWdata\Lookup_CBI_EA.xlsx')
#rescale CBI from 1 to 3
df_lookupSWEA['meanCBI_3'] = df_lookupSWEA['meanCBI']*3
print(df_lookupSWEA.head(3))

#clear plots
plt.clf()

# Create a Seaborn line plot with different markers for each product
sns.lineplot(x='RBR', y='meanCBI_3', data=df_lookupSWEA, color='navy', label='SW EA CBI')

# Set plot title and axes labels
plt.title('SW EA CBI Model')
plt.xlabel('RBR')
plt.ylabel('CBI')
 
# Show the plot
plt.show()



