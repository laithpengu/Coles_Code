import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

## grab csv
data1 = pd.read_csv("21data.csv")
data2 = pd.read_csv("22data.csv")
data3 = pd.read_csv("23data.csv")
data4 = pd.read_csv("24data.csv")

# 1
x = [0, 1, 2, 3, 4, 5, 6]
xticks = ["1.5", "1.65", "1.8", "1.95", "2.1", "2.25", "2.4"]
plot1 = data1.plot(title="2.1: INV Width")
plot1.set_xlabel("PMOS Width (uM)")
plot1.set_ylabel("Time (ns)")
plot1.set_xticks(x, xticks)
plt.show()

# 2
x = [0, 1, 2, 3, 4]
xticks = ["1", "2", "4", "8", "16"]
plot2 = data2.plot(title="2.2: Load Variance")
plot2.set_xlabel("# of load transistors")
plot2.set_ylabel("Time (ns)")
plot2.set_xticks(x, xticks)
plt.show()

# 3
data31 = data3.iloc[0:5]
plot3 = data31.plot(title="2.3: Load Variance (2x Size)")
plot3.set_xlabel("# of load transistors")
plot3.set_ylabel("Time (ns)")
plot3.set_xticks(x, xticks)
plt.show()

x = [5, 6, 7, 8, 9]
data32 = data3.iloc[5:10]
plot4 = data32.plot(title="2.3: Load Variance (4x Size)")
plot4.set_xlabel("# of load transistors")
plot4.set_ylabel("Time (ns)")
plot4.set_xticks(x, xticks)
plt.show()

# 4
x = [0, 2, 4]
xticks = ["1", "2", "4"]
data41 = data4.iloc[[0, 2, 4]]
plot5 = data41.plot(title="2.4: NOR Load Variance (A Input)")
plot5.set_xlabel("# of load transistors")
plot5.set_ylabel("Time (ns)")
plot5.set_xticks(x, xticks)
plt.show()

x = [1, 3, 5]
data42 = data4.iloc[[1, 3, 5]]
plot6 = data42.plot(title="2.4: NOR Load Variance (B Input)")
plot6.set_xlabel("# of load transistors")
plot6.set_ylabel("Time (ns)")
plot6.set_xticks(x, xticks)
plt.show()

x = [6, 8, 10]
xticks = ["1", "2", "4"]
data41 = data4.iloc[[6, 8, 10]]
plot5 = data41.plot(title="2.4: NAND Load Variance (A Input)")
plot5.set_xlabel("# of load transistors")
plot5.set_ylabel("Time (ns)")
plot5.set_xticks(x, xticks)
plt.show()

x = [7, 9, 11]
data42 = data4.iloc[[7, 9, 11]]
plot6 = data42.plot(title="2.4: NAND Load Variance (B Input)")
plot6.set_xlabel("# of load transistors")
plot6.set_ylabel("Time (ns)")
plot6.set_xticks(x, xticks)
plt.show()