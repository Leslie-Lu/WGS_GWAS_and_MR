#!/usr/bin/env python3
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_plot_pca.py
# DESCRIPTION       : Plot PCA results
# DATE CREATED      : 2025-07-15
# PYTHON VERSION    : 3.12.10
################################################################################################
# DATE MODIFIED     : 2025-07-15
# REASON            : Initial version
################################################################################################

from doctest import FAIL_FAST
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
from typing import Optional

def plot_pca_plots(eigenvec_file: str, country_file: str, 
                   fig_path: Optional[str] = None, 
                   fig1_name: Optional[str] = None, 
                   fig2_name: Optional[str] = None,
                   fig3_name: Optional[str] = None,
                   save_figs: bool = False):
    """
    Plot pca plots of the principal components from PCA analysis.
    
    :param eigenvec_file: Path to the eigenvec file containing PCA results.
    :param country_file: Path to the CSV file containing country information.
    :param fig_path: Directory path where the figure will be saved.
    :param fig1_name: Name of the figure file to be saved.
    :param fig2_name: Name of the second figure file to be saved.
    :param fig3_name: Name of the third figure file to be saved.
    """

    pca_df = pd.read_table(eigenvec_file, sep='\\s+', header=0)
    country_df = pd.read_table(country_file, sep='\\s+', header=0)
    pca_country_df = pd.merge(pca_df, country_df, on='eid', how='left')
    
    # Fig1: Scatter plot of PC1 vs PC2 colored by country of birth
    # Define country code to name mapping
    country_code_to_name = {
        1: 'England',
        2: 'Wales',
        3: 'Scotland',
        4: 'Other'
    }
    value_counts = pca_country_df['Country_of_birth'].value_counts()
    label_mapping = {
        code: f"{country_code_to_name[code]} (N={value_counts[code]:,})"
        for code in sorted(value_counts.index)
    }
    sorted_hue_order = sorted(label_mapping.keys())
    new_hue_order = list(label_mapping.values())

    all_markers = ["P", "X", "D", "s", "*", "o", "^"]
    all_colors = ['#1f77b4', '#ff7f0e', '#9467bd', '#d62728', '#17becf', '#8c564b', '#2ca02c']
    num_hues = len(sorted_hue_order)
    markers_to_use = all_markers[:num_hues]
    palette_to_use = all_colors[:num_hues]
    
    # Create pairplot
    plt.figure(figsize=(15,10))
    g = sns.scatterplot(data=pca_country_df,
                        x="PC1",
                        y="PC2",
                        hue="Country_of_birth",
                        hue_order=sorted_hue_order,
                        style="Country_of_birth",
                        edgecolor=None,
                        palette=palette_to_use,
                        alpha=0.8,
                        s=10)
    new_hue_order = [label_mapping.get(label, label) for label in sorted_hue_order]

    handles, labels = g.get_legend_handles_labels()
    new_labels = new_hue_order
    for handle in handles:
            handle.set_markersize(4)
    g.legend(handles=handles, labels=new_labels, title="Country of birth", bbox_to_anchor=(.95, 1),
            frameon=False, borderaxespad=0.1)

    # Remove the top and right spines
    g.spines['top'].set_visible(False)
    g.spines['right'].set_visible(False)

    if save_figs:
        os.makedirs(os.path.dirname(fig_path), exist_ok=True)
        plt.savefig(os.path.join(fig_path, fig1_name + ".png"), dpi=600)
    plt.show()

    # Fig2: Scatter plot of PC1 vs PC2 colored by Ethnic background
    # Define country code to name mapping
    ethic_code_to_name = {
        1: 'White',
        2: 'Mixed',
        3: 'Asian or Asian British',
        4: 'Black or Black British',
        5: 'Chinese',
        6: 'Other ethnic group',
        7: 'Do not know'
    }
    value_counts_v2 = pca_country_df['Ethnic_background'].value_counts()
    label_mapping_v2 = {
        code: f"{ethic_code_to_name[code]} (N={value_counts_v2[code]:,})"
        for code in sorted(value_counts_v2.index)
    }
    sorted_hue_order_v2 = sorted(label_mapping_v2.keys())
    new_hue_order_v2 = list(label_mapping_v2.values())

    num_hues_v2 = len(sorted_hue_order_v2)
    markers_to_use_v2 = all_markers[:num_hues_v2]
    palette_to_use_v2 = all_colors[:num_hues_v2]

    # Create pairplot
    plt.figure(figsize=(15,10))
    g_v2 = sns.scatterplot(data=pca_country_df,
                            x="PC1",
                            y="PC2",
                            hue="Ethnic_background",
                            hue_order=sorted_hue_order_v2,
                            style="Ethnic_background",
                            edgecolor=None,
                            palette=palette_to_use_v2,
                            alpha=0.8,
                            s=10)
    new_hue_order_v2 = [label_mapping_v2.get(label, label) for label in sorted_hue_order_v2]

    handles, labels = g_v2.get_legend_handles_labels()
    new_labels = new_hue_order_v2
    for handle in handles:
            handle.set_markersize(4)
    g_v2.legend(handles=handles, labels=new_labels, title="Ethnic background", bbox_to_anchor=(.95, 1),
            frameon=False, borderaxespad=0.1)

    # Remove the top and right spines
    g_v2.spines['top'].set_visible(False)
    g_v2.spines['right'].set_visible(False)

    if save_figs:
        os.makedirs(os.path.dirname(fig_path), exist_ok=True)
        plt.savefig(os.path.join(fig_path, fig2_name + ".png"), dpi=600)
    plt.show()


    g = sns.pairplot(data=pca_country_df,
                     vars=["PC1", "PC2", "PC3", "PC4", "PC5"],
                     hue="Country_of_birth",
                     hue_order=sorted_hue_order,
                     markers=markers_to_use,
                     palette=palette_to_use,
                     height=2,
                     dropna=True,
                     corner=False,
                     plot_kws={"s":10, "alpha": 0.8},
                     diag_kind="auto")
    
    # Update legend texts
    for t, l in zip(g._legend.texts, new_hue_order):
        t.set_text(l)
    
    # Adjust legend
    legend = g._legend
    if legend is not None:
        for handle in legend.legend_handles:
            handle.set_markersize(4)
    
    g._legend.set_title("Country of birth")
    g._legend.set_bbox_to_anchor((1.1, .95))

    if save_figs: 
        g.savefig(os.path.join(fig_path, fig3_name + ".png"), dpi=600)
    plt.show()
    print("Done.")