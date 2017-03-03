% test_orthogonality.m
% to plot several sinusoidal signals with different frequencies/phases and their DFT sequences
% and to check their orthogonality
% 画出具有不同频率/相位的正弦信号及其DFT序列
% {exp(j2π*fk*t)},0≤k≤N-1，fk=k/Tsym

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

clear, clf
T=1.6; ND=1000; nn=0:ND; ts=0.002; tt=nn*ts; % time interval|时间间隔
Ts = 0.1; M = round(Ts/ts); % Sampling period in continuous/discrete-time |连续/离散时间的采样间隔
nns = [1:M:ND+1]; % Sampling indices |采样编号
tts = (nns-1)*ts; % Sampling times |采样时间
ks = [1:4 3.9 4]; % Frequency indices |频率编号
tds = [0 0 0.1 0.1 0 0.15]; %delay times |时延
K = length(ks);
for i=1:K
   k=ks(i); td=tds(i);  x(i,:) = exp(j*2*pi*k*(tt-td)/T); 
   if i==K, x(K,:) = [x(K,[302:end]) x(K-3,[1:301])]; end
   title_string = sprintf('cos(2pi*%1.1f*(t-%4.2f)/%2.1f)',k,td,T);
   subplot(K,2,2*i-1), plot(tt,real(x(i,:)),'LineWidth',1), title(title_string)
   hold on, plot(tt([1 end]),[0 0],'k')
   set(gca,'fontsize',9), axis([tt([1 end]) -1.2 1.2])
   stem(tts,real(x(i,nns)),'.','markersize',5)
end
N = round(T/Ts); xn = x(:,nns(1:N));
xn*xn'/ N % check orthogonality |检验正交性
Xk = fft(xn.').';  kk = 0:N-1;
for i=1:K
   k=ks(i); td=tds(i);   
   title_string = sprintf('DFT of cos(2pi*%1.1f*(t-%4.2f)/%2.1f), t=[0:%d]*%3.2f',k,td,T,N-1,Ts);
   subplot(K,2,2*i), stem(kk,abs(Xk(i,:)),'.','markersize',5), title(title_string)
   set(gca,'fontsize',8,'xtick',[k]), axis([0 N 0 20])
end