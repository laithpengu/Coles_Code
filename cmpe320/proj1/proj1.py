import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

"""
#part 1
bin_edges = np.arange(.5, 7, 1)
trials = [240, 2400, 24000, 240000]
fig, axis = plt.subplots(2, 2)
plt.suptitle("Section 3.1: PMF for dice rolls")
plt.subplots_adjust(hspace = .5)
x = 0

for trial in trials:
    ## create data
    data = np.random.randint(1, 7, trial)

    ## math
    mean = np.mean(data)
    variance = np.var(data)
    print("1.%d: Mean: %s Variance: %s" % ((x + 1), mean, variance))

    ## plot
    r = x // 2
    c = x % 2
    axis[r, c].grid()
    axis[r, c].hist(data, bins = bin_edges, density = True)
    axis[r, c].axis([0, 7, 0, .25])
    axis[r, c].set_title("Figure 1.%d: %d dice rolls" % ((x + 1), trial))
    x += 1
plt.show()
"""

""""
#part 2
probs = [.5, .25, .75]
lens = [100, 1000, 10000]
bin_edges = np.arange(.5, 25, 1)
fig, axis = plt.subplots(3, 3)
plt.suptitle("Section 3.2: PMF for binary strings")
plt.subplots_adjust(hspace = .5)
x = 0;
for prob in probs:
    for len in lens:
        ## create data
        TFdata = np.less(np.random.rand(100, len), prob)
        BinaryData = np.where(TFdata == True, 1, 0)
        IndexData = np.empty(0)
        for row in BinaryData:
            IndexData = np.append(IndexData, np.where(row==1)[0][0])
        
        ## math

        ## plot
        r = x // 3
        c = x % 3
        axis[r, c].hist(IndexData, bins = bin_edges, density = True, edgecolor = "black")
        axis[r, c].set_title("Figure 2.%d: %d trials at %s" % ((x + 1), len, (prob)))
        axis[r, c].grid()
        x += 1
plt.show()
"""

"""
#part 3
trials = [100, 1000, 10000]
bin_edges = np.arange(-20.5, 20, 1)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.3: PMF for Laplace random variable")
x = 0
for trial in trials:
    ## create data
    temp = -np.log(1 - np.random.rand(trial, 1)) / .5
    pm1 = 2 * ((np.random.rand(trial, 1) >= 0.5).astype(int) - 0.5)
    data = temp * pm1

    ## math


    ## plot
    axis[x].hist(data, density = True, bins = bin_edges, edgecolor = "black")
    axis[x].set_title("Figure 3.%d: %d trials" % ((x + 1), trial))
    axis[x].grid()
    x += 1
plt.show()
"""

"""
#part 4
trials = [10, 1000, 100000]
bin_edges = np.arange(-4, 4, .1)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.4: PDF for Gaussian")
x = 0
for trial in trials:
    ## data
    data = np.random.normal(size = trial)

    ## math

    ## plot
    axis[x].hist(data, bins = bin_edges, density = True, edgecolor = "black")
    axis[x].set_title("Figure 4.%d: %d trials" % ((x + 1), trial))
    x += 1
plt.show()
"""

#part 5
trials = [10, 1000, 100000]
bin_edges = np.arange(-4, 4, .1)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.5: PDF for Gaussian")
x = 0
for trial in trials:
    ## data
    data = np.random.normal(loc = -1, size = trial)

    ## math

    ## plot
    axis[x].hist(data, bins = bin_edges, density = True, edgecolor = "black")
    axis[x].set_title("Figure 5.%d: %d trials" % ((x + 1), trial))
    x += 1
plt.show()

