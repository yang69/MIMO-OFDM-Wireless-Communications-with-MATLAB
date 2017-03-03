function [STO_est, Mag]=STO_by_correlation(y,Nfft,Ng,com_delay)
% STO estimation by maximizing the correlation between CP and rear part of OFDM symbol
% 通过最大化CP和OFDM符号后部的相关函数，得到STO的估计
% estimates STO by maximizing the correlation between CP (cyclic prefix)|
%     and rear part of OFDM symbol
% Input:  y         = Received OFDM signal including CP|包括CP的OFDM接收信号
%         Ng        = Number of samples in Guard Interval (CP)|GI/CP内的采样数
%         com_delay = Common delay|公共时延
% Output: STO_est   = STO estimate|STO估计
%         Mag       = Correlation function trajectory varying with time
%                   相关函数的时变轨迹

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

N_ofdm=Nfft+Ng; % OFDM符号长度
if nargin<4
    com_delay = N_ofdm/2; 
end
%maximum=1e-8; 
nn=0:Ng-1; 
yy = y(nn+com_delay)*y(nn+com_delay+Nfft)';	% 相关函数
maximum=abs(yy);
for n=1:N_ofdm
   n1 = n-1;
   yy1 = y(n1+com_delay)*y(n1+com_delay+Nfft)';
   yy2 = y(n1+com_delay+Ng)*y(n1+com_delay+Nfft+Ng)';
   yy = yy-yy1+yy2;   Mag(n)=abs(yy); % Eq.(5.12){原始注释为5.13，与书上不符}|式（5.12）
   if (Mag(n)>maximum)
     maximum=Mag(n); STO_est = N_ofdm-com_delay-n1; 
   end
end
%if (STO_est>=Ng/2), STO_est= Ng/2-1;
% elseif (STO_est<-Ng/2), STO_est= -Ng/2;
%end    
%figure(3), plot(Mag), pause