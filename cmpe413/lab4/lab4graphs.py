import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("testCLK.csv")

CLK_arr = []
CLK_arr = df.iloc[2] # data we want is at 3rd row
CLK_arr = CLK_arr[1:201]
CLK_arr = CLK_arr.astype(float)

D_file = "testD.csv"
Q_file = "testQ.csv"

D_arr =[]
Q_arr =[]
Temp = []
D_arr = pd.read_csv(D_file)
D_arr = D_arr.iloc[1]
D_arr = D_arr[1:201]
D_arr = D_arr.astype(float)
print(D_arr)
#D_arr = list(reversed(D_arr))
Q_arr = pd.read_csv(Q_file)
Q_arr = Q_arr.iloc[2]
Q_arr = Q_arr[1:201]
Temp = Q_arr.dropna()
Temp = Temp.astype(float)
Q_arr = Q_arr.astype(float)
print(Q_arr)
#Q_arr = list(reversed(Q_arr))
plt.plot(Q_arr)
plt.show()

Tdc = []
Tcq = []
Tdq = []
Tdc = np.subtract(CLK_arr,D_arr)
#print(Tdc)
Tcq = np.subtract(Q_arr,CLK_arr)
print(Tcq)
Temp = Tcq[~np.isnan(Tcq)]
for i in range(len(Tcq)):
    if(Tcq[i] == min(Temp)):
        Tcq[i] = Tcq[i-1]

plt.plot(Tdc,Tcq)
print(min(Temp))
print(max(Temp))
setup1 = (min(Temp)*1.1)
print(setup1)
#plt.axhline(setup1)
plt.title("Logic gate FF latch 0 Tdc vs Tcq Hold time")
plt.xlabel("Tdc")
plt.grid()
plt.ylabel("Tcq")
plt.show()
Tdq = np.add(Tdc,Tcq)
Tdq = np.subtract(Q_arr,D_arr)
plt.plot(Tdc,Tdq)
plt.grid()
plt.title("Logic gates FF latch 0 Tdc vs Tdq hold")
plt.xlabel("Tdc")
plt.ylabel("Tdq")
plt.show()
