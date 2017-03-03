function H_LS = LS_CE(Y,Xp,pilot_loc,Nfft,Nps,int_opt)
% LS channel estimation function|LS信道估计
% Inputs:
%       Y         = Frequency-domain received signal|频域接收信号
%       Xp        = Pilot signal|导频信号
%       pilot_loc = Pilot location|导频位置
%       N         = FFT size|FFT大小
%       Nps       = Pilot spacing|导频间隔
%       int_opt   = 'linear' or 'spline'|插值方法：线性/三次样条插值
% output:
%       H_LS      = LS channel etimate|LS信道估计

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

Np=Nfft/Nps; % 导频数量
k=1:Np; 
LS_est(k) = Y(pilot_loc(k))./Xp(k);  % LS channel estimation|LS信道估计
if  lower(int_opt(1))=='l', % 确定插值方法
    method='linear'; 
else
    method='spline';  
end
H_LS = interpolate(LS_est,pilot_loc,Nfft,method); % Linear/Spline interpolation|线性/三次样条插值