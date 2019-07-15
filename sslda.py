#!/usr/bin/python3.4

from sklearn.preprocessing import LabelEncoder
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.decomposition import PCA
import numpy as np
import random
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

f = open("magic2.csv","r")
l = f.readlines()
f.close()

o = open("sslda.json","w")

z = open("sslda.log","w")
t= [[],[],[],[],[],[],[],[],[],[],[]]
for i in range(0,len(l)):
    a = l[i].split(',')
    for j in range(0,len(a)):
        t[j].append(a[j])

enc = LabelEncoder()
le = enc.fit(t[10])
y = le.transform(t[10]) + 1

sup_lda= LDA()
semi_lda = LDA()
pca = PCA()

a = [float(x) for j in range(0,10) for x in t[j]]

X = np.array(a)
X = X.reshape(19020,10)


semi_dict={}
sup_dict = {}
semi_log = {}
sup_log = {}
log_likelihood = {}
sup_average = 0
sup_log_avg = 0
semi_average = {} 
points = [10, 20, 40, 80, 160, 320, 640]

for i in points:
    semi_average[i] = 0

for fold in range(0,20):

    ex = []

    X_test = []
    y_test = []
    log_likelihood[fold] = {}
    for i in range(0,50):
        fl = 1
        while fl == 1:
            r = round(random.random() * X.shape[0])
            if r not in ex:
                X_test.append(X[r])
                y_test.append(y[r])
                ex.append(r)
                fl = 0


    X = np.delete(X,ex,axis=0)
    y = np.delete(y,ex,axis=0)

    X_labeled = []
    y_labeled = []

    ex = []

    for i in range(0,25):
        fl = 1
        while fl == 1:
            r = round(random.random() * X.shape[0])
            if r not in ex:
                X_labeled.append(X[r])
                y_labeled.append(y[r])
                ex.append(r)
                fl = 0


    sup_lda.fit(X_labeled, y_labeled)
    sup_scores = sup_lda.score(X_test,y_test)
    sup_dict[fold] = sup_scores
    sup_log[fold] = sup_lda.predict_proba(X_test)
    sup_average += sup_scores
    for m in range(0,len(y_test)):
        if y[m] == 2:
            sup_log_avg += np.log(sup_log[fold][m][1]) + np.log(1 - sup_log[fold][m][0])
        else:
            sup_log_avg += np.log(sup_log[fold][m][0]) + np.log(1 - sup_log[fold][m][1])
   
    pca.fit(X_labeled)

    X = np.delete(X,ex,axis=0)
    y = np.delete(y,ex,axis=0)

    semi_scores = []
    semi_logs = []
    for i in range(0,len(points)):
        ex = []
        X_unlab = []
        y_unlab = []
        for j in range(0,points[i]):
            fl = 1
            while fl == 1:
                r = round(random.random() * X.shape[0]-1)
                if r not in ex:
                    X_unlab.append(X[r])
                    y_unlab.append(y[r])
                    ex.append(r)
                    fl = 0
        X_unlab_dr = pca.transform(X_unlab)
        X_labeled_dr = pca.transform(X_labeled)
        X_test_dr = pca.transform(X_test)
        y_pred = sup_lda.predict(X_unlab_dr)
        semi_lda.fit(np.append(X_labeled_dr,X_unlab_dr,axis=0), np.append(y_labeled,y_pred,axis=0))
        semi_score = semi_lda.score(X_test_dr, y_test)
        semi_scores.append(semi_score)
        semi_average[points[i]]+= semi_score
        semi_logs.append(semi_lda.predict_proba(X_test_dr))
        log_likelihood[fold][points[i]] = 0.0
        for m in range(0,len(y_test)):
            if y[m] == 2:
                log_likelihood[fold][points[i]] += np.log(semi_logs[i][m][1]) + np.log(1-semi_logs[i][m][0])
            else:
                log_likelihood[fold][points[i]] += np.log(semi_logs[i][m][0]) + np.log(1-semi_logs[i][m][1])
    semi_dict[fold] = semi_scores
    semi_log[fold] = semi_logs

   

    print(semi_scores)
    print(sup_scores)

json.dump(sup_dict,o)
json.dump(semi_dict,o)

print(sup_log)
print(semi_log)
json.dump(log_likelihood,z)
print(1-sup_average/20)

y=[]
y.append(1-sup_average/20)
for i in points:
    print(i)
    print(1-semi_average[i]/20)
    y.append(1-semi_average[i]/20)

x = [0,10,20,40,80,160,320,640]

o.close()
z.close()


plt.figure(1)
plt.plot(x,y)
plt.xlabel('number of unlabeled points')
plt.ylabel('error rate')
plt.savefig('ex2_b2.png')

y=[]
y.append(sup_log_avg/20)
for i in points:
    print(i)
    acc = 0
    for j in range(0,20):
        acc += log_likelihood[j][i]
    print(acc/20)
    y.append(acc/20)

plt.figure(2)
plt.plot(x,y)
plt.xlabel('number of unlabeled points')
plt.ylabel('log-likelihood')
plt.savefig('ex2_c2.png')


