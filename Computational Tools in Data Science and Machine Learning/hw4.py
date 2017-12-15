#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 17:32:37 2017

@author: CJ
"""

import pandas as pd
from collections import Counter 

#--------------------------------------------------------------#

# Data Preprocessing
train_data = pd.read_csv("train.csv")
test_data = pd.read_csv("test.csv")

# check if UserID can have mutiple reviews and 
# Product can receive mutiple reviews from different users
counter_UserID = Counter(train_data["UserId"])
counter_ProductID = Counter(train_data["ProductId"])

# Review_ID is the primary key to indentify each review
counter_ID = Counter(train_data["Id"])
rating_list = list(range(1,6))
df_clean = train_data.loc[train_data['Score'].isin(rating_list)]

rating_one = df_clean[df_clean['Score'] == 1]
rating_two = df_clean[df_clean['Score'] == 2]
rating_three = df_clean[df_clean['Score'] == 3]
rating_four = df_clean[df_clean['Score'] == 4]
rating_five = df_clean[df_clean['Score'] == 5]

import nltk
from nltk.corpus import stopwords
stop_words = set(stopwords.words('english'))
# nltk.download('popular')
def format_sentence(sent):
    sent = sent.replace('!','').replace(',','').replace(';','').replace('.','').replace(':','').replace("'",'') 
    return({word: True for word in nltk.word_tokenize(sent)})
 
print(format_sentence("This is our final assignment; I am so happy"))

score_one = []
for i in rating_one["Summary"]:
    i = str(i)
    score_one.append([format_sentence(i), 'score_one'])

score_two = []
for i in rating_two["Summary"]:
    i = str(i)
    score_two.append([format_sentence(i), 'score_two'])
    
score_three = []
for i in rating_three["Summary"]:
    i = str(i)
    score_three.append([format_sentence(i), 'score_three'])
    
score_four = []
for i in rating_four["Summary"]:
    i = str(i)
    score_four.append([format_sentence(i), 'score_four'])
    
score_five = []
for i in rating_five["Summary"]:
    i = str(i)
    score_five.append([format_sentence(i), 'score_five'])

training = score_one[:int((.99)*len(score_one))] + score_two[:int((.99)*len(score_two))] + score_three[:int((.99)*len(score_three))] + score_four[:int((.99)*len(score_four))] + score_five[:int((.99)*len(score_five))]  
test = score_one[int((.99)*len(score_one)):] + score_two[int((.99)*len(score_two)):] + score_three[int((.99)*len(score_three)):] + score_four[int((.99)*len(score_four)):] + score_five[int((.99)*len(score_five)):]

from nltk.classify import NaiveBayesClassifier

from nltk.classify.maxent import MaxentClassifier

from nltk.classify import DecisionTreeClassifier

#classifier = DecisionTreeClassifier.train(training, entropy_cutoff=0, support_cutoff=0)  

#classifier = NaiveBayesClassifier.train(training)

classifier = MaxentClassifier.train(training, max_iter = 60)

example1 = "Twilio is an awesome company!"

print(classifier.classify(format_sentence(example1)))

example2 = "I'm sad that Twilio doesn't have even more blog posts!"

print(classifier.classify(format_sentence(example2)))

example3 = "The best"

print(classifier.classify(format_sentence(example3)))

#--------------------------------------------------------------#
import math
from sklearn.metrics import mean_squared_error
len_one = len(score_one[int((.99)*len(score_one)):])
len_two = len(score_two[int((.99)*len(score_two)):])
len_thr = len(score_three[int((.99)*len(score_three)):])
len_fou = len(score_four[int((.99)*len(score_four)):])
len_five = len(score_five[int((.99)*len(score_five)):])

Ground_truth = [1] * len_one + [2] * len_two + [3] * len_thr + [4] * len_fou + [5] * len_five 
predicted_y = []
for item in test:
    output = classifier.classify(item[0])
    predicted_y.append(output)

def conversion(li):
    if li == "score_one":
        out = 1
    elif li == "score_two":
        out = 2
    elif li == "score_three":
        out = 3
    elif li == "score_four":
        out = 4
    else:
        out = 5 
    return out

new_predicted_y = [conversion(item) for item in predicted_y]
rmse = math.sqrt(mean_squared_error(Ground_truth,new_predicted_y))

#--------------------------------------------------------------#
mask = train_data['Score'].isin(rating_list)
df = train_data.loc[~mask]

predicted_test_y = []
for item in df["Summary"]:
    item = str(item)
    out = classifier.classify(format_sentence(item))
    predicted_test_y.append(out)

new_predicted_test_y = [conversion(item) for item in predicted_test_y]
test_data["Score"] = new_predicted_test_y
test_data.to_csv('test.csv', index=False)



