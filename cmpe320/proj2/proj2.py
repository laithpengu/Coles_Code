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

fr = (1 / (2 * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-((r - a) ** 2) / (2 * sigma2)) + np.exp(-((r + a) ** 2) / (2 * sigma2)))

# Sort so fs is plotable
order = np.argsort(r)
xr = np.array(r)[order]
yfr = np.array(fr)[order]

# Find Values
er = np.mean(r)
es = [0, 0, 0]
ger = [0, 0, 0]

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.1: Model R")
plt.subplots_adjust(hspace = .5)

# Scatterplot
axis[0].scatter(x, r, label = "R")
axis[0].set_title("Graph 2.1.1: R")
axis[0].grid()
axis[0].legend()
axis[0].set_xlabel("Trail #")
axis[0].set_ylabel("R")

# Histogram and PDF
bin_edges = np.arange(-2.9375, 3, .125)
axis[1].hist(r, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
axis[1].plot(xr, yfr, 'r', label = "PDF")
axis[1].set_title("Graph 2.1.2: PDF of R")
axis[1].legend()
axis[1].set_xlabel("R")
axis[1].set_ylabel("FrR")
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
axis[0].scatter(r, s, label = "R vs S")
axis[0].grid()
axis[0].legend()
axis[0].set_title("Graph 2.2.1: R vs S")
axis[0].set_xlabel("R")
axis[0].set_ylabel("S")

# Histogram pdf vs Analytical pdf
bin_edges = np.arange(-2.9375, 6, .125)
axis[1].hist(s, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
axis[1].plot(xs, yfs, 'r', label = "PDF")
axis[1].stem(0, .5, linefmt = 'r', markerfmt = 'r^')
axis[1].legend()
axis[1].set_title("Graph 2.2.2: PDF of Method 1")
axis[1].set_xlabel("S")
axis[1].set_ylabel("FsS")
axis[1].grid()

plt.show()

# Find Values
es[0] = np.mean(s)
ger[0] = (1 / (k * 2 * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((er / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((er / k) + a) ** 2) / (2 * sigma2)))


# PART 2.3: METHOD 2

# find S
k = 2
s = k * np.where(r >= 0, r, abs(r))
fs = (1 / (k * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((s / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((s / k) + a) ** 2) / (2 * sigma2)))

# Sort so fs is plotable
order = np.argsort(s)
xs = np.array(s)[order]
yfs = np.array(fs)[order]

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.3: Method 2")
plt.subplots_adjust(hspace = .5)

# Scatter S vs R
axis[0].scatter(r, s, label = "R vs S")
axis[0].grid()
axis[0].legend()
axis[0].set_title("Graph 2.3.1: R vs S")
axis[0].set_xlabel("R")
axis[0].set_ylabel("S")


# Histogram pdf vs Analytical pdf
bin_edges = np.arange(-2.9375, 8, .125)
axis[1].hist(s, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
axis[1].plot(xs, yfs, 'r', label = "PDF")
axis[1].legend()
axis[1].set_title("Graph 2.3.2: PDF of Method 2")
axis[1].set_xlabel("S")
axis[1].set_ylabel("FsS")
axis[1].grid()

plt.show()

# Find Values
es[1] = np.mean(s)
ger[1] = (1 / (k * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-(((er / k) - a) ** 2) / (2 * sigma2)) + np.exp(-(((er / k) + a) ** 2) / (2 * sigma2)))


# PART 2.4: METHOD 3

# find S
k = 2
bigs = k * r ** 2
Sbes = np.linspace(-3, 10, 101)
s = (Sbes[:-1] + Sbes[1:])
fs = np.piecewise(s, [s <= 0, s > 0], [lambda s : 0, lambda s : (1 / (4 * np.sqrt(s / k) * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-((np.sqrt(s / k) - a) ** 2) / (2 * sigma2)) + np.exp(-((np.sqrt(s / k) + a) ** 2) / (2 * sigma2)))])

# Subplot Setup
fig, axis = plt.subplots(2, 1)
plt.suptitle("Section 2.4: Method 3")
plt.subplots_adjust(hspace = .5)

# Scatter S vs R
axis[0].scatter(r, bigs, label = "R vs S")
axis[0].grid()
axis[0].legend()
axis[0].set_title("Graph 2.4.1: R vs S")
axis[0].set_xlabel("R")
axis[0].set_ylabel("S")

# Histogram pdf vs Analytical pdf
axis[1].hist(bigs, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
axis[1].plot(s, fs, 'r', label = "PDF")
axis[1].legend()
axis[0].set_title("Graph 2.4.2: PDF of Method 3")
axis[1].set_xlabel("S")
axis[1].set_ylabel("FsS")
axis[1].grid()

plt.show()

# Find Values
es[2] = np.mean(bigs)
ger[2] = (1 / (4 * np.sqrt(er / k) * np.sqrt(2 * np.pi * sigma2))) * (np.exp(-((np.sqrt(er / k) - a) ** 2) / (2 * sigma2)) + np.exp(-((np.sqrt(er / k) + a) ** 2) / (2 * sigma2)))

# Output Found Values
print("er=%s" % er)
for x in range(len(es)):
    print (" Values %s: Es=%s & Ger=%s" % (x, es[x], ger[x]))