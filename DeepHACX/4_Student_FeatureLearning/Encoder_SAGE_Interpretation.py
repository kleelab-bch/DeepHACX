# -*- coding: utf-8 -*-
"""
Created on Wed May 01 12:38:27 2023

@author: Chuangqi
"""
import numpy as np
import os
import sage
import pickle
import tensorflow as tf
tf.compat.v1.experimental.output_all_intermediates(True)
#Set the level of the prompt information
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '0'
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

from keras.models import load_model



saved_dir = './dataset'
if not os.path.exists(saved_dir):
    os.makedirs(saved_dir)
    
## Load the Model: Feature Extraction
encoder = load_model(saved_dir + '/encoder_new.h5')

## Load the Whole Dataset
Truncated_Vel = np.load(os.path.join(saved_dir, 'Truncated_Vel' + '.npy'))
Truncated_Representative = np.load(os.path.join(saved_dir, 'Truncated_Representative' + '.npy'))

## Load the Acc Dataset
Acc_Vel = np.load(os.path.join(saved_dir, 'Acc_Vel' + '.npy'))
Acc_Representative = np.load(os.path.join(saved_dir, 'Acc_Representative' + '.npy'))


## Load the Bursting Dataset
Burst_Vel = np.load(os.path.join(saved_dir, 'Burst_Vel' + '.npy'))
Burst_Representative = np.load(os.path.join(saved_dir, 'Burst_Representative' + '.npy'))

#Calculate individual feature importance 
from tensorflow.python.ops.numpy_ops import np_config
np_config.enable_numpy_behavior()

# from keras.layers import Input, Bidirectional
# from keras.layers import LSTM
from keras.models import Model
from keras.layers import Dense
#import keras.backend as K
#import tensorflow.compat.v1.keras.backend as K
import tensorflow as tf

print("Run the Accelerating")
# Setup and calculate
for index in range(30):
    HF_selection = np.zeros(30)
    HF_selection[index] = 1
    init = tf.constant_initializer(HF_selection)
    ####Exlained_model 
    predictions = Dense(1, activation='linear', kernel_initializer = init, use_bias=False)(encoder.output)
    Current_Models = Model(inputs = encoder.input, outputs = predictions)
    imputer = sage.MarginalImputer(Current_Models, Truncated_Vel[:1000, :])
    estimator = sage.PermutationEstimator(imputer, 'mse')

    sage_values = estimator(Acc_Vel, Acc_Representative[:, index])
    # Plot results
    #sage_values.plot()
    file_name = 'Acc_SAGE_shap_values_to_explain_' + str(index) + '.pkl'
    #np.save(file_name,shap_values)
    #save the gradient explainer
    with open(file_name, "wb") as f:
        pickle.dump(sage_values, f)

print("Run the Bursting")
# Setup and calculate
for index in range(30):
    HF_selection = np.zeros(30)
    HF_selection[index] = 1
    init = tf.constant_initializer(HF_selection)
    ####Exlained_model 
    predictions = Dense(1, activation='linear', kernel_initializer = init, use_bias=False)(encoder.output)
    Current_Models = Model(inputs = encoder.input, outputs = predictions)
    imputer = sage.MarginalImputer(Current_Models, Truncated_Vel[:1000, :])
    estimator = sage.PermutationEstimator(imputer, 'mse')

    sage_values = estimator(Burst_Vel, Burst_Representative[:, index])
    # Plot results
    #sage_values.plot()
    file_name = 'Bursting_SAGE_shap_values_to_explain_' + str(index) + '.pkl'
    #np.save(file_name,shap_values)
    #save the gradient explainer
    with open(file_name, "wb") as f:
        pickle.dump(sage_values, f)
print("Done")
