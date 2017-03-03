function CFO_est=CFO_Moose(y,Nfft)
% Frequency-domain CFO estimation using Moose method based on two consecutive identical OFDM symbols 
% 利用Moose方法，基于前导的频域CFO估计

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

for i=0:1,
   Y(i+1,:)= fft(y(Nfft*i+1:Nfft*(i+1)),Nfft);
end
CFO_est = angle(Y(2,:)*Y(1,:)')/(2*pi); % Eq.(5.30)|式5.30（145页）
%fprintf(' FFO-Esti_FFO=%8.5f-%8.5f\n', FFO,Esti_FFO);
% Esti_FFO=Esti_FFO*(Nfft/(Nfft+Nfft/4));
%FFO_MSE = FFO_MSE + (Esti_FFO-FFO)*(Esti_FFO-FFO);
