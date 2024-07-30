setwd("//research.wpi.edu/leelab/Chauncey/Projects/paper_unequal_length/Experiments_truncated_data_analysis/01-09-2020-All_DMSO_ACFFeatures")

library(devtools)

library(igraph)
# install.packages("loe")
library(loe)

require(R.matlab)
# ------------------------------------------------------------------------------------------------------------
# 1. Load the distance matrix
library(plyr)

filename <- "dist_euclidean.mat"
data_mat <-readMat(filename)
dist <- data_mat$dist.matrix

dat_dist <- as.matrix(dist)

for (K_par in seq(1050, 1500, 50)){
  # 2. Make a KNN graph based on euclidean distance
  dat_knn <- make.kNNG(dat_dist, k=K_par) 
  dim(dat_knn)

  # 3. Calculate adjacency matrix
  g_adj  <- graph.adjacency(dat_knn, mode="undirected", weighted=TRUE)

  # 4. Community detection on adjacency matirx
  imc <- cluster_infomap(g_adj)
  # imc <- cluster_louvain(g_adj) # seurat uses this one
  membership(imc)
  communities(imc)
  #plot(imc, g_adj)

  cluster <- as.factor(membership(imc))
  writeMat(paste("DMSO_total_", toString(K_par), "_truncated_community.mat"), cluster_label = as.vector(cluster))
}







