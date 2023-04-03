import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 6.5, 10000)
y = (8 - (x + 1.5)) / 2
plt.plot(x, y, label = "DC Loadline")
plt.plot(3.59, 1.5, label = "Q-pt", marker = "o")
plt.title('Ic vs Vce')
plt.xlabel('Vce(V)')
plt.ylabel('Ic(mA)')
plt.legend()
plt.grid()
plt.show()