#!/usr/bin/env python
# coding: utf-8

import numpy as np
import pandas as pd
import nltk
nltk.download('averaged_perceptron_tagger')


uwa = pd.read_csv('uwanlp.csv')
uwa.head()


# format use test column as a string for iteration
words = uwa['Use Word Analysis Use Test']
use_words = words.tolist()
use_words_clean = [str(i) for i in use_words]
use_words_test = ' '.join(use_words_clean)


# nlp shiz, tokenizing each word based on whether or not it is a noun
tokenized = nltk.word_tokenize(use_words_test)
nouns = [word for (word, pos) in nltk.pos_tag(tokenized) if(pos[:2] == 'NN')]
#print(nouns)


#loop through original list and compare to noun list, create new column with "Noun" or "Not Noun"
noun_or_not = []
for word in use_words_clean:
    if word in nouns:
        noun_or_not.append("Noun")
    else:
        noun_or_not.append("Not Noun")
noun_or_not


# add new noun classification column back in to dataset
uwa['Noun_Classification'] = noun_or_not

uwa.head()

# format column headers
uwa.columns = ['Use_Test', 'Count', 'Noun_Classification']

# write back as csv
uwa.to_csv('uwanlp_final.csv', index=False)

