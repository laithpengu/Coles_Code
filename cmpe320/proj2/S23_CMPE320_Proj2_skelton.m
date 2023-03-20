%S23  CMPE320 Proj 2
close all;
clear;

PrA = 0.5;
Ntrials = ; % set a large number of trials 
A_minusA = rand(1,Ntrials)<=PrA; % 1  = A, 0 = -A;
A_minusA = 2*(A_minusA-0.5);% convert to  +/-A;

Avalue = 1; % per S23 assignment
sigma2 = 1/9; %per S23 assignment;
N =  sqrt(sigma2)*randn(1,Ntrials); % zero mean with variance = sigma2
R =  Avalue*A_minusA+N;  % R = (+/-A)+N;

tenSigma = sqrt(sigma2)*10;
dr=0.05;
rEdge=[-tenSigma-Avalue-dr/2:dr:tenSigma+Avalue]; % force bin center to zero


plot([1:length(R)],R,'b.'); % plot the scatterplot
xlabel('Sample index');
ylabel('Sample value');
title(['Scatter plot of R, A = ',num2str(Avalue),' \sigma^2 = ',num2str(sigma2)]);
grid on;

figure  % new figure

% Do the Histogram for R, normalize to be a pdf
spdfR =histogram(R,'Normalization','pdf','BinEdges',rEdge);
[Vr,Nbinr,r]=unpackHistogram(spdfR);


fRr =  % implement your analytical pdf
hold on; % protect the histogram plot
plot(r,fRr,'r','LineWidth',2);
hold off; % release hole
title(['2.1  f_r(r), N = ',int2str(Ntrials)]);
xlabel('r (Volts)');
ylabel('f_R(r)');
legend('histogram','f_R(r)');
grid on
figure;

%  Method 1

% In Spring 2023, add constant k
kconstant = 2; 

S = kconstant*(R>=0).*R; %  only accept R>=0 note use of MATLAB logical variable

% Do scatterplot
plot(R,S,'b.');
xlabel('r (value of R)');
ylabel('s (value of S)');
title('2.2  S vs. R scatter plot, Method 1');
grid on;
figure; 
% 
subplot(2,1,1);

% Do the histogram of S
spdfS = histogram(S,'Normalization','pdf','BinEdges',rEdge);
[Values,Ns,s]=unpackHistogram(spdfS); % I'll provide unpackHistogram( )

ds = dr;
i0 = min(find(s>=0))
fSs = ; % implement your analytical pdf of S

% plot the analytical on top of the histogram as before

title('2.2  f_S(s)');
xlabel('s (Volts)');
ylabel('f_S(s)');
grid on
legend('histogram','f_S(s)');

% Is your plot scaled professionally?

% replot with scale factor to emphasize Gaussian
subplot(2,1,2);

% You need to repeat the histogram to replot it
spdfS = histogram(S,'Normalization','pdf','BinEdges',rEdge);
[Values,Ns,s]=unpackHistogram(spdfS); % use unpack again

ds = dr;
i0 = min(find(s>=0))
fSs = Values.*(s>0);

% plot the analytical pdf on top of the histogram as before

% label and title (and scale?)


figure;

% Compute the means and the variances for use in 3.5
meanS =  mean(S);
varS = var(S);
meanR = mean(R);
varR=var(R);

% Output your results

%================
% 2.3 uses abs as the function, but the same signal model.
%      We'll retain N and R, and just replace S

nplots = 4; % plots so far
figure(nplots+1);

S2 =  % the second method is S = k|R|

% Plot the scatter plot
% Label axes, title, scale


figure(nplots+2);

% Do the Histogram for S2

% Create and plot the analytical pdf for S2

% Label and scale

% Compute means and variance from simulated data

% OUtput the means and variances 



%================
% 2.4 uses S = kR.^2 as the function, but the same signal model.
%      We'll retain N and R, and just replace S

nplots = 6; % plots so far
figure(nplots+1);


S3 =  % the third method is S = k*R.^2.

% Plot, label, scale, title the scatterplot 


figure(nplots+2);

% Create the Histogram

% Create the analytical pdf

% Plot the analytical pdf on top of the histogram

% Labels, titles, scale

% Compute mean and variance of simulated data


% You might then create a table of E[S]  and g[E[R]] for use in your report
% in Section 3.5



