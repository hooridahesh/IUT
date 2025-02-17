# -*- coding: utf-8 -*-
"""HW5.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1y8S2PXicWI8U6WuS9fkDKyYvknDukYv4
"""

from google.colab import drive
drive.mount('/content/drive')

"""# **---------------------------------------------- Q4 ----------------------------------------------**

# **4-1**
"""

import warnings
warnings.filterwarnings('ignore')

import pandas as pd

dataframe=pd.read_csv('/content/drive/MyDrive/Wholesale customers data.csv')
dataframe.head()

dataframe.info()

"""# **4-2**"""

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
data_scaled = scaler.fit_transform(dataframe)

pca = PCA(n_components=2)
principal_components = pca.fit_transform(data_scaled)

df_pca = pd.DataFrame(data=principal_components, columns=['PC1', 'PC2'])

df_pca.to_csv('wholesale_customers_pca.csv', index=False)

df_pca.head()

"""# **4-3**"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import dendrogram, linkage
from scipy.cluster.hierarchy import fcluster

Z = linkage(df_pca, method='ward')

plt.figure(figsize=(17, 6))
dendrogram(Z)
plt.title('Dendrogram using Ward\'s method')
plt.xlabel('Samples')
plt.ylabel('Distance')
plt.show()

max_d = 7
clusters = fcluster(Z, max_d, criterion='distance')

print(f'\nEstimated number of clusters: {len(np.unique(clusters))}')

"""# **4-4**"""

from sklearn.cluster import AgglomerativeClustering
from sklearn.metrics import silhouette_score

silhouette_scores = []

for k in range(2, 26):
    clustering = AgglomerativeClustering(n_clusters=k)
    labels = clustering.fit_predict(df_pca)
    silhouette_avg = silhouette_score(df_pca, labels)
    silhouette_scores.append(silhouette_avg)

plt.figure(figsize=(15, 6))
plt.bar(range(2, 26), silhouette_scores, color='skyblue')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('Silhouette Score')
plt.title('Silhouette Scores for Different Numbers of Clusters')
plt.show()

best_k = np.argmax(silhouette_scores) + 2
print(f'\nThe best number of clusters is {best_k} with a silhouette score of {silhouette_scores[best_k-2]:.4f}')

"""# **4-5**"""

best_k = 4

clustering = AgglomerativeClustering(n_clusters=best_k)
labels = clustering.fit_predict(df_pca)

pca = PCA(n_components=2)
data_pca = pca.fit_transform(df_pca)

plt.figure(figsize=(15, 6))
for cluster in np.unique(labels):
    plt.scatter(data_pca[labels == cluster, 0], data_pca[labels == cluster, 1], label=f'Cluster {cluster + 1}')
plt.title(f'Scatter Plot of Clusters (k = {best_k})')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.legend()
plt.show()

"""# **4-6**"""

from sklearn.manifold import TSNE

tsne = TSNE(n_components=2, random_state=42)
data_tsne = tsne.fit_transform(data_scaled)


plt.figure(figsize=(15, 6))
plt.scatter(data_tsne[:, 0], data_tsne[:, 1], c='skyblue', edgecolor='k')
plt.title('t-SNE visualization of Wholesale customers data')
plt.xlabel('Dimension 1')
plt.ylabel('Dimension 2')
plt.show()

"""# **4-7**"""

from sklearn.cluster import DBSCAN

eps_values = np.arange(0.5,3,0.5)
min_samples_values = range(5,20,5)

fig, axs = plt.subplots(len(eps_values), len(min_samples_values), figsize=(15, 12))

for i, eps in enumerate(eps_values):
    for j, min_samples in enumerate(min_samples_values):
        dbscan = DBSCAN(eps=eps, min_samples=min_samples)
        cluster_labels = dbscan.fit_predict(data_tsne)

        axs[i, j].scatter(data_tsne[:, 0], data_tsne[:, 1], c=cluster_labels, cmap='viridis')
        axs[i, j].set_title(f'eps={eps}, min_samples={min_samples}')
        axs[i, j].set_xlabel('Feature 1')
        axs[i, j].set_ylabel('Feature 2')

plt.tight_layout()
plt.show()

dbscan_default = DBSCAN()
cluster_labels_default = dbscan_default.fit_predict(data_tsne)
best_avg_points = np.mean(np.bincount(cluster_labels_default + 1))

best_eps = None
best_min_samples = None
best_avg_points = 0

for eps in eps_values:
    for min_samples in min_samples_values:
        dbscan = DBSCAN(eps=eps, min_samples=min_samples)
        cluster_labels = dbscan.fit_predict(data_tsne)
        unique_labels, counts = np.unique(cluster_labels, return_counts=True)
        avg_points = np.mean(counts)

        if avg_points > best_avg_points:
            best_avg_points = avg_points
            best_eps = eps
            best_min_samples = min_samples

print("Best eps:", best_eps)
print("Best min_samples:", best_min_samples)

dbscan_best = DBSCAN(eps=best_eps, min_samples=best_min_samples)
cluster_labels_best = dbscan_best.fit_predict(data_tsne)

plt.figure(figsize=(16, 5))
plt.scatter(data_tsne[:, 0], data_tsne[:, 1], c=cluster_labels_best, cmap='viridis')
plt.title('DBSCAN Clustering with Best Parameters')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.show()

"""# **4-8**"""

from sklearn.neighbors import NearestNeighbors

nearest_neighbors = NearestNeighbors(n_neighbors=5)
neighbors = nearest_neighbors.fit(data_tsne)
distances, indices = neighbors.kneighbors(data_tsne)

distances = np.sort(distances[:, 4], axis=0)

plt.figure(figsize=(16, 5))
plt.plot(distances)
plt.title('k-NN Distance Graph')
plt.xlabel('Points sorted by distance')
plt.ylabel('5th Nearest Neighbor Distance')
plt.show()

best_eps = None
best_min_samples = None
best_avg_points = 0

eps_values = distances[np.linspace(0, len(distances) - 1, num=10).astype(int)]
min_samples_values = range(3, 10)

for eps in eps_values:
    for min_samples in min_samples_values:
        dbscan = DBSCAN(eps=eps, min_samples=min_samples)
        cluster_labels = dbscan.fit_predict(data_tsne)
        unique_labels, counts = np.unique(cluster_labels, return_counts=True)
        avg_points = np.mean(counts)

        if avg_points > best_avg_points:
            best_avg_points = avg_points
            best_eps = eps
            best_min_samples = min_samples

print("\n----------------------------------------------------")
print("Best eps:", best_eps)
print("Best min_samples:", best_min_samples)
print("----------------------------------------------------\n")


dbscan_best = DBSCAN(eps=best_eps, min_samples=best_min_samples)
cluster_labels_best = dbscan_best.fit_predict(data_tsne)

plt.figure(figsize=(16, 5))
plt.scatter(data_tsne[:, 0], data_tsne[:, 1], c=cluster_labels_best, cmap='viridis')
plt.title('DBSCAN Clustering with Best Parameters')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.show()

"""# **---------------------------------------------- Q5 ----------------------------------------------**

# **5-1**
"""

dataframe2=pd.read_csv('/content/drive/MyDrive/EastWestAirlines.csv')
dataframe.head()

from sklearn.metrics import silhouette_score
from sklearn.cluster import AgglomerativeClustering

scaler = StandardScaler()
data_scaled = scaler.fit_transform(dataframe2)

Z = linkage(data_scaled, method='ward', metric='euclidean')

plt.figure(figsize=(15, 6))
dendrogram(Z)
plt.title('Dendrogram')
plt.xlabel('Data Points')
plt.ylabel('Euclidean Distance')
plt.show()

max_clusters = 20

silhouette_scores = []

for n_clusters in range(2, max_clusters+1):
    clustering = AgglomerativeClustering(n_clusters=n_clusters, linkage='ward', affinity='euclidean')
    cluster_labels = clustering.fit_predict(data_scaled)
    silhouette_avg = silhouette_score(data_scaled, cluster_labels)
    silhouette_scores.append(silhouette_avg)

plt.figure(figsize=(15, 6))
plt.plot(range(2, max_clusters+1), silhouette_scores, marker='o')
plt.title('Silhouette Score vs. Number of Clusters')
plt.xlabel('Number of Clusters')
plt.ylabel('Silhouette Score')
plt.xticks(range(2, max_clusters+1))
plt.grid(True)
plt.show()

