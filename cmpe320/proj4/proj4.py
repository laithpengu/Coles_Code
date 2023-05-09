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
import scipy as sp

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
plt.ylabel("tauMAP")
plt.grid()
plt.show()

#2.2 
p0 = p0all[1] # from 2023 Assignment,  p0 # 0.5 is MAP
gamma_dB = 10
gamma = 10 ** (gamma_dB / 10)
sigma2 = a ** 2 / gamma # per definition gamma = A^2/sigma^2 so sigma^2 = A^2/gamma
Ntrials = 500000 # sufficient trials for this exercise
thld_MAP = (sigma2 / 4) * np.log((1 - p0) / p0) # use your derivation of the MAP threshold

# Generate B, the binary information
b = (np.random.rand(Ntrials)<=(1-p0)).astype(int) # np.where(np.random.rand(1,Ntrials) >= p0, 1, 0) # 0 = binary zero, 1 = binary 1 

# Convert B to Messages, map 0 to +A, 1 to -A
#    B = {0,1}, (0.5-B) = {0.5, -0.5}, (0.5-B)*2*A = {+A,-A}
m = (0.5 - b) * 2 * a # map 1 to -A, 0 to +A
n = np.random.normal(0, np.sqrt(sigma2), Ntrials) # Gaussain with zero mean and proper variance

r =  m + n # use the signal model from the assignment
bin_edges = np.arange(np.min(r) - 2, np.max(r) + 2, step = .1)
plt.hist(r, density = True, bins = bin_edges, edgecolor = "black", label = "Histogram") # create and plot the histogram as a pdf

xfr = np.arange(-2 * a, 2 * a, 0.01) # fine-grained values of R

fRr = (1/np.sqrt(2 * np.pi * sigma2)) * ((p0 * np.exp(-np.power((xfr - a), 2) / (2 * sigma2))) + ((1 - p0) * np.exp(-np.power((xfr + a), 2) / (2 * sigma2)))) # use your derivation for fR(r), similar to Project 2 with adjustments for p0

# the plot on top of the histogram, as usual
# don't forget to plot the MAP threshold value, too

plt.plot(xfr, fRr, 'r-', label = "PDF") # do your plotting, might use two plot statements

# Professional labels, note use of subscripts and Greek symbols
plt.grid()
plt.xlabel("r")
plt.ylabel("f_R(r)")
plt.legend()
plt.axvline(thld_MAP, label = "tau", linewidth = 2)  
plt.show()

# Now we're ready for the main event
# Set Parameters
gamma_dB = np.concatenate((np.arange(0, 8, .5), np.arange(8.25, 13, .25))) # gamma = A^2/sigma^2 in dB
gamma = 10 ** (gamma_dB / 10)  # as power ratio, same size as gamma_dB

# Adjust number of bits for your machine.  You need a lot of bits for this
# simulation
#Nbits = 1000000; # one million bits
#Nbits = 2500000;# two point five million bits
Nbits = 5000000;# five million bits
#Nbits = 10000000;# ten million bits
#Nbits = 10; # for debugging only

# Initialize storage for results

thresholds = np.zeros((len(p0all), len(gamma))) #thresholds vary with sigma2 and p0
results = np.zeros((len(p0all), len(gamma))) # results vary with sigma2 and p0
pBT = np.zeros((len(p0all), len(gamma))) # heoretical prob of error vary with sigma2 and p0

#  Do the simulations
#  The outer loop is on p0, with p0=0.5 (ML) first and p0 # 0.5 (MAP) second
#  The inner loop is on values of gamma corresponding to different signal
#  to noise power ratios (A^2/sigma2)

for kp0 in range(len(p0all)):   # loop on all the values of p0
   
    # make the B (or b) and M (or m) arrays as before, one value for each trial
    # we can use the same message array for all of the signal to noise
    # values, but need different messages for different values of p0 (why?)
    b = (np.random.rand(Nbits) <= (1 - p0all[kp0])).astype(int)
    m = (0.5 - b) * 2 * a
     
    #Loop on SNR, gamma
    for kSNR in range(len(gamma)):
        # One long continuous coherent string of coded bits and additive noise
        # 
    
        # create sigma2 for this value of gamma, use the power ratio,
        # not gamma_dB
        sigma2 = a ** 2 / gamma[kSNR]

        # then create sigma 
        sigma = np.sqrt(sigma2)
           
        # generate the noise and add it to the message bits
        n = np.random.normal(0, np.sqrt(sigma2), Nbits)
        r = m + n 
           
        # create the threshold for this p0 and this sigma2 and save it
           
        thresholds[kp0, kSNR] =  (sigma2 / 4) * -np.log(p0all[kp0] / (1 - p0all[kp0]))# from your MAP analysis
           
        # decode the received signal r into binary 1's and 0's. 
        bkhat =  np.where(r < thresholds[kp0, kSNR], 1, 0)# 1 if less than threshold, 0 if greater
        errors = np.bitwise_xor(bkhat, b)  #mod 2 accomplishes XOR function

        # save the results
        results[kp0, kSNR] = np.sum(errors) / Nbits # pb this SNR and this p
        # compute the theoretical conditional probability of error
        pBT_given0 = .5 * sp.special.erfc(((a - thresholds[kp0, kSNR]) / sigma) / np.sqrt(2)) # per your analysis
        pBT_given1 = .5 * sp.special.erfc(((a + thresholds[kp0, kSNR]) / sigma) / np.sqrt(2)) # per your analysis
           
        # Use Principle of Total Probability to find the theoretical
        # probability of error for this p0 and this gamma and store it
        pBT[kp0, kSNR] = pBT_given0* p0all[kp0] + pBT_given1 * (1 - p0all[kp0])  # use your computation
            
    # you might consider displaying some intermediate results here so you can
    # check your computations by hand.
         
    #Plot the results for this P0 and all SNRs
    
    # set new figure, one figure for each p0
        
    plt.semilogy(gamma_dB, pBT[kp0], 'k-',  gamma_dB, results[kp0], 'ro')
    # provide a legend
    # provide a grid
    plt.grid()
    # label the axes
    plt.xlabel("gamma_dB")
    plt.ylabel("Pr[error]")
    # provide a title
    plt.title("gamma vs error")
    # loop on P0
    plt.show()


plt.semilogy(gamma_dB, pBT[0], 'k-', gamma_dB, pBT[1], 'r-')
plt.grid()
plt.xlabel("gamma_dB")
plt.ylabel("Pr[error]")
plt.show()

plt.plot(gamma_dB, pBT[1]/pBT[0])
plt.grid()
plt.xlabel("gamma_dB")
plt.ylabel("Pr[error]")
plt.show()