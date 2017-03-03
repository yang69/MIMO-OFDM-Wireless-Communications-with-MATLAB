function PDP=exp_PDP(tau_d,Ts,A_dB,norm_flag)
% Exponential PDP generator
%   Input:
%       tau_d     : rms delay spread in second
%       Ts        : Sampling time in second
%       A_dB      : the smallest noticeable power in dB
%       norm_flag : normalizes total power to unit
%   Output:
%       PDP       : PDP vector

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

if nargin<4, norm_flag=1; end     % normalizes
if nargin<3, A_dB=-20; end        % 20dB below
sigma_tau = tau_d;  A = 10^(A_dB/10); 
lmax=ceil(-tau_d*log(A)/Ts); % get max. path index (2.8)/Ts
% Computes normalization factor for power normalization
if norm_flag
  p0=(1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau)); % (2.10)
 else    p0=1/sigma_tau; 
end
% Exponential PDP
l=0:lmax;  PDP = p0*exp(-l*Ts/sigma_tau); % (2.11)