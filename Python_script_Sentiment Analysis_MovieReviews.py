# -*- coding: utf-8 -*-
"""
Created on Tue Jan 17 01:44:45 2017

@author: sidsk
"""

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#Importing the dataset

dataset = pd.read_csv('train.tsv',delimiter = '\t',quoting=3,nrows=20000)


#Cleaning the dataset

import re
import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
corpus=[]
for i in range(0,20000):
  phrase = re.sub('[^a-zA-Z]',' ',dataset['Phrase'][i])  #dont remove any alphabets,for all review
  phrase = phrase.lower()
  phrase = phrase.split()
  ps = PorterStemmer()
  phrase = [ps.stem(word) for word in phrase if not word in set(stopwords.words('english'))]
  phrase = ' '.join(phrase)
  corpus.append(phrase)  #Add to corpus
  
#Creating the bag of words model

from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features =6000)  #TO filter irrelavant words and with frequent words
X = cv.fit_transform(corpus).toarray()  #To create sparse matrix and bag of words
y = dataset.iloc[:,3].values

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20, random_state = 0)

# Fitting Decision Tree Classification to the Training set
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy', random_state = 0)
classifier.fit(X_train, y_train)

# Fitting Naive Bayes to the Training set
from sklearn.naive_bayes import GaussianNB
classifier = GaussianNB()
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)