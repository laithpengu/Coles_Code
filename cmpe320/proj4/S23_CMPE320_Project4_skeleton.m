% S23 CMPE320 Project 4 BASK simulation
%   Skeleton 
%
close all
clear

disp('CMPE320 Spring 2023 Project 4:  BASK');

% Constants for the project
A=2; % given in 2023 instructions
p0all = [0.5 0.75];  % the project includes two values of p0

% Remember that p0 = 0.5 is Maximum Likelihood (ML)
% p0 # 0.5 is Maximum A Posteriori (MAP)

% 2.1  Plot the MAP threshold curve as a function of p0

p0=[0.01:.01:0.99];
gamma_dB = 10; % in decibels gamma_dB = 10*log10(A^2/sigma^2), per instructions
gamma = 10^(gamma_dB/10); % power ratio

% gamma = A^2/sigma^2, so sigma^2 =A^2/gamma)
sigma2 = A^2/gamma;

tauMAP = ; % use the result from your derivation of the threshold
figure(1);
plot(p0,tauMAP,'LineWidth',2);
xlabel('p0 = Pr[b_k = 0]');
ylabel('\tau_M_A_P');
grid on;
title(['\tau_M_A_P with \gamma = ',num2str(gamma_dB),' dB, A = ',num2str(A),' and  \sigma^2 = ',num2str(sigma2)]);
figure;

%2.2 
hold off;
p0=p0all(2); % from 2023 Assignment,  p0 # 0.5 is MAP
gamma_dB=10;
gamma = 10^(gamma_dB/10);
sigma2=A^2/gamma; % per definition gamma = A^2/sigma^2 so sigma^2 = A^2/gamma
Ntrials = 500000; % sufficient trials for this exercise
thld_MAP = ; % use your derivation of the MAP threshold

% Generate B, the binary information
B = (rand(1,Ntrials)>=p0); % 0 = binary zero, 1 = binary 1 

% Convert B to Messages, map 0 to +A, 1 to -A
%    B = {0,1}, (0.5-B) = {0.5, -0.5}, (0.5-B)*2*A = {+A,-A}
M = (0.5-B)*2*A; % map 1 to -A, 0 to +A
N = randn(1,Ntrials)*sqrt(sigma2);  % Gaussain with zero mean and proper variance

R =  ; % use the signal model from the assignment 
Rhist = histogram(R,'Normalization','pdf'); % create and plot the histogram as a pdf

r = [-2*A:.01:2*A]; % fine-grained values of R

fRr = ;% use your derivation for fR(r), similar to Project 2 with adjustments for p0

% the plot on top of the histogram, as usual
% don't forget to plot the MAP threshold value, too
%
hold on;
plot(  ); % do your plotting, might use two plot statements
hold off;

% Professional labels, note use of subscripts and Greek symbols
grid on;
xlabel('r');
ylabel('f_R(r)');
title(['f_R(r) for p0 = ',num2str(p0),' Ntrials = ',int2str(Ntrials),' \gamma_d_B = ',num2str(gamma_dB)]);
text(-0.5,0.26,['\tau_M_A_P = ',num2str(thld_MAP)]);   


% Now we're ready for the main event
%Set Parameters

gamma_dB=[[0:0.5:8] [8.25:.25:13] ]; % gamma = A^2/sigma^2 in dB
gamma = 10.^(gamma_dB/10);  % as power ratio, same size as gamma_dB

% Adjust number of bits for your machine.  You need a lot of bits for this
% simulation
Nbits = 1000000; % one million bits
Nbits = 2500000;% two point five million bits
Nbits = 5000000;% five million bits
%Nbits = 10000000;% ten million bits
%Nbits = 10; % for debugging only

% Initialize storage for results

thresholds=zeros(length(p0all),length(gamma)); %thresholds vary with sigma2 and p0
results = zeros(length(p0all),length(gamma)); % results vary with sigma2 and p0
pBT = zeros(length(p0all),length(gamma)); % theoretical prob of error vary with sigma2 and p0


% Do the simulations
% The outer loop is on p0, with p0=0.5 (ML) first and p0 # 0.5 (MAP) second
%  The inner loop is on values of gamma corresponding to different signal
%  to noise power ratios (A^2/sigma2)

for kP0=1:length(p0all)   % loop on all the values of p0
   
   % make the B (or b) and M (or m) arrays as before, one value for each trial
   % we can use the same message array for all of the signal to noise
   % values, but need different messages for different values of p0 (why?)
   
     
%Loop on SNR, gamma

    for kSNR=1:length(gamma)
    
    % One long continuous coherent string of coded bits and additive noise
    % 
    
           % create sigma2 for this value of gamma, use the power ratio,
           % not gamma_dB
           
           % then create sigma 
           
           r = ; % generate the noise and add it to the message bits
           
           % create the threshold for this p0 and this sigma2 and save it
           
           thresholds(kP0,kSNR) = ; % from your MAP analysis
           
           % decode the received signal r into binary 1's and 0's. 
           
           bkhat = ; % 1 if less than threshold, 0 if greater
           errors = mod(bkhat - b,2);  %mod 2 accomplishes XOR function
           
           % save the results
           results(kP0,kSNR) = sum(errors)/Nbits; % pb this SNR and this p

           % compute the theoretical conditional probability of error
           pBT_given0 = ; % per your analysis
           pBT_given1 = ; % per your analysis
           
           % Use Principle of Total Probability to find the theoretical
           % probability of error for this p0 and this gamma and store it
           pBT(kP0,kSNR) = ;  % use your computation
            
% you might consider displaying some intermediate results here so you can
% check your computations by hand.
         
    end; %loop on SNR
    
    %Plot the results for this P0 and all SNRs
    
        figure; % set new figure, one figure for each p0
        
        h=semilogy(gamma_dB,pBT(kP0,:),'k-',gamma_dB,results(kP0,:),'ro');
        set(h,'LineWidth',1.5); % another way to set the line width
        
        % provide a legend
        
        % provide a grid
        
        % label the axes
        
        % provide a title
 
    end;% loop on P0
    
    % This is Section 2.5
    
    % Combined plot
    figure; % set new figure
    
    % plot the theoretical ML error (p0=0.5) and MAP error (p0=0.75) on the
    % same semilogy curve.  Legends, labels,  title, grid, etc
    
    
    figure; % another new figure
    
    % plot the ratio in the instructions, legend, labels, title, grid, etc.

        