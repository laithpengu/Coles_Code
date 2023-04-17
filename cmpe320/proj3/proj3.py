#
#
#   File Name:    proj3.py
#   Date Created: Fri Apr 14 2023
#   Author:       Cole Cavanagh
#   Description:  CMPE 320 Project 3: The Central Limit Theorem
#
#

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp

# PART 2.1: IID Random Variables U(0,1)

# Trial Variables 
m = 100000
sum_size = [2, 6, 12]

# Subplot Setup
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 2.1: IID Random Variables")
plt.subplots_adjust(hspace = .5)

# Data and Plot Loop
for sum in sum_size:
    # Create sum data
    xd = np.random.rand(sum, m)
    xs = np.sum(xd, 0)

    # Create Gaussian PDF
    xr = np.arange(start = 0, stop = sum, step = .002)
    yr = sp.stats.norm.pdf(xr, sum / 2, sum * (1/12))


    # Plot
    bin_edges = np.arange(start = 0, stop = sum, step = .1)
    axis[sum_size.index(sum)].hist(xs, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
    axis[sum_size.index(sum)].plot(xr, yr, 'r', label = "PDF")

plt.show()

# PART 2.2: IID Random Variables U(1,8)

# Trial Variables 
m = 100000
sum_size = [2, 20, 40]

# Subplot Setup
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 2.2: IID Random Variables U(1,8)")
plt.subplots_adjust(hspace = .5)

# Data and Plot Loop
for sum in sum_size:
    # Create sum data
    xd = np.random.randint(low = 1, high = 9, size = (sum, m))
    xs = np.sum(xd, 0)

    # Create Gaussian PDF
    xr = np.arange(start = 0, stop = sum * 8, step = .1)
    yr = sp.stats.norm.pdf(xr, (sum * 4.5) / 2, ((sum * 64) - 1) * (1/12))


    # Plot
    bin_edges = np.arange(start = 0, stop = sum * 8, step = 1)
    axis[sum_size.index(sum)].hist(xs, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
    axis[sum_size.index(sum)].plot(xr, yr, 'r', label = "PDF")

plt.show()

# PART 2.3: IID Random Variables Fx(x)

# Trial Variables 
m = 100000
sum_size = [5, 50, 150]

# Subplot Setup
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 2.3: IID Random Variables Fx(x)")
plt.subplots_adjust(hspace = .5)

# Data and Plot Loop
for sum in sum_size:
    # Create sum data
    xd = np.random.rand(sum, m)
    xd = - np.log(1 - xd) / .5
    xs = np.sum(xd, 0)

    # Create Gaussian PDF
    xr = np.arange(start = 0, stop = sum * 8, step = .002)
    yr = sp.stats.norm.pdf(xr, sum * 2 / .5, sum * (1/12))

    # Plot
    bin_edges = np.arange(start = 2, stop = sum * 4, step = .1)
    axis[sum_size.index(sum)].hist(xs, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
    axis[sum_size.index(sum)].plot(xr, yr, 'r', label = "PDF")

plt.show()

# PART 2.4: Bernoulli Random Variables 

# Trial Variables 
m = 100000
sum_size = [4, 8, 150]

# Subplot Setup
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 2.4: IID Random Variables")
plt.subplots_adjust(hspace = .5)

# Data and Plot Loop
for sum in sum_size:
    # Create sum data
    xd = np.random.rand(sum, m)
    xd = np.where(xd > .6, 1, 0)
    xs = np.sum(xd, 0)

    # Create Gaussian PDF
    xr = np.arange(start = 0, stop = sum * 2, step = .01)
    yr = sp.stats.norm.pdf(xr, sum / 2, sum * (1/12))


    # Plot
    bin_edges = np.arange(start = 0, stop = sum, step = 1)
    axis[sum_size.index(sum)].hist(xs, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram")
    axis[sum_size.index(sum)].plot(xr, yr, 'r', label = "PDF")

plt.show()