'''
Trying to implement LSTM autoencoder directly.
Ref: https://github.com/keras-team/keras/issues/3676
     https://stackoverflow.com/questions/46494877/how-to-apply-lstm-autoencoder-to-variant-length-time-series-data
'''
from __future__ import absolute_import
from tensorflow.keras.utils import to_categorical
from keras.layers import Input, Bidirectional
from keras.layers import LSTM, RepeatVector
from keras.layers import Dropout, Activation #, regularizers
from tensorflow.keras.layers import BatchNormalization
from keras.layers import Dense, Reshape, Input, Concatenate, Flatten
from keras.models import Model, Sequential
from keras.layers import Masking, Lambda
from keras.callbacks import ModelCheckpoint
'''
The representations are only constrained by the size of the hidden layer.
To constrain the representations to be compact is to add a sparisity contraint
on the activity of the hidden representations.

encoded = Dense(encoding_dim, activation = 'relu', activity_regularizer = regularizers.l1(10e-5))(input_img)
'''
import numpy as np
from tensorflow.keras.optimizers import Adam
from keras.losses import mse
import pickle
# Repeat function tries to replace the RepeatVector for the dataset with variable length
import keras.backend as K

N_classes = 10

def repeat(x):
    stepMatrix = K.ones_like(x[0][:,:,:1]) #matrix with ones, shaped as (batch, steps, 1)
    latentMatrix = K.expand_dims(x[1],axis=1) #latent vars, shaped as (batch, 1, latent_dim)

    return K.batch_dot(stepMatrix,latentMatrix)

def data_generator(Dataset, batch_size):
    #Here, the data are filled with NaN value.
    Sample_length = np.sum(np.invert(np.isnan(Dataset)), axis = 1) # The length of each sample
    len_sam = np.unique(Sample_length) # The length categories in the dataset

    while True:
        #Ordered select the samples with different length.
        for i in range(len(len_sam)): # for different length
            current_len = len_sam[i]
            #if i + 1 == len(len_sam): # return the shortest length
            #    i = 0;
            current_index_list = np.where(Sample_length == current_len)[0]
            #shuffle the current_index_list
            np.random.shuffle(current_index_list)
            group_list = np.floor_divide(len(current_index_list), batch_size)
            for j in range(group_list):
                selected_index = current_index_list[batch_size * j: batch_size * (j+1)]
                yield Dataset[selected_index, 0:current_len, :], Dataset[selected_index, 0:current_len, :]

def data_generator_prediction(Dataset):
    #Here, the data are filled with NaN value.
    Sample_length = np.sum(np.invert(np.isnan(Dataset)), axis = 1) # The length of each sample
    len_sam = np.unique(Sample_length) # The length categories in the dataset

    while True:
        #Ordered select the samples with different length.
        for i in range(len(len_sam)): # for different length
            current_len = len_sam[i]
            yield Dataset[i, 0:current_len, :]
    
def data_pair_generator(Dataset, Label_Data, batch_size):
    #Here, the data are filled with NaN value.
    Sample_length = np.sum(np.invert(np.isnan(Dataset)), axis = 1) # The length of each sample
    len_sam = np.unique(Sample_length) # The length categories in the dataset
    ylabel = to_categorical(Label_Data-1, num_classes=N_classes)
    while True:
        #Ordered select the samples with different length.
        for i in range(len(len_sam)): # for different length
            current_len = len_sam[i]
            current_index_list = np.where(Sample_length == current_len)[0]
            #shuffle the current_index_list
            np.random.shuffle(current_index_list)
            group_list = np.floor_divide(len(current_index_list), batch_size)
            for j in range(group_list):
                selected_index = current_index_list[batch_size * j: batch_size * (j+1)]
                yield Dataset[selected_index, 0:current_len, :], ylabel[selected_index, :]

def data_tri_data_generator(Dataset, Label_Data, batch_size):
    #Here, the data are filled with NaN value.
    Sample_length = np.sum(np.invert(np.isnan(Dataset)), axis = 1) # The length of each sample
    len_sam = np.unique(Sample_length) # The length categories in the dataset
    ylabel = to_categorical(Label_Data-1, num_classes=N_classes)
    while True:
        #Ordered select the samples with different length.
        for i in range(len(len_sam)): # for different length
            current_len = len_sam[i]
            current_index_list = np.where(Sample_length == current_len)[0]
            #shuffle the current_index_list
            np.random.shuffle(current_index_list)
            group_list = np.floor_divide(len(current_index_list), batch_size)
            for j in range(group_list):
                selected_index = current_index_list[batch_size * j: batch_size * (j+1)]
                yield Dataset[selected_index, 0:current_len, :], [ylabel[selected_index, :], Dataset[selected_index, 0:current_len, :]]


