function rexp = randx(n,k,lambda)
%
%function rexp = randx(n,k,lambda)
% Generates samples of an exponentially distributed random variable with
% parameter lambda.
% Calling parameters
%       n:    number of columns in output array rexp
%       m:    number of rows in output array rexp
%       lambda:  exponential distribution parameter, lambda > 0.
%  Returned parameters
%       rexp  an n x k array containing independent samples from an
%       exponential distribution with pdf f(x) = lambda exp( -lambda*x)
%
% Help comments updated 2/13/2021 EFCL
% Original code EFCL ~1989
%
Z = rand(n,k);  % compute a uniformly distributed random variable

% Now treating the Z value as the CDF of the desired exponential random variable,
% invert the CDF ( F(x) = 1 - exp(-lambda*x) ) to find the equivalent x
% value.  exp(-lambda x) = 1 - F(x) = 1 - Z
%         -lambda x = log(1 - Z)
%             x = -log(1-Z)/lambda

rexp=zeros(n,k);  % establish the memory
rexp=-log(1-Z)/lambda; % invert the CDF.
