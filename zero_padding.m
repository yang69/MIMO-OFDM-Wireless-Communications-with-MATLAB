function y=zero_padding(x,Nzero)
% Padd zeros at the center of the input sequence x

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

N=length(x); M=ceil(N/2);
y = [x(1:M) zeros(1,Nzero) x(M+1:N)];
