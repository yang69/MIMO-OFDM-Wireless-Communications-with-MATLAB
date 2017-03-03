function CFO_est=CFO_Classen(yp,Nfft,Ng,Nps)
% Frequency-domain CFO estimation using Classen method based on pilot tones
% 利用Classen方法，基于导频的频域CFO估计技术
% Nps : Pilot spacing|导频间隔，或者就是导频本身，取决于调用时给的参数


% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

if length(Nps)==1, % 调用时给的可能是导频间隔，也可能是导频本身，需要判断
    Xp=add_pilot(zeros(1,Nfft),Nfft,Nps); % Pilot signal|导频信号
else
    Xp=Nps; % If Nps is given as an array, it must be a pilot sequence Xp
end
Nofdm=Nfft+Ng; kk=find(Xp~=0); Xp=Xp(kk); % Extract pilot tones|提取导频
for i=1:2 
   yp_without_CP = remove_CP(yp(1+Nofdm*(i-1):Nofdm*i),Ng);
   Yp(i,:) = fft(yp_without_CP,Nfft);
end
%temp= Y(1,kk)*Xp(kk)';
CFO_est = angle(Yp(2,kk).*Xp*(Yp(1,kk).*Xp)')/(2*pi)*Nfft/Nofdm; % Eq.(5.31)|式5.31（146页）
%fprintf(' dFCFO-Esti_FFO=%8.5f-%8.5f\n', dFCFO,Esti_FFO);
% MSE = MSE + (CFO_est-FCFO)*(CFO_est-CFO);