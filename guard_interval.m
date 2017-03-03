function y = guard_interval(Ng,Nfft,NgType,ofdmSym)

% MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

if NgType==1
  y=[ofdmSym(Nfft-Ng+1:Nfft) ofdmSym(1:Nfft)];
elseif NgType==2
  y=[zeros(1,Ng) ofdmSym(1:Nfft)];
end