"""# **5-3**"""

from scipy.cluster.hierarchy import fcluster

max_clusters = 20

best_num_clusters = 16

clustering = AgglomerativeClustering(n_clusters=best_num_clusters, linkage='ward', affinity='euclidean')
cluster_labels = clustering.fit_predict(data_scaled)

cluster_centers = []
for cluster_label in range(best_num_clusters):
    cluster_center = data_scaled[cluster_labels == cluster_label].mean(axis=0)
    cluster_centers.append(cluster_center)

cluster_labels = fcluster(Z, t=best_num_clusters, criterion='maxclust')

for i, center in enumerate(cluster_centers):
    print(f"ویژگی‌های مرکز خوشه {i+1}:\n{center}")
    print(f"برچسب خوشه {i+1}:\n{cluster_labels[i]}")
    print("------------------------------------------------------------------------------")

import matplotlib.pyplot as plt

colors = ['red', 'blue', 'green', 'orange', 'purple', 'cyan', 'magenta', 'yellow', 'brown', 'pink']

plt.figure(figsize=(15, 6))
for i, center in enumerate(cluster_centers):
    plt.scatter(center[0], center[1], label=f'Cluster {i+1} Center', marker='x', s=100, c=colors[i % len(colors)])
plt.title('Cluster Centers')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.legend()
plt.show()

"""# **5-4**"""

data_random_5percent = dataframe2.sample(frac=0.05, random_state=42)
data_remainder_95percent = dataframe2.drop(data_random_5percent.index)

scaler = StandardScaler()
data_scaled2 = scaler.fit_transform(data_remainder_95percent)

Z = linkage(data_scaled2, method='ward', metric='euclidean')

plt.figure(figsize=(15, 6))
dendrogram(Z)
plt.title('Dendrogram')
plt.xlabel('Data Points')
plt.ylabel('Euclidean Distance')
plt.show()

max_clusters = 20

silhouette_scores = []

for n_clusters in range(2, max_clusters+1):
    clustering = AgglomerativeClustering(n_clusters=n_clusters, linkage='ward', affinity='euclidean')
    cluster_labels = clustering.fit_predict(data_scaled2)
    silhouette_avg = silhouette_score(data_scaled2, cluster_labels)
    silhouette_scores.append(silhouette_avg)

plt.figure(figsize=(15, 6))
plt.plot(range(2, max_clusters+1), silhouette_scores, marker='o')
plt.title('Silhouette Score vs. Number of Clusters')
plt.xlabel('Number of Clusters')
plt.ylabel('Silhouette Score')
plt.xticks(range(2, max_clusters+1))
plt.grid(True)
plt.show()

max_clusters = 20

best_num_clusters = 16

clustering = AgglomerativeClustering(n_clusters=best_num_clusters, linkage='ward', affinity='euclidean')
cluster_labels = clustering.fit_predict(data_scaled2)

cluster_centers2 = []
for cluster_label in range(best_num_clusters):
    cluster_center = data_scaled2[cluster_labels == cluster_label].mean(axis=0)
    cluster_centers2.append(cluster_center)

cluster_labels = fcluster(Z, t=best_num_clusters, criterion='maxclust')

for i, center in enumerate(cluster_centers2):
    print(f"ویژگی‌های مرکز خوشه {i+1}:\n{center}")
    print(f"برچسب خوشه {i+1}:\n{cluster_labels[i]}")
    print("------------------------------------------------------------------------------")

colors = ['red', 'blue', 'green', 'orange', 'purple', 'cyan', 'magenta', 'yellow', 'brown', 'pink']

plt.figure(figsize=(15, 6))
for i, center in enumerate(cluster_centers2):
    plt.scatter(center[0], center[1], label=f'Cluster {i+1} Center', marker='x', s=100, c=colors[i % len(colors)])
plt.title('Cluster Centers')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.legend()
plt.show()

"""# **5-5**"""

from sklearn.cluster import KMeans

num_clusters = 16

kmeans = KMeans(n_clusters=num_clusters, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled)

