function y_CFO=add_CFO(y,CFO,Nfft)
% To add an arbitrary frequency offset|施加CFO
% Input: y    = Time-domain received signal|时域接收信号
%        dCFO = FFO (fractional CFO) + IFO (integral CFO)
%        Nfft = FFT size;|FFT大小

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

nn=0:length(y)-1; 
y_CFO = y.*exp(j*2*pi*CFO*nn/Nfft); % 表5.3（133页）
% plot(real(y_CFO),imag(y_CFO),'.')