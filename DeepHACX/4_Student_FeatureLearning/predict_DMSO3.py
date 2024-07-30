"""
The main function calling the defined function by myself.
"""
import numpy as np
import os
#Set the level of the prompt information
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
os.environ["CUDA_VISIBLE_DEVICES"] = "2"

import sys
sys.path.insert(0, './LSTM_autoencoder')
from LSTM_autoencoder2 import LSTM_autoencoder_classification_with_variable_length_for_each_epoch, data_tri_data_generator
from load_denoised_dataset import load_acf_only
from keras.models import load_model

from keras.optimizers import Adam
from keras.losses import mse
"""Hyperparameters"""
#Dataset and LOG file
direc = '/media/windowsshare/Chauncey/Projects/paper_unequal_length/09-14-2019-AICAR3_DeepFeatures/results/DMSO2/' 
LOG_DIR = "./log_tb_cell_protrusion_LSTM_autoencoder"
ratio_train = 0.7
max_iterations = 25000  # maximum number of iterations

#Create a folder
#field can be : 'Vel', 'SAX_ACF_Vel', 'ACF_Vel', 'SAX_vel'
field = 'Mapping_Vel'
directory = './DMSO3_' + field + '/'

if not os.path.exists(directory):
    os.makedirs(directory)

"""Load the data"""
whole_dataset = load_acf_only(direc, field, ratio_train)
np.save(directory + 'whole_data', whole_dataset)

batch_size = 128

field = 'Mapping_Vel'
saved_model = './variable_length_' + field + '/'

## Feature Extraction
encoder = load_model(saved_model+ 'variable_length_encoder.h5')
#Wholedataset data
[num_samples, length, dim] = whole_dataset.shape
representation = np.full([num_samples, 30], np.nan)
for i in range(num_samples):
    Sample_length = np.sum(np.invert(np.isnan(whole_dataset[i, :, :]))) # The length of each sample
    temp_data = whole_dataset[i, 0:Sample_length, :]
    temp_data = temp_data[np.newaxis,:]
    temp_prediciton = encoder.predict(temp_data)
    representation[i, :] = temp_prediciton
np.savez(directory + 'representation.npz', representation=representation) 

## Feature Extraction from whole dataset
model = load_model(saved_model+ 'variable_length_autoencoder.h5')
#Wholedataset data
[num_samples, length, dim] = whole_dataset.shape
dataset_prediction = np.full([num_samples, 10], np.nan)
dataset_reconstruction = np.full(whole_dataset.shape, np.nan)
for i in range(num_samples):
    Sample_length = np.sum(np.invert(np.isnan(whole_dataset[i, :, :]))) # The length of each sample
    temp_data = whole_dataset[i, 0:Sample_length, :]
    temp_data = temp_data[np.newaxis,:]
    [temp_softmax, temp_reconstruction] = model.predict(temp_data)
    dataset_prediction[i, :] = temp_softmax
    dataset_reconstruction[i, 0:Sample_length, :] = temp_reconstruction
np.savez(directory + 'reconstruction_data.npz', dataset_prediction=dataset_prediction, dataset_reconstruction = dataset_reconstruction)    
 