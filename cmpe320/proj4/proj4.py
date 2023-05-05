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

tauMAP = (sigma2 / 4) * np.log(p0 / (1 - p0)) # use the result from your derivation of the threshold
plt.plot(p0, tauMAP)
plt.xlabel("p0 = Pr[b_k = 0]")
plt.ylabel("tau_M_A_P")
plt.grid()
plt.title("tau_M_A_P with gamma = " + str(gamma_dB) + " dB, A = " + str(a) + " and  sigma^2 = " + str(sigma2))
plt.show()

#2.2 
p0 = p0all[1] # from 2023 Assignment,  p0 # 0.5 is MAP
gamma_dB = 10
gamma = 10 ** (gamma_dB / 10)
sigma2 = a ** 2 / gamma # per definition gamma = A^2/sigma^2 so sigma^2 = A^2/gamma
Ntrials = 10000 # sufficient trials for this exercise
thld_MAP = (sigma2 / 4) * np.log(p0 / (1 - p0)) # use your derivation of the MAP threshold

# Generate B, the binary information
b = np.where(np.random.rand(1,Ntrials) >= p0, 1, 0) # 0 = binary zero, 1 = binary 1 

# Convert B to Messages, map 0 to +A, 1 to -A
#    B = {0,1}, (0.5-B) = {0.5, -0.5}, (0.5-B)*2*A = {+A,-A}
m = (0.5 - b) * 2 * a # map 1 to -A, 0 to +A
n = np.random.randn(1,Ntrials) * np.sqrt(sigma2) # Gaussain with zero mean and proper variance

r =  m + n # use the signal model from the assignment
bin_edges = np.arange(-2 * a, -2 + a, step = .5)
plt.hist(r, bins = bin_edges, density = True, edgecolor = "black", label = "Histogram") # create and plot the histogram as a pdf

xfr = np.arange(-2 * a, 2 * a, 0.01) # fine-grained values of R

fRr = (1/np.sqrt(2 * np.pi * sigma2)) * ((p0 * np.exp(-np.power((xfr - a), 2) / 2 * sigma2)) + ((1 - p0) * np.exp(-np.power((xfr + a), 2) / 2 * sigma2))) # use your derivation for fR(r), similar to Project 2 with adjustments for p0

# the plot on top of the histogram, as usual
# don't forget to plot the MAP threshold value, too

plt.plot(xfr, fRr) # do your plotting, might use two plot statements

# Professional labels, note use of subscripts and Greek symbols
plt.grid()
plt.xlabel("r")
plt.ylabel("f_R(r)")
plt.title("f_R(r) for p0 = " + str(p0) + " Ntrials = " + str(Ntrials) + " gamma_d_B = " + str(gamma_dB))
plt.text(-0.5, 0.26, "tau_M_A_P = " + str(thld_MAP))  
plt.show()