% S23 CMPE320 Project 1 Skeleton
%    Histograms, PDFs and PMFs
%    EFCL   1/14/2022
%    Revised 2/4/2023
%
close all  % remove all existing figures (very useful to avoid confusion)
clear      % remove all existing variables, but not existing break points in scripts or functions

% 3.1 PMF for a single die

%bin_edges contain the upper and lower edges for the histogram that we will
%create. Therefore, it always has one more column than the number of bins,
%with the upper edge of one bin corresponding to the lower edge of the
%next.

bin_edges = [0.5:6.5]; % there are only 6 sides, start 0.5 less than 1 and finish 0.5 more than 6
Ntrials = [240, 2400 24000 240000]; % per the assignment
disp(' ');
disp('Section 3.1 PMF of a single fair die');

for ktrials = 1:length(Ntrials);  %loop on the number of trials
    
    %  set a new figure (or figures) for this number of trials
    
    rolls = randi(      ); % do the random trials
    
    sample_mean = mean(rolls); % compute the sample mean
    sample_var = var(rolls); % compute the sample variance
    
    %Each call to histogram will produce a plot.  You might consider
    %putting these in separate figures or subplots
    
    % These calls are correct, but I won't do it again.  You're CMPEs; you
    % can figure it out from here
    
    %Raw histogram (just a count of values in each bin)
    hist_raw=histogram(rolls,'BinEdges',bin_edges); %histogram returns a structure, check it out!
    
    %Normalized histogram, note calling parameters (for discrete random
    %variables, 'normalization','probability' gives what you want
    hist_norm = histogram(rolls,'BinEdges',bin_edges,'Normalization','probability');
    
    
    hold on;
    % the theoretical pmf is pk = 1/6, k=1,2,...,6 because the die is fair
    plot(  ); % plot the theoretical
    hold off;
    
    % Professional quality plots always have axes labels
    xlabel('Number of spots');
    ylabel('Probability');
    axis([0 7 0 0.25]);  %...and always have an appropriate scale
    
    % ...and always have a title
    title(['Section 3.1: ',int2str(Ntrials(ktrials)),' rolls of one fair die']);
    
    %...and almost always have a grid
    grid on
    
    %...and a legend.
    legend('Scaled histogram','Prob Mass Fnc (PMF)');
    disp(['For ',int2str(Ntrials(ktrials)),' sample mean: ',num2str(sample_mean),' sample variance: ',num2str(sample_var)]);
end; % loop on the trials

mean_th = ; % compute the theoretical mean or average
var_th = ; % compute the theoretical variance

disp(['Theoretical mean = ',num2str(mean_th),' theoretical variance: ',num2str(var_th)]);
disp('-----------');
disp(' ');

% account for the fact that you want separate plots for each section

%Section 3.2 PMF for binary strings
disp(' ');
disp('Section 3.2');

% Don't forget new figures

n = 100;  % number of columns = length of binary string
Ntrials = [100 1000 10000];  % diffent number of trials, per assignment
p1 = [0.5 0.25 0.75];  % different values of p1 given in the assignement
bins_edges =[   ]; % fill in the correct edges

% set up storage for random variable statistics (small "s")


for ktrials = 1:length(Ntrials)
    
    % Each trial consists of 100 digits
    random_numbers = rand(Ntrials(ktrials),100);  % 
    
    % Do you need a new figure?
    
    for kp = %loop on values of p1
        
        work = (random_numbers<=p1(kp)); % set to 1's and zeros using p1
        % think about how this works! It's a useful trick that you will
        % need in later projects
        
        data = ; % initialize location of first 1 in each sample
        for kn = 1:Ntrials(ktrials)  % for each of the 100 element samples
    
            % This code finds the location of the first one, or, if there
            % are no ones, establishes 101 as the index
            i1 = find(work(kn,:)==1); % find all of the 1's
            if length(i1)==0  % if there are none
                data(kn)=n+1; %    indicate beyond end of sequence
            else
                data(kn)=min(i1);% otherwise take the first 1
            end;
        end;
        
        % Generate the raw histogram for this sequence
        
        % Generate the scaled histogram for this sequence
        %   Use 'Normalization','probability' again, because this is 
        %   a PMF
        

        % Determine the theoretical geometric PMF and plot it on the same
        % axes as the normalized PMF
        
        % Label your plots.  If you use subplots, and all subplots have the
        % same x-axis, you can label the x-axis of only the lowest subplot in each 
        % column of plots
        
        %Compute and the sample mean and variance
        
        %Compute and save the population mean and variance

        
        % Do whatever bookkeeping or housekeeping you need to do at the end of the loop
        
    end; % loop on p1
    
end;

% Display the means and variances in a way that makes sense for you,
% because you have to report them in the Project report.


disp('-----------');
disp(' '); 


% Section 3.3 exponentially distributed
disp(' ');
disp('Section 3.3 Laplace distributed');

% Set up new plots as necessary.  Remember, you need ALL of the plots


Ntrials = [ ]; %set according to the assignment
lambda = ;  % as given in the assignment

theory_m =  ;   % analytical or population mean
theory_v = ; % analytical or population variance
for ktrials = 1:length(Ntrials)   % repeat for each number of trials
    
      % Set the bin edges
      
      % Generate the appropriate number of independent random trials
      data = rand2x(1,Ntrials(ktrials),lambda); % rand2x is provided 
      
      % Compute (and plot) the raw histogram
      
      % Compute (and plot) the normalized histogram
      %    Use 'Normalization','pdf' because an Laplace RV is a
      %    *continuous* random variable and has a pdf, not a pmf.
      
      % Compute and plot the true pdf on the same axes as the normalized
      % histogram
      
      % Compute the sample mean and variance and display them
      

      % Either compare the sample mean and variance with the population
      % mean and variance, or save the results to output later
end;

%Compare the sample mean and variance to the population mean and variance
%as requested

disp('-----------');
disp(' ');


% Section 3.4  N(0,1)
disp(' ');
disp('Section 3.4 Samples from N(0,1)');

Ntrials = [  ];  % number of trials per assignment

% Theoretical (analytical) (population) mean and variance
theory_m = 0;  % given in assignment
theory_v = 1;  % given in assignement

for ktrials = 1:length(Ntrials)  % loop on the different number of trials
    
      % Set the bin edges
      
      % Generate the random data
      data = randn(1,Ntrials(ktrials)); % function randn gives samples from N(0,1) by definition
      
      % Compute the raw histogram
      
      % Compute the normalized histogram with pdf normalization
      
      % Compute the theoretical pdf and plot on same axes as normalized  
      
      pdf = exp(-(b-theory_m).^2/(2*theory_v))/sqrt(2*pi*theory_v);
      
      % Compute the sample mean and variance and either save or print
      
      sample_m = mean(data);
      sample_v = var(data);

end;

disp('-----------');
disp(' ');

% Section 3.5  N(-2,4)
disp(' ');
disp('Section 3.5 Samples from N(1,4)');

% Set the number of trials and the theoretical mean and variance

for ktrials = 1:length(Ntrials) % loop on the number of trials
    
      % Set the bin edges
      
      % Create the data. Note that for N(m,s2) instead of N(0,1),
      % we use  sqrt(s2)*randn + m.  You might ask yourself "why this
      % formula?"
      % I won't say this again, but you will need it in future projects
      
      data = sqrt(theory_v)*randn(1,Ntrials(ktrials))+theory_m; % samples from N(0,1) by definition
      
      % Compute and plot both histograms on different subplots or figures
      
      
      % Compute the sample mean and variance and display or save as
      % necessary
      
end;

% Display results as necessary

disp('-----------');


% 3.6 

% Estimate the requested probability using the raw histogram from 3.5
%   This is a sum followed by a division

% Estimate the required probability using the normalized histogram from 3.5
% above.  This is equivalent to a Riemann sum from Calc II

% Estimate the required probability by integration.  Hint: you could use
% the Q function!  or the erfc equivalent.


% That's it, you're done!

      