function H_MMSE = MMSE_CE(Y,Xp,pilot_loc,Nfft,Nps,h,SNR)
%function H_MMSE = MMSE_CE(Y,Xp,pilot_loc,Nfft,Nps,h,ts,SNR)
% MMSE channel estimation function|MMSE信道估计
% Inputs:
%       Y         = Frequency-domain received signal|频域接收信号
%       Xp        = Pilot signal|导频信号
%       pilot_loc = Pilot location|导频位置
%       Nfft      = FFT size|FFT大小
%       Nps       = Pilot spacing|导频间隔
%       h         = Channel impulse response|信道脉冲响应
%       ts        = Sampling time|采样时间
%       SNR       = Signal-to-Noise Ratio[dB]|信噪比dB
% output:
%      H_MMSE     = MMSE channel estimate|MMSE信道估计

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

%H = fft(h,N);
snr = 10^(SNR*0.1);
Np=Nfft/Nps; % 导频数量
k=1:Np; 
H_tilde = Y(1,pilot_loc(k))./Xp(k);  % LS estimate|LS信道估计
k=0:length(h)-1; %k_ts = k*ts; 
hh = h*h'; 
tmp = h.*conj(h).*k; %tmp = h.*conj(h).*k_ts;
r = sum(tmp)/hh;    r2 = tmp*k.'/hh; %r2 = tmp*k_ts.'/hh;
tau_rms = sqrt(r2-r^2);     % rms delay|rms时延，书14页，式1.20
df = 1/Nfft;  %1/(ts*Nfft);
j2pi_tau_df = j*2*pi*tau_rms*df;
K1 = repmat([0:Nfft-1].',1,Np); % K1的大小为Nfft*Np，每一列均为0:Nfft-1
K2 = repmat([0:Np-1],Nfft,1); % K2的大小为Nfft*Np，每一行均为0:Np-1
rf = 1./(1+j2pi_tau_df*(K1-K2*Nps)); % 式6.16
K3 = repmat([0:Np-1].',1,Np); % K3的大小为Np*Np，每一列均为0:Np-1
K4 = repmat([0:Np-1],Np,1); % K4的大小为Np*Np，每一行均为0:Np-1
rf2 = 1./(1+j2pi_tau_df*Nps*(K3-K4)); % 式6.17
Rhp = rf;
Rpp = rf2 + eye(length(H_tilde),length(H_tilde))/snr;
H_MMSE = transpose(Rhp*inv(Rpp)*H_tilde.');  % MMSE channel estimate|MMSE信道估计，式6.14