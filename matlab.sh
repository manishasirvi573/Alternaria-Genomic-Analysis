#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, dendrogram
from scipy.spatial.distance import squareform
import re

# === Load file ===
file_path = "./results_mash_2/mash_distances.txt"
print(f"Reading: {file_path}")
df = pd.read_csv(file_path, sep='\t', header=None,
                names=['Sample1', 'Sample2', 'Distance', 'Pvalue', 'SharedHashes'])

# === Extract sample ID from paths ===
def extract_id(path):
    # For numeric sample IDs (e.g., /2_spades/ -> 2)
    match = re.search(r"/(\d+)_spades/", path)
    if match:
        return match.group(1)
    # For reference genomes (already properly named in bash script)
    # Extract the final part after the last slash
    return path.split('/')[-1].replace('.msh', '')

df['Sample1'] = df['Sample1'].apply(extract_id)
df['Sample2'] = df['Sample2'].apply(extract_id)

# === Create symmetric distance matrix ===
print("Creating distance matrix...")
dist_matrix = df.pivot(index='Sample1', columns='Sample2', values='Distance').fillna(0)
dist_matrix = dist_matrix.reindex(sorted(dist_matrix.columns), axis=1).reindex(sorted(dist_matrix.columns), axis=0)
dist_matrix = (dist_matrix + dist_matrix.T) / 2  # Force symmetry

# === Linkage calculation ===
print("Calculating linkage matrix...")
condensed_dist = squareform(dist_matrix.values)
linkage_matrix = linkage(condensed_dist, method='average')

# === Build labels ===
print("Preparing sample labels...")
sample_order = dist_matrix.index.tolist()
labels = sample_order  # Use sample IDs directly as labels

# === Plot dendrogram ===
print("Plotting dendrogram...")
plt.figure(figsize=(14, 8))
dendrogram(linkage_matrix, labels=labels, leaf_rotation=90)
plt.title("MASH Distance Dendrogram - Alternaria Species Analysis")
plt.xlabel("Sample ID")
plt.ylabel("MASH Distance")
plt.tight_layout()

# === Save outputs ===
output_png = "./results_mash_2/mash_dendrogram.png"
output_pdf = "./results_mash_2/mash_dendrogram.pdf"
plt.savefig(output_png, dpi=300, bbox_inches='tight')
plt.savefig(output_pdf, bbox_inches='tight')
print(f"Saved:\n- {output_png}\n- {output_pdf}")
plt.show()

print("✅ Dendrogram analysis complete!")
