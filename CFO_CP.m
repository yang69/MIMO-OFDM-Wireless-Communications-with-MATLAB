function CFO_est=CFO_CP(y,Nfft,Ng)
% Time-domain CFO estimation based on CP (Cyclic Prefix)
% 基于CP的时域CFO估计

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

nn=1:Ng; 
CFO_est = angle(y(nn+Nfft)*y(nn)')/(2*pi);  % Eq.(5.23){原来代码为5.27，与书上不符}|式5.23（144页）
% MSE = MSE + (CFO_est-CFO)*(CFO_est-CFO);