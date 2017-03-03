function PL=PL_logdist_or_norm(fc,d,d0,n,sigma)
% Log-distance or Log-normal Shadowing Path Loss model
% Input
%       fc    : carrier frequency[Hz]
%       d     : between base station and mobile station[m]
%       d0    : reference distance[m]
%       n     : path loss exponent, n
%       sigma : variance[dB]
% output
%       PL    : path loss[dB]

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

lamda = 3e8/fc;
PL = -20*log10(lamda/(4*pi*d0)) + 10*n*log10(d/d0);  % Eq.(1.4)
if nargin>4,  PL = PL + sigma*randn(size(d));  end  % Eq.(1.5)
