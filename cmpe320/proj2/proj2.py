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


# PART 2.1: MODEL R

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


# PART 2.2: METHOD 1

# Find S and fS
k = 2
s = k * np.where(r >= 0, r, 0) # s = kR when R >= 0. k = 2
fs = (1 / (k * 2 * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((s / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((s / k) + a) ** 2) / (2 * sigma2)))

# Sort so fs is plotable
order = np.argsort(s)
xs = np.array(s)[order]
yfs = np.array(fs)[order]

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.2: Method 1")
plt.subplots_adjust(hspace = .5)

# Scatter S vs R
axis[0].scatter(r, s)

# Histogram pdf vs Analytical pdf
axis[1].hist(s, density = True, edgecolor = "black")
axis[1].plot(xs, yfs, 'r')
axis[1].stem(0, .5, linefmt = 'r', markerfmt = 'r')

plt.show()


# PART 2.3: METHOD 2

# find S
k = 2
s = k * np.where(r >= 0, r, abs(r))
fs = (1 / (k * 2 * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((s / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((s / k) + a) ** 2) / (2 * sigma2)))

# Sort so fs is plotable
order = np.argsort(s)
xs = np.array(s)[order]
yfs = np.array(fs)[order]

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.3: Method 2")
plt.subplots_adjust(hspace = .5)

# Scatter S vs R
axis[0].scatter(r, s)

# Histogram pdf vs Analytical pdf
axis[1].hist(s, density = True, edgecolor = "black")
axis[1].plot(xs, yfs, 'r')

plt.show()


# PART 2.4: METHOD 3

# find S
k = 2
s = k * r ** 2
fs = (1 / (k * 2 * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((s / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((s / k) + a) ** 2) / (2 * sigma2)))

# Sort so fs is plotable
order = np.argsort(s)
xs = np.array(s)[order]
yfs = np.array(fs)[order]

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.4: Method 3")
plt.subplots_adjust(hspace = .5)

# Scatter S vs R
axis[0].scatter(r, s)

# Histogram pdf vs Analytical pdf
axis[1].hist(s, density = True, edgecolor = "black")
axis[1].plot(xs, yfs, 'r')

plt.show()