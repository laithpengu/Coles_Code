%S21 CMPE320 Project3 Solns
% Modified for S21, EFCL 4/15/2021

close all;
clear all;  

Ntrials = 100000;
kplot=0; 

% This next line is what MATLAB calls an anonymous function, which is a
% function that we use only in one script. the function call is
% (x,mu,sig2), and the returned value is a number.  sig2 = sigma^2

fgauss = @(x,mu,sig2) exp(-0.5*((x-mu).^2/sig2))/sqrt(2*pi*sig2);


%Problem 2.1  Uniformly distributed
Nsum = [2,6,12]; % checked  with S23 assignment

for k=1:length(Nsum)
    
    % This method is memory-intensive, but fast.
    % You can, of course, do it with loops, but that will be slower.
    
    xd = rand(Nsum(k),Ntrials);  % generate [Nsum(k) by Ntrials] array of random values
    xs = sum(xd); % "sum" adds down the MATLAB columns, thereby giving us the sum of Nsum(k) values
    xmin = 0;
    xmax = Nsum(k); % largest value of the sum
    mu = Nsum(k)* ; % put in the analytical expected value of U(0,1)
    sig2 = Nsum(k)* % put in the analytical variance of U(0,1); 
    m = mean(xs); % sample mean - this is of your experiments
    S = var(xs); % sample variance - this is of your experiments
    disp(['For ',int2str(Ntrials),' independent trials of the sum of ',int2str(Nsum(k)),' iid rv from U(0,1)']);
    disp(['   the theoretical mean is ',num2str(mu),' and the sample mean is ',num2str(m)]);
    disp(['   the theoretical variance is ',num2str(sig2),' and the sample variance is ',num2str(S)]);
    
    dx=0.1; % fine grain dx for plotting
    x = [0:dx:Nsum(k)+1]; % fine grain for fY(y)
    
    % create new figure...
    %...and then a new scaled histogram using the values of xs
    % Just use histogram( ) as in Project 1 and Project 2
    
    % And unpack the data using unpackHistogram from Project 2
    
    % And plot the Gaussian pdf on top of the histogram with labels and
    % grids and the other elements of a professional plot
    %  What should the mean and variance of the Gaussian be?  How do they
    %  vary with increasing number of terms in the sum?
    
    
end;
% there are length(Nsum) plots to this point.

%Problem 2.2  Uniformly distributed discrete
Nsum = [2,20,40]; % checked with S23 assignment
Nsides = 8; %   checked with S22 assignment


% Do the experiment again for a large number of trials (Ntrials) and the
% specified number of terms in the sum (Nsum)
    
%Problem 2.3  Exponentially distributed 
Nsum = [2,50,150]; % checked with S23 assignment
lambda=0.5; % Spring 2023
offset = 2; % Spring 2023

%And again, with samples drawn from randx provided with Project 1.


%Problem 2.4  Sum of iid Bernoulli trials
Nsum = [2,10,100];  % Checked with Project 2  100 is, in this case, a big number
% You may need smaller if you run into a MATLAB overflow

%Don't forget to plot both the exact (PMF) answer and the approximate
%Central Limit Theorem answer.  Use good practice (i.e., stem(x,y) for the
%PMF, but use plot(x,y) for the Gaussian pdf.



    
    
    
   