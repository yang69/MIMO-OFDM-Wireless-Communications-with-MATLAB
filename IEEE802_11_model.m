function PDP=ieee802_11_model(sigma_tau,Ts)
% IEEE 802.11 channel model PDP generator
% Input:
%       sigma_tau  : RMS delay spread
%       Ts         : Sampling time
% Output:
%       PDP        : Power delay profile

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

lmax = ceil(10*sigma_tau/Ts); % (2.13)
sigma02=(1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau)); % (2.15)
l=0:lmax; PDP = sigma02*exp(-l*Ts/sigma_tau); % (2.14)