def LSTM_autoencoder_with_variable_length_for_each_epoch(X_train, train_label, val_train, val_label, epochs, batch_size):
 
    inp = Input(shape=(None, 1))
    out = Bidirectional(LSTM(units = 10, return_sequences = True, activation = 'tanh'))(inp)
    out_1 = LSTM(units = 20, return_sequences = True, activation = 'tanh')(out)
    out_representation = LSTM(units = 30, return_sequences = False, activation = 'tanh')(out_1)
    encoder = Model(inp, out_representation)
    
    out_dec = Lambda(repeat)([inp,out_representation])
    out = Bidirectional(LSTM(units = 30, return_sequences = True, activation = 'tanh'))(out_dec)
    out = Bidirectional(LSTM(units = 20, return_sequences = True, activation = 'tanh'))(out)
    #The size of output should be equal to the size of input.
    out = LSTM(units = 1, return_sequences = True, activation = 'tanh')(out)
    
    autoencoder = Model(inp, out)
    
    #autoencoder.compile(loss = 'mean_squared_error', optimizer = 'RMSprop', metrics = ['accuracy'])
    adam = Adam(lr=0.0005)
    autoencoder.compile(optimizer=adam, loss=mse, metrics = ['mse'])
    encoder.summary()
    autoencoder.summary()
    
    #Fit the model
    filepath="variable_length_LSTM_autoencoder_weights-_ACF_Vel_improvement_v2.hdf5"
    checkpoint = ModelCheckpoint(filepath, verbose=1, monitor='val_loss',save_best_only=True)
    history = autoencoder.fit_generator(data_generator(X_train, batch_size), steps_per_epoch=np.floor_divide(X_train.shape[0],batch_size), callbacks=[checkpoint], epochs=epochs, validation_data = data_generator(val_train, batch_size), validation_steps = np.floor_divide(val_train.shape[0],batch_size))
    saved_name= 'variable_length_LSTM_autoencoder_ACF_Vel_v2.h5'
    with open('.' + '/' + 'history_' + saved_name , 'wb') as file_pi:
        pickle.dump(history.history, file_pi)
    return autoencoder, encoder

def LSTM_classification_with_variable_length_for_each_epoch(X_train, train_label, val_train, val_label, epochs, batch_size):
 
    inp = Input(shape=(None, 1))
    out = Bidirectional(LSTM(units = 10, return_sequences = True, activation = 'tanh'))(inp)
    out_1 = LSTM(units = 20, return_sequences = True, activation = 'tanh')(out)
    out_representation = LSTM(units = 30, return_sequences = False, activation = 'tanh')(out_1)
    encoder = Model(inp, out_representation)
    
    Dense1 = Dense(32, input_dim=30, kernel_regularizer=regularizers.l2(0.05))(out_representation)
    BN1 = BatchNormalization()(Dense1)
    Relu1 = Activation('relu')(BN1)
    Dropout1 = Dropout(0.5)(Relu1)
    #Dense2 = Dense(32, kernel_regularizer=regularizers.l2(0.05))(Relu1)
    #BN2 = BatchNormalization()(Dense2)
    #Relu2 = Activation('relu')(BN2)
    #Dropout2 = Dropout(0.5)(Relu2)
    Dense3 = Dense(N_classes)(Dropout1)
    Softmax = Activation('softmax')(Dense3)
    
    autoencoder = Model(inp, Softmax)
    
    autoencoder.compile(optimizer='rmsprop', loss='categorical_crossentropy', metrics=['accuracy'])
    encoder.summary()
    autoencoder.summary()
    
    #Fit the model
    filepath="variable_length_LSTM_lcassification_weights-improvemen.hdf5"
    checkpoint = ModelCheckpoint(filepath, verbose=1, monitor='val_acc',save_best_only=True, mode='max')
    history = autoencoder.fit_generator(data_pair_generator(X_train, train_label, batch_size), steps_per_epoch=np.floor_divide(X_train.shape[0],batch_size), callbacks=[checkpoint], epochs=epochs, validation_data = data_pair_generator(val_train, val_label, batch_size), validation_steps = np.floor_divide(val_train.shape[0],batch_size))
    saved_name= 'variable_length_classification_LSTM_autoencoder.h5'
    with open('.' + '/' + 'history_' + saved_name , 'wb') as file_pi:
        pickle.dump(history.history, file_pi)
    return autoencoder, encoder

def LSTM_autoencoder_classification_with_variable_length_for_each_epoch(X_train, train_label, val_train, val_label, epochs, batch_size):
 
    inp = Input(shape=(None, 1))
    out = Bidirectional(LSTM(units = 10, return_sequences = True, activation = 'tanh'))(inp)
    out_1 = LSTM(units = 20, return_sequences = True, activation = 'tanh')(out)
    out_representation = LSTM(units = 30, return_sequences = False, activation = 'tanh')(out_1)
    encoder = Model(inp, out_representation)
    
    Dense1 = Dense(32, input_dim=30, kernel_regularizer=regularizers.l2(0.05))(out_representation)
    BN1 = BatchNormalization()(Dense1)
    Relu1 = Activation('relu')(BN1)
    Dropout1 = Dropout(0.5)(Relu1)
    #Dense2 = Dense(32, kernel_regularizer=regularizers.l2(0.05))(Dropout1)
    #BN2 = BatchNormalization()(Dense2)
    #Relu2 = Activation('relu')(BN2)
    #Dropout2 = Dropout(0.5)(Relu2)
    Dense3 = Dense(N_classes)(Dropout1)
    Softmax = Activation('softmax')(Dense3)
    
    out_dec = Lambda(repeat)([inp,out_representation])
    out = Bidirectional(LSTM(units = 30, return_sequences = True, activation = 'tanh'))(out_dec)
    out = Bidirectional(LSTM(units = 20, return_sequences = True, activation = 'tanh'))(out)
    #The size of output should be equal to the size of input.
    out = LSTM(units = 1, return_sequences = True, activation = 'tanh')(out)
    
    autoencoder = Model(inp, [Softmax, out])
    
    #autoencoder.compile(loss = 'mean_squared_error', optimizer = 'RMSprop', metrics = ['accuracy'])
    #adam = Adam(lr=0.0005)
    autoencoder.compile(optimizer='rmsprop', loss=['categorical_crossentropy', 'mean_squared_error'], metrics=['mean_squared_error'],loss_weights = [1, 25])
    encoder.summary()
    autoencoder.summary()
    
    #Fit the model
    filepath="Autoencoder_classification_weights-improvemen.hdf5"
    checkpoint = ModelCheckpoint(filepath, verbose=1, monitor='val_loss',save_best_only=True, mode='min')
    history = autoencoder.fit_generator(data_tri_data_generator(X_train, train_label, batch_size), steps_per_epoch=np.floor_divide(X_train.shape[0],batch_size), callbacks=[checkpoint], epochs=epochs, validation_data = data_tri_data_generator(val_train, val_label, batch_size), validation_steps = np.floor_divide(val_train.shape[0],batch_size))
    saved_name= 'Autoencoder_classification.h5'
    with open('.' + '/' + 'history_' + saved_name , 'wb') as file_pi:
        pickle.dump(history.history, file_pi)
    return autoencoder, encoder


def Bi_LSTM_autoencoder(batch_input_shape, X_train, val_train, epochs, batch_size):
    inp = Input(shape=(batch_input_shape, 1))
    out = Bidirectional(LSTM(units = 10, return_sequences = True, activation = 'tanh'))(inp)
    out_representation = LSTM(units = 20, return_sequences = False, activation = 'tanh')(out)
    encoder = Model(inp, out_representation)
    
    out_dec = RepeatVector(batch_input_shape)(out_representation)
    
    out = Bidirectional(LSTM(units = 20, return_sequences = True, activation = 'tanh'))(out_dec)
    #The size of output should be equal to the size of input.
    out = LSTM(units = 1, return_sequences = True, activation = 'tanh')(out)
    
    autoencoder = Model(inp, out)
    
    #autoencoder.compile(loss = 'mean_squared_error', optimizer = 'RMSprop', metrics = ['accuracy'])
    adam = Adam(lr=0.0005)
    autoencoder.compile(optimizer=adam, loss=mse, metrics = ['mse'])
    encoder.summary()
    autoencoder.summary()

    #Fit the model
    filepath="Bi_LSTM_autoencoder_weights-improvemen.hdf5"
    checkpoint = ModelCheckpoint(filepath, verbose=1, monitor='val_loss',save_best_only=True, mode='min')
    history = autoencoder.fit(X_train, X_train, shuffle=True, callbacks=[checkpoint], epochs=epochs, batch_size=batch_size, validation_data = (val_train, val_train))
    saved_name= 'Bi_LSTM_autoencoder.h5'
    with open('.' + '/' + 'history_' + saved_name , 'wb') as file_pi:
        pickle.dump(history.history, file_pi)
    return autoencoder, encoder

def simple_LSTM_autoencoder(batch_input_shape, X_train, val_train, epochs, batch_size):
    inp = Input(shape=(batch_input_shape, 1))
    out = LSTM(units = 10, return_sequences = True, activation = 'tanh')(inp)
    out_representation = LSTM(units = 20, return_sequences = False, activation = 'tanh')(out)
    encoder = Model(inp, out_representation)
    
    out_dec = RepeatVector(batch_input_shape)(out_representation)
    
    out = LSTM(units = 20, return_sequences = True, activation = 'tanh')(out_dec)
    #The size of output should be equal to the size of input.
    out = LSTM(units = 1, return_sequences = True, activation = 'tanh')(out)
    
    autoencoder = Model(inp, out)
    
    #autoencoder.compile(loss = 'mean_squared_error', optimizer = 'RMSprop', metrics = ['accuracy'])
    adam = Adam(lr=0.0005)
    autoencoder.compile(optimizer=adam, loss=mse, metrics = ['mse'])
    encoder.summary()
    autoencoder.summary()

    #Fit the model
    filepath="simple_LSTM_autoencoder_weights-improvemen.hdf5"
    checkpoint = ModelCheckpoint(filepath, verbose=1, monitor='val_loss',save_best_only=True, mode='min')
    history = autoencoder.fit(X_train, X_train, shuffle=True, callbacks=[checkpoint], epochs=epochs, batch_size=batch_size, validation_data = (val_train, val_train))
    saved_name= 'simple_LSTM_autoencoder.h5'
    with open('.' + '/' + 'history_' + saved_name , 'wb') as file_pi:
        pickle.dump(history.history, file_pi)
    return autoencoder, encoder

