import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

#part 1
bin_edges = np.arange(.5, 7, 1)
trials = [240, 2400, 24000, 240000]
fig, axis = plt.subplots(2, 2)
plt.suptitle("Section 3.1: PMF for dice rolls")
plt.subplots_adjust(hspace = .5)
x = 0

for trial in trials:
    data = np.random.randint(1, 7, trial)
    mean = np.mean(data)
    variance = np.var(data)
    print("1.%d: Mean: %s Variance: %s" % ((x + 1), mean, variance))
    row = x // 2
    col = x % 2
    axis[row, col].grid()
    axis[row, col].hist(data, bins = bin_edges, density = True)
    axis[row, col].axis([0, 7, 0, .25])
    axis[row, col].set_title("Figure 1.%d: %d dice rolls" % ((x + 1), t))
    x += 1
plt.show()



#part 2
probs = [.5, .25, .75]
lens = [100, 1000, 10000]

for prob in probs:
    for l in lens:
        data = np.random.rand(100, l)


