import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp


#part 1
bin_edges = np.arange(.5, 7, 1)
trials = [240, 2400, 24000, 240000]
fig, axis = plt.subplots(2, 2)
plt.suptitle("Section 3.1: PMF for dice rolls")
plt.subplots_adjust(hspace = .5)
plot = 0

for trial in trials:
    ## create data
    data = np.random.randint(1, 7, trial)
    sdata = np.unique(data, return_counts = True)
    ## math
    mean = np.mean(data)
    variance = np.var(data)
    print("1.%d: Mean: %s Variance: %s" % ((plot + 1), mean, variance))

    ## plot
    r = plot // 2
    c = plot % 2
    axis[r, c].grid()
    axis[r, c].hist(data, bins = bin_edges, density = True, edgecolor = "black", label = "histogram")
    axis[r, c].axis([0, 7, 0, .25])
    axis[r, c].set_title("Graph 1.%d: %d dice rolls" % ((plot + 1), trial))
    axis[r, c].stem(sdata[0], sdata[1] / trial, linefmt = "red", label = "PMF")
    axis[r, c].legend()
    axis[r, c].set_xlabel("k")
    axis[r, c].set_ylabel("F(k)")
    plot += 1
plt.show()



#part 2
probs = [.5, .25, .75]
lens = [100, 1000, 10000]
bin_edges = np.arange(-.5, 25, 1)
fig, axis = plt.subplots(3, 3)
plt.suptitle("Section 3.2: PMF for binary strings")
plt.subplots_adjust(hspace = .5)
plot = 0;
for prob in probs:
    for len in lens:
        ## create data
        TFdata = np.less(np.random.rand(len, 100), prob)
        BinaryData = np.where(TFdata == True, 1, 0)
        IndexData = np.empty(0)
        for row in BinaryData:
            IndexData = np.append(IndexData, np.where(row==1)[0][0])
        sdata = np.unique(IndexData, return_counts = True)
        
        ## math
        mean = np.mean(IndexData)
        variance = np.var(IndexData)
        print("2.%d: Mean: %s Variance: %s" % ((plot + 1), mean, variance))

        ## plot
        r = plot // 3
        c = plot % 3
        axis[r, c].hist(IndexData, bins = bin_edges, density = True, edgecolor = "black", label = "histogram")
        axis[r, c].set_title("Graph 2.%d: %d trials at %s" % ((plot + 1), len, (prob)))
        axis[r, c].grid()
        axis[r, c].stem(sdata[0], sdata[1] / len, linefmt = "red", label = "PMF")
        axis[r, c].legend()
        axis[r, c].set_xlabel("k")
        axis[r, c].set_ylabel("F(k)")
        plot += 1
plt.show()



#part 3
trials = [100, 1000, 10000]
bin_edges = np.arange(-20.5, 20, 1)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.3: PMF for Laplace random variable")
plt.subplots_adjust(hspace = .5)
plot = 0
for trial in trials:
    ## create data
    data = (-np.log(1 - np.random.rand(trial, 1)) / .5) * (2 * ((np.random.rand(trial, 1) >= 0.5).astype(int) - 0.5))
    x = np.linspace(-20, 20, 100)
    y = 0.5 * 0.5 * np.exp(-0.5 * abs(x))

    ## math
    mean = np.mean(data)
    variance = np.var(data)
    print("3.%d: Mean: %s Variance: %s" % ((plot + 1), mean, variance))

    ## plot
    axis[plot].hist(data, density = True, bins = bin_edges, edgecolor = "black", label = "histogram")
    axis[plot].set_title("Graph 3.%d: %d trials" % ((plot + 1), trial))
    axis[plot].plot(x, y, label = "PDF")
    axis[plot].grid()
    axis[plot].legend()
    axis[plot].set_xlabel("k")
    axis[plot].set_ylabel("F(k)")
    plot += 1
plt.show()



#part 4
trials = [10, 1000, 100000]
bin_edges = np.arange(-4, 4, .1)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.4: PDF for Gaussian")
plt.subplots_adjust(hspace = .5)
plot = 0
for trial in trials:
    ## data
    data = np.random.normal(size = trial)
    x = np.linspace(-4, 4, 100)

    
    ## math
    mean = np.mean(data)
    variance = np.var(data)
    print("4.%d: Mean: %s Variance: %s" % ((plot + 1), mean, variance))

    ## plot
    axis[plot].hist(data, bins = bin_edges, density = True, edgecolor = "black", label = "histogram")
    axis[plot].set_title("Graph 4.%d: %d trials" % ((plot + 1), trial))
    axis[plot].plot(x, sp.stats.norm.pdf(x), label = "PDF")
    axis[plot].grid()
    axis[plot].legend()
    axis[plot].set_xlabel("k")
    axis[plot].set_ylabel("F(k)")
    plot += 1
plt.show()



#part 5
trials = [10, 1000, 100000]
bin_edges = np.arange(-10.5, 10, .5)
fig, axis = plt.subplots(3, 1)
plt.suptitle("Section 3.5: PDF for Gaussian")
plt.subplots_adjust(hspace = .5)
plot = 0
for trial in trials:
    ## data
    data = np.random.normal(loc = -1, scale = 2, size = trial)
    x = np.linspace(-10, 10, 100)

    ## math
    mean = np.mean(data)
    variance = np.var(data)
    print("5.%d: Mean: %s Variance: %s" % ((plot + 1), mean, variance))

    ## plot
    axis[plot].hist(data, bins = bin_edges, density = True, edgecolor = "black", label = "histogram")
    axis[plot].set_title("Graph 5.%d: %d trials" % ((plot + 1), trial))
    axis[plot].plot(x, sp.stats.norm.pdf(x, loc = -1, scale = 2), label = "PDF")
    axis[plot].grid()
    axis[plot].legend()
    axis[plot].set_xlabel("k")
    axis[plot].set_ylabel("F(k)")
    plot += 1
plt.show()

# part 6
x = np.random.normal(loc = -1, scale = 2, size = 10000)
data = np.where(x >= -1 and x < .5, x)
prob = data.size() / 10000
