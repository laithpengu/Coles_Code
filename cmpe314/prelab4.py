import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 10000)
y = (10 - x) / 2200
plt.plot(x, y)
plt.title('Ic vs Vce')
plt.xlabel('Vce(V)')
plt.ylabel('Ic(mA)')
plt.grid()
plt.show()