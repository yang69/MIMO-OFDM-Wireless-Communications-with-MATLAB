function H=Ray_model(L)
% Rayleigh Channel Model
%  Input : L  : # of channel realization
%  Output: H  : Channel vector

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

H = (randn(1,L)+j*randn(1,L))/sqrt(2);
