import tensorflow as tf
from pandas import read_csv, concat
import numpy as np
import subprocess
import random as rand

class Prime_Num_Neural_Net:

    #just having set defaults, that we can change with the function call.
    def __init__(self,num_size, amount_of_hidden = 4,nodes_count = 151,batch_size = 10, epochs = 10):
        self.binary_num_size = num_size
        self.amount_of_hidden = amount_of_hidden
        self.nodes_count = nodes_count
        self.batch_size = batch_size
        self.epochs = epochs
        self.x = tf.placeholder('float',[None,self.binary_num_size])
        self.y = tf.placeholder('float')

    """
    Creates the phyiscal model for the neural network to work under
    Returns:
        output(tensorflow object): the model being returned to be trained on.
    """
    def create_model(self):
        #the layering model...
        #should make this modular for n number of layers?
        hidden_list = list()

        #adding the first layer
        hidden_1_layer = {'weights':tf.Variable(tf.random_normal([self.binary_num_size, self.nodes_count])),
                      'biases':tf.Variable(tf.random_normal([self.nodes_count]))}

        for layer in range(1,self.amount_of_hidden):
            tmp_layer = {'weights':tf.Variable(tf.random_normal([self.binary_num_size, self.nodes_count])),
                          'biases':tf.Variable(tf.random_normal([self.nodes_count]))}
            hidden_list.append(tmp_layer)

        output_layer = {'weights':tf.Variable(tf.random_normal([self.nodes_count, 2])),
                        'biases':tf.Variable(tf.random_normal([2])),}

        ln = tf.add(tf.matmul(self.x,hidden_1_layer['weights']), hidden_1_layer['biases'])
        ln = tf.nn.relu(ln)

        for layer in hidden_list:
            ln = tf.add(tf.matmul(ln,layer['weights']),layer['biases'])
            ln = tf.nn.relu(ln)

        output = tf.matmul(ln,output_layer['weights']) + output_layer['biases']
        return output

    """
    The training of the neural net
    Args:
        data(panda, dataframe): the loaded prime number data from the CSV
    Returns:
        percentage(int): the accuracy of the model
    """
    def train_neural_network(self,data):
        #gets the neuralnet model
        prediction = self.create_model()

        #setting up all the tensorflow fun!
        cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=prediction, labels=self.y) )
        optimizer = tf.train.AdamOptimizer().minimize(cost)
        with tf.Session() as sess:
            sess.run(tf.global_variables_initializer())

            for epoch_num in range(self.epochs):
                epoch_loss = 0
                for _ in range(int(self.batch_size)):
                    #gets the training set from the "data".
                    epoche_x, epoche_y= self.get_train_input(data,5000)
                    #trains the model
                    _, c = sess.run([optimizer, cost], feed_dict={self.x: epoche_x,self.y: epoche_y})
                    epoch_loss += c
                print('Epoch', epoch_num, 'completed out of',self.epochs,'loss:',epoch_loss)
            correct = tf.equal(tf.argmax(prediction, 1), tf.argmax(self.y, 1))
            accuracy = tf.reduce_mean(tf.cast(correct, 'float'))

            #The testing of the model!
            x_test,y_test = self.get_train_input(data,1000)
            print('Accuracy:',accuracy.eval({self.x:x_test, self.y:y_test}))


    """
    Converts the binary number into a list representation
    Args:
        characters(string): a string of characters that represent the binary form of a number
    Returns:
        bin_list(list): the binary representation of the number in list form
    """
    def convert_bin(self,characters):
        bin_list = list()
        count = 0
        for spot in characters:
            bin_list.append(spot)
            count+=1
        while(count < 151):
            bin_list = [0] + bin_list
            count+=1

        return bin_list

    """
    Convert the prime or not prime value into the list representation of it.
    This turns into [0,1] or [1,0]
    Args:
        value(int): the prime or not prime value
    Returns:
        value(list): the list [1,0] if composite and [0,1] if prime.
    """
    def convert_primality(self, value):
        if(value == 0):
            return [1,0]
        else:
            return [0,1]

    """
    Reformats the dataframe into an np array
    Args:
        data(panda dataframe): the full amount of training data
        size(int): the amount from teh set to grab
    Returns:
        x(nparray): the features of the set
        y(nparray): the result of the set
    """
    def get_train_input(self,data,size):
        x = list()
        y = list()
        df_sample = data.sample(n=size)
        for index, row in df_sample.iterrows():
            x.append(self.convert_bin(row['Binary']))
            y.append(self.convert_primality(row['Prime']))

        #converts into a numpy array
        x = np.array(x)
        y = np.array(y)
        return x,y

"""
Gets the length of the file in lines.
Args:
    file_name(string): the name of the file being checked
Returns:
    count(int): the amount of lines in the file
"""
def file_len(file_name):
    with open(file_name) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

"""
Gets the data, stores it in a dataframe.
Args:
    file(string): the name of the file, csv file.
    percentage(float): A value between 0-1, a percentage of how much of the dataframe to use.
Returns:
    df_num(dataframe(panda)): the dataframe that contains the file's information.
"""
def get_data(file_name,percentage, randomize = True):
    #line_count = file_len(file_name)
    line_count = 200000
    lines_taken = int(line_count * percentage)
    df_num = read_csv("./" +file_name,nrows = lines_taken)
    if(randomize):
        return df_num.sample(frac=1) #randomizes the output
    return df_num


data = get_data("paddednumbersBin.csv",0.90)
P = Prime_Num_Neural_Net(151)
#P.create_model()
P.train_neural_network(data)
