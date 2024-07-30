The DeepHACX code for the publication: "Interpretable Fine-Grained Phenotypes of Subcellular Dynamics via Unsupervised Deep Learning" Chuangqi Wang, Hee June Choi, Lucy Woodbury, Kwonmoo Lee

---
DeepHACX: Deep phenotyping of Heterogeneous Activities of subCellular dynamics with eXplanations
---


There are mainly seven steps involved in the DeepHACS Pipeline, which are saved in the subfolders here. Here, we listed all the customized codes to make others access easily.

Code Platforms: Matlab, Python, and R;
1. Matlab: Some visualization and velocity alignment codes were inherited from the Danuser Lab.
2. Python: The Teacher Model Training and Deep Feature Extraction.
3. R: Visualization.

0. Pre_processing
After acquiring the cell migration video using live cell microscopy, the cell protrusion regions were manually cropped as the targeted region of interest. Then, the cell boundary segmentation and windowing were applied to identify the subcellular protrusion velocity profiles using the windowing package in the Danuser Lab.
```{r}
#1. The subcellular velocity profiles using the customized windowing package from the Danuser lab.
# The package we used was saved in the folder: Pipeline/Matlab_CustomizedPackages
#Click the GUI

# The windowing package was implemented by GUI while the protrusion event detection was implemented as the function. 
#Please add the folder path in your Matlab environment as follows:
addpath(genpath('./Pipeline/Matlab_CustomizedPackages'))
```

1. Alignmentdata
The protrusion event detection from our previous paper: Lee, 2015, Cell Systems. The customized scripts were saved in the folder "1_alignmentdata'
```{r}
#1. Step 1 call the alignment script. 
#The script 'Call_alignmentdata.m'  was called to extract the alignment data. Here, please change the path to your saved datasets. After completion, the alignment velocity events were extracted based on the protrusion onsets and saved in a Matlab dataset file.
Call_alignmentdata.m
```

2. Preprocessing: In this step, we will interpolate the missing values, denoise the random noise and represent the raw protrusion velocity profile using the SAX representation techniques, which were described in detail in our previous paper: Wang, 2018, Nature Communications.
```{r}
Preprocessing.m
#In this script, there are three main sections: 1) interpolating the missing values; 2) denoising; 3) the SAX/PAA representation. 
#From here, the protrusion events were split into two groups: 1) shorter protrusion events (the duration of protrusion events is less than 51); 2) longer protrusion events (the duration of protrusion events is larger than 51)
```

3. Teacher Model (Clustering); Here, using the exampled dataset, the detailed steps were listed as follows:
```{r}
#1. applied the ACF (autocorrelation coefficients) to the truncated protrusion events (-5 ~ 51 frames (5s per frame)). 
Extract_ACF_features.m
#Inside this script, the Euclidean distance was calculated on the ACF features to estimate the sample similarity. The distance similarity matrix was calculated as the output.

#2. Perform the community clustering to determine the distinct phenotype.
./clustering/community_cluster.R 
#Here, the R script was used to get the clusters.

#3. Choose the optimal number of clusters using the Silhouette Value metric.
estimate_silhouette_value.m

#4. Evaluate the cluster performance based on the hyperparameter K in the community clustering algorithm.
evaluate_clusterresults.m

#5. Visualize the velocity profiles of the identified clusters.
visualizating_profiles.m
```

4. Student Features Learning (Regularized Bi-LSTM Autoencoder). In this folder, the regularized deep learning model was fitted on the dataset from the Teacher model. Here the Python and Keras deep learning python package was used to implement the model.
```{r}
#Main function: 
1. main_variable_length_classication_autoencoder.py

#Regularized Bi-LSTM Autoencoder, Supervised Encoder; Autoencoder Model structure.
2. LSTM_autoencoder2.py

#Using the fitted model, we can predict the deep features on the test dataset.
3. predict_DMSO3.py or predict_MCF10A.py

#Feature Interpretation using the SAGE SHAP model.
4. Encoder_SAGE_interpretation.py

#The dataset was saved in the "./dataset" folder.

#The model and fitted parameters were saved in the "variable_length_Mapping_Vel" folder.
```

5 Student Model (Clustering): Phenotype Identification. This section is similar to the Teacher Model. The main difference is that the involved features for clustering are different. Here, the deep features were used to identify the phenotypes.
```{r}
#1. applied the ACF (autocorrelation coefficients) to the truncated protrusion events (-5 ~ 51 frames (5s per frame)). 
Extract_DMSO_deepfeatures_features.m or extracting_Deep_ACF_information_v2.m
#Inside this script, the Euclidean distance was calculated on the ACF features to estimate the sample similarity. The distance similarity matrix was calculated as the output.

#2. Perform the community clustering to determine the distinct phenotype.
./clustering/community_cluster.R 
#Here, the R script was used to get the clusters.

#3. Choose the optimal number of clusters using the Silhouette Value metric.
estimate_silhouette_value.m

#4. Evaluate the cluster performance based on the hyperparameter K in the community clustering algorithm.
evaluate_clusterresults.m

#5. Visualize the velocity profiles of the identified clusters.
visualizating_profiles.m
```

6. Drug Sensitivity Analysis. The Call_Drug_sensitivity_Analysis.m script includes the following steps in detail.
```{r}
#1. Calculate the protrusion number per cell.
./6_1_Calculate_ProtrusionNumber_Per_cell/extract_total_numbersof_protrusionsamples_for_proportiontest.m

#2. Extract the information for the Proportion Test.
Extract_Drug_Treatment_testing_V2.

#3. Bootstrapping Tests were saved in the '6_2_Proportion_Test" folder.
compare_testing_all_clusters.m

#4. Estimate the effect size
test_calculate_effect_size.m
```

7. Cellular Phenotype Identification. Using the proportion of subcellular protrusion phenotypes, we could define the cellular phenotypes using the clustering idea.
```{r}
#1. Identify the cellular phenotypes 
Single_cell_clustering.Rmd

#2. Visualization Clustering.
Visualization_clustering.Rmd
Visualization_Proportion_clustering_finegrained.Rmd
Visualization_Proportion_finegrained_Burst_Acc.Rmd
```



