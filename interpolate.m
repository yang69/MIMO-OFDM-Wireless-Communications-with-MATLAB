function H_interpolated = interpolate(H_est,pilot_loc,Nfft,method)
% Input:        H_est    = Channel estimate using pilot sequence|使用导频序列的信道估计
%           pilot_loc    = location of pilot sequence|导频序列的位置
%                Nfft    = FFT size|FFT大小
%              method    = 'linear'/'spline'|插值方法：线性/三次样条插值
% Output: H_interpolated = interpolated channel|插值后的信道

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

if pilot_loc(1)>1 % 补足第一点的信道
  slope = (H_est(2)-H_est(1))/(pilot_loc(2)-pilot_loc(1));
  H_est = [H_est(1)-slope*(pilot_loc(1)-1)  H_est]; pilot_loc = [1 pilot_loc];
end
if pilot_loc(end)<Nfft % 补足最后一点的信道
  slope = (H_est(end)-H_est(end-1))/(pilot_loc(end)-pilot_loc(end-1));  
  H_est = [H_est  H_est(end)+slope*(Nfft-pilot_loc(end))]; pilot_loc = [pilot_loc Nfft];
end
if lower(method(1))=='l', H_interpolated = interp1(pilot_loc,H_est,[1:Nfft]);   
 else      H_interpolated = interp1(pilot_loc,H_est,[1:Nfft],'spline');
end  