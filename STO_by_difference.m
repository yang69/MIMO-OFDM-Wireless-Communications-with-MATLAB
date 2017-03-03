function [STO_est,Mag]=STO_by_difference(y,Nfft,Ng,com_delay)
% STO estimation by minimizing the difference between CP and rear part of OFDM symbol
% 通过最小化CP和OFDM符号后部的差值，实现STO的估计
% estimates STO by minimizing the difference between CP (cyclic prefix) 
%     and rear part of OFDM symbol
% Input:  y          = Received OFDM signal including CP|包括CP的OFDM接收信号
%          Ng         = Number of samples in CP (Guard Interval)|CP/GI内的采样数
%          com_delay = Common delay|公共时延
% Output: STO_est   = STO estimate|STO估计
%           Mag        = Correlation function trajectory varying with time
%                   相关函数的时变轨迹

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

N_ofdm=Nfft+Ng; minimum=100; STO_est=0;
if nargin<4, com_delay = N_ofdm/2; end
for n=1:N_ofdm
   nn = n+com_delay+[0:Ng-1]; 
   %tmp1 = y(nn)-y(nn+Nfft); tmp = sum(abs(tmp1)); % Eq. (5.11) works for CFO=0
   %tmp1 = y(nn)-y(nn+Nfft); tmp = tmp1*tmp1'; % works for CFO=0
   %tmp = y(nn)*y(nn)'+y(nn+Nfft)*y(nn+Nfft)'-2*abs(y(nn))*abs(y(nn+Nfft))';
   tmp0 = abs(y(nn))-abs(y(nn+Nfft));
   Mag(n) = tmp0*tmp0'; % Eq.(5.11) is strong against CFO{原始注释为5.12，与书上不符}|式5.11（比5.10更抗CFO）
   %tmp0= abs(y(nn)-conj(y(nn+Nfft))); tmp= tmp0*tmp0.';
   %discrepancy = tmp - tmp2
   %Mag(n) = Mag(n) + tmp;
   if (Mag(n)<minimum)
     minimum=Mag(n);  STO_est = N_ofdm-com_delay -(n-1); 
   end
end
%if (STO_est>=Ng/2), STO_est= Ng/2-1;
% elseif (STO_est<-Ng/2), STO_est= -Ng/2;
%end