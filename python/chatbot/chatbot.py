import json
import random
import pickle

import numpy as np

import os
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'

from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize as TokenizeStr

from tensorflow.keras.models import load_model

WORD_LEMMATIZER = WordNetLemmatizer()
INTENTS = json.loads(open('intents.json').read())
WORDS = pickle.load(open('words.pkl', 'rb'))
CLASSES = pickle.load(open('classes.pkl', 'rb'))
MODEL = load_model('data.h5')

def sentence_clean_up(sentence):
    sentence_words = TokenizeStr(sentence)
    sentence_words = [WORD_LEMMATIZER.lemmatize(word.lower()) for word in sentence_words]
    return sentence_words

def word_bag(sentence):
    sentence_words = sentence_clean_up(sentence)
    bag = [0] * len(WORDS)
    for s_word in sentence_words:
        for i, word in enumerate(WORDS):
            if word == s_word:
                bag[i] = 1
    return np.array(bag)

def predict_class(sentence):
    bag = word_bag(sentence)
    result = MODEL.predict(np.array([bag]))[0]
    err_thr = 0.5
    resultant = [[i, r] for i, r in enumerate(result) if r > err_thr]
    resultant.sort(key=lambda x: x[1], reverse = True)
    result_list = []
    for r in resultant:
        result_list.append({'intent': CLASSES[r[0]], 'probability': str(r[1])})
    return result_list

#client testing
def get_response(intents_list, intents_json):
    try:
        tag = intents_list[0]['intent']
    except:
        tag = 'general'
    list_of_intents = intents_json['intents']
    for i in list_of_intents:
        if i['tag'] == tag:
            result = random.choice(i['responses'])
            break
    return result

print('Chatbot connected')

while True:
    message = input('')
    ints = predict_class(message)
    res = get_response(ints, INTENTS)
    print(f'Bot: {res}')