function xp=add_pilot(x,Nfft,Nps)
% CAZAC (Constant Amplitude Zero AutoCorrelation) sequence --> pilot
% CAZAC(恒定幅度零自相关)序列 --> 导频
% Nps : Pilot spacing|导频间隔

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

if nargin<3, 
    Nps=4; 
end
Np=Nfft/Nps; % Number of pilots|导频数
xp=x; % an OFDM signal including pilot signal|准备包括导频信号在内的OFDM信号
for k=1:Np
   xp((k-1)*Nps+1)= exp(j*pi*(k-1)^2/Np);  % Pilot boosting with an even Np|式7.17（185页）
   %xp((k-1)*Nps+1)= exp(j*pi*(k-1)*k/Np);  % Pilot boosting with an odd Np
end
% CAZAC (Constant Amplitude Zero AutoCorrelation) sequence --> pilot