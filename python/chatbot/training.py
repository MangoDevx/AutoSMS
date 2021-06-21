import json
import random
import pickle

import numpy as np

import os
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'

from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize as TokenizeStr

from tensorflow.keras.optimizers import SGD
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout

IGNORED_CHAR = ['?', '.', '\'', ',', '!']
WORD_LEMMATIZER = WordNetLemmatizer()
INTENTS = json.loads(open('intents.json').read())

def main():
    words = []
    classes = []
    documents = []
    for intent in INTENTS['intents']:
        for pattern in intent['patterns']:
            word_list = TokenizeStr(pattern)
            words.extend(word_list)
            documents.append((word_list, intent['tag']))
            if intent['tag'] not in classes:
                classes.append(intent['tag'])
    words = [WORD_LEMMATIZER.lemmatize(word) for word in words if word not in IGNORED_CHAR]
    words = sorted(set(words))
    classes = sorted(set(classes))
    pickle.dump(words, open('words.pkl', 'wb'))
    pickle.dump(classes, open('classes.pkl', 'wb'))

    training = []
    output_empty = [0] * len(classes)
    for document in documents:
        bag = []
        word_patterns = document[0]
        word_patterns = [WORD_LEMMATIZER.lemmatize(word.lower()) for word in word_patterns]
        for word in words:
            if word in word_patterns:
                bag.append(1)
            else: bag.append(0)
        output_row = list(output_empty)
        output_row[classes.index(document[1])] = 1
        training.append([bag, output_row])

    random.shuffle(training)
    training = np.array(training)
    training_x = list(training[:, 0])
    training_y = list(training[:, 1])

    model = Sequential()
    model.add(Dense(128, input_shape = (len(training_x[0]),), activation = 'relu'))
    model.add(Dropout(0.5))
    model.add(Dense(64, activation = 'relu'))
    model.add(Dropout(0.5))
    model.add(Dense(len(training_y[0]), activation = 'softmax'))

    # Adam would technically be better but the data is so small it doesn't really matter
    sgd = SGD(lr = 0.01, decay = 1e-6, momentum = 0.9, nesterov = True)
    model.compile(loss = 'categorical_crossentropy', optimizer = sgd, metrics = ['accuracy'])
    final =  model.fit(np.array(training_x), np.array(training_y), epochs = 200, batch_size = 5, verbose = 1)
    model.save('data.h5', final)
    print('Training complete')

if __name__ == "__main__":
    main()