plt.figure(figsize=(15, 6))
plt.scatter(data_scaled[:, 0], data_scaled[:, 1], c=cluster_labels, cmap='viridis', marker='o', alpha=0.7)
plt.title('Clustered Data')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.show()

num_clusters = 16

kmeans = KMeans(n_clusters=num_clusters, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled)

cluster_centers = kmeans.cluster_centers_

for i, center in enumerate(cluster_centers):
    print(f"ویژگی‌های مرکز خوشه {i+1}:\n{center}")
    print("---------------------------------------------------------------------------------")

plt.figure(figsize=(15, 6))
for i, center in enumerate(cluster_centers):
    plt.scatter(center[0], center[1], label=f'Cluster {i+1} Center', marker='x', s=100)
plt.title('Cluster Centers')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.legend()
plt.show()

"""**-------------------------------------------------The second mode--------------------------------------------------------------**"""

num_clusters = 16

kmeans = KMeans(n_clusters=num_clusters, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled2)

plt.figure(figsize=(15, 6))
plt.scatter(data_scaled2[:, 0], data_scaled2[:, 1], c=cluster_labels, cmap='viridis', marker='o', alpha=0.7)
plt.title('Clustered Data')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.show()

num_clusters = 16

kmeans = KMeans(n_clusters=num_clusters, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled2)

cluster_centers2 = kmeans.cluster_centers_

for i, center in enumerate(cluster_centers2):
    print(f"ویژگی‌های مرکز خوشه {i+1}:\n{center}")
    print("---------------------------------------------------------------------------------")

plt.figure(figsize=(15, 6))
for i, center in enumerate(cluster_centers2):
    plt.scatter(center[0], center[1], label=f'Cluster {i+1} Center', marker='x', s=100)
plt.title('Cluster Centers')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.legend()
plt.show()

"""# **5-6**"""

k_values = range(1, 26)

sse = []

for k in k_values:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(data_scaled)
    sse.append(kmeans.inertia_)

plt.figure(figsize=(15, 6))
plt.plot(k_values, sse, marker='o', linestyle='-')
plt.title('Elbow Method for Optimal k')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('SSE (Sum of Squared Errors)')
plt.xticks(range(1, 26))
plt.grid(True)
plt.show()

# slope_changes = [sse[i] - sse[i-1] for i in range(1, len(sse))]
# elbow_index = slope_changes.index(max(slope_changes)) + 1
# best_k = elbow_index + 1
# print(f"\nThe optimal value of k is: {best_k}")
# ----------------------------------------------------------------------------
# elbow_index = sse.index(min(sse)) + 1
# best_k = elbow_index
# print(f"The optimal value of k is: {best_k}")

"""# **5-7**"""

from sklearn.metrics import silhouette_score

k_values = range(2, 26)

silhouette_scores = []

for k in k_values:
    kmeans = KMeans(n_clusters=k, random_state=42)
    cluster_labels = kmeans.fit_predict(data_scaled)
    silhouette_avg = silhouette_score(data_scaled, cluster_labels)
    silhouette_scores.append(silhouette_avg)

plt.figure(figsize=(15, 6))
plt.bar(k_values, silhouette_scores)
plt.title('Silhouette Score vs. Number of Clusters')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('Silhouette Score')
plt.xticks(range(2, 26))
plt.grid(True)
plt.show()

best_k2 = k_values[silhouette_scores.index(max(silhouette_scores))]
print(f"The optimal value of k is: {best_k}")

"""# **5-8**"""

best_k = 8  # or 7

kmeans = KMeans(n_clusters=best_k, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled)

plt.figure(figsize=(15, 6))
plt.scatter(data_scaled[:, 0], data_scaled[:, 1], c=cluster_labels, cmap='viridis')
plt.title(f'Clustering Result with k={best_k} (Elbow Method)')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.grid(True)
plt.show()

best_k2 = 2

kmeans = KMeans(n_clusters=best_k2, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled)

plt.figure(figsize=(15, 6))
plt.scatter(data_scaled[:, 0], data_scaled[:, 1], c=cluster_labels, cmap='viridis')
plt.title(f'Clustering Result with k={best_k2} (Silhouette Score)')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.colorbar(label='Cluster')
plt.grid(True)
plt.show()