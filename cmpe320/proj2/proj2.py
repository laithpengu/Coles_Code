#
#
#   File Name:    proj2.py
#   Date Created: Mon Mar 13 2023
#   Author:       Cole Cavanagh
#   Description:  CMPE 310 Project 2: Funcitons of a Random Variable
#
#

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp

# Part 2.1: Model R

# Find Values
PrA = 0.5
Ntrials = 10000
A_minusA = (np.random.rand(1, Ntrials) <= PrA).astype(int) # 1  = A, 0 = -A
A_minusA = 2  * (A_minusA - 0.5) # convert to  +/-A

a = 1
sigma2 = 1/9
n = np.random.normal(0 , np.sqrt(sigma2), Ntrials)
r = a * A_minusA + n # R = (+/-A) + N
r = r.flatten()

x = np.arange(0, Ntrials)

tenSigma = np.sqrt(sigma2) * 10
dr = 0.05
rEdge = np.arange((-tenSigma - a - dr/2), tenSigma + a, dr)

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.1: Model R")
plt.subplots_adjust(hspace = .5)

# Scatterplot
axis[0].scatter(x, r)
axis[0].grid()

# Histogram and PDF
bin_edges = np.arange(-2.9375, 3, .125)
axis[1].hist(r, bins = bin_edges, density = True, edgecolor = "black")
axis[1].grid()

plt.show()

# Part 2.2: Method 1

# Find S
s = 2 * np.where(r >= 0, r, 0) # s = kR when R >= 0. k = 2

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.2: Method 1")
plt.subplots_adjust(hspace = .5)

# Scatter test
axis[0].scatter(r, s)

plt.show()

