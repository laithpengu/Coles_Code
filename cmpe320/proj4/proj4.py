#
#
#   File Name:    proj4.py
#   Date Created: Wed May 03 2023
#   Author:       Cole Cavanagh
#   Description:  CMPE 320 Project 4
#
#

import matplotlib.pyplot as plt
import numpy as np

# Constants for the project
a = 2 # given in 2023 instructions
p0all = [0.5, 0.75]   # the project includes two values of p0

# Remember that p0 = 0.5 is Maximum Likelihood (ML)
# p0 # 0.5 is Maximum A Posteriori (MAP)

#2.1  Plot the MAP threshold curve as a function of p0

p0 = np.arange(0.01, 0.99, 0.01)
gamma_dB = 10 # in decibels gamma_dB = 10*log10(A^2/sigma^2), per instructions
gamma = 10 ** (gamma_dB / 10) # power ratio

# gamma = A^2/sigma^2, so sigma^2 =A^2/gamma)
sigma2 = a ** 2 / gamma

tauMAP = (sigma2 / 4) * np.log(p0 / (1 - p0))# use the result from your derivation of the threshold
plt.plot(p0, tauMAP)
plt.xlabel("p0 = Pr[b_k = 0]")
plt.ylabel("tau_M_A_P")
plt.grid()
plt.title("tau_M_A_P with gamma = " + str(gamma_dB) + " dB, A = " + str(a) + " and  sigma^2 = " + str(sigma2))
plt.show()

