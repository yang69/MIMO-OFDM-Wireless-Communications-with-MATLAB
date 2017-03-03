function [PAPR_dB, AvgP_dB, PeakP_dB] = PAPR(x)
% PAPR_dB  : PAPR[dB]
% AvgP_dB  : Average power[dB]|平均功率
% PeakP_dB : Maximum power[dB]|最大功率

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

Nx=length(x); xI=real(x); xQ=imag(x);
Power = xI.*xI + xQ.*xQ;
PeakP = max(Power); PeakP_dB = 10*log10(PeakP);
AvgP = sum(Power)/Nx; AvgP_dB = 10*log10(AvgP);
PAPR_dB = 10*log10(PeakP/AvgP);
