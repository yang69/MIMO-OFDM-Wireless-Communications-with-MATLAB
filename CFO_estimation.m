% CFO_estimation.m
% Time-domain CP based method and Frequency-domain (Moose/Classen) methods
% 时域基于CP的方法和频域的Moose/Classen方法

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

clear, clf
CFO = 0.15;
Nfft=128; % FFT size|FFT大小
Nbps=2; M=2^Nbps; % Number of bits per (modulated) symbol
Es=1; % 信号能量
A=sqrt(3/2/(M-1)*Es); % Signal energy and QAM normalization factor|QAM归一化因子
N=Nfft; Ng=Nfft/4; Nofdm=Nfft+Ng;  Nsym=3;
h=complex(randn,randn)/sqrt(2);
%h=[1 zeros(1,5)]; 
% channel(h,0);
%Transmit signal|发射信号
x=[];
for m=1:Nsym
   msgint=randint(1,N,M);
   if i<=2,
       Xp = add_pilot(zeros(1,Nfft),Nfft,4); Xf=Xp; % add_pilot|加导频
   else  %Xf= QAM(msgint((i-1)*N+1:i*N),Nbps);  % constellation mapping. average power=1
       mod_object = modem.qammod('M',M, 'SymbolOrder','gray'); % M阶格雷码QAM调制器
       Xf = A*modulate(mod_object,msgint);
   end
   xt = ifft(Xf,Nfft); % IFFT
   x_sym = add_CP(xt,Ng);
   x= [x x_sym];
end
%channel
%y=channel(x_syms);
y=x; % No channel effect|没有信道影响
%Signal power calculation
sig_pow= y*y'/length(y); % Signal power calculation|计算信号功率
SNRdBs= 0:3:30;  
MaxIter = 100;  
for i=1:length(SNRdBs)
   SNRdB = SNRdBs(i);
   MSE_CFO_CP = 0; MSE_CFO_Moose = 0; MSE_CFO_Classen = 0;
   rand('seed',1); randn('seed',1);  % Initialize seed for random number generator|初始化生成随机数的种子
   y_CFO= add_CFO(y,CFO,Nfft); % Add CFO|加CFO
   for iter=1:MaxIter
      %y_aw=add_AWGN(y_CFO,sig_pow,SNRdB,'SNR',Nbps);  % AWGN added, signal power=1
      y_aw = awgn(y_CFO,SNRdB,'measured');  % AWGN added, signal power=1|加AWGN
      Est_CFO_CP = CFO_CP(y_aw,Nfft,Ng); % CP-based |时域基于CP的CFO估计
       MSE_CFO_CP = MSE_CFO_CP + (Est_CFO_CP-CFO)^2;
      Est_CFO_Moose = CFO_Moose(y_aw,Nfft); % Moose (based on two consecutive preambles)|基于两个连续前导
       MSE_CFO_Moose = MSE_CFO_Moose + (Est_CFO_Moose-CFO)^2;
      Est_CFO_Classen = CFO_Classen(y_aw,Nfft,Ng,Xp); % Classen (Pilot-based)|基于导频
       MSE_CFO_Classen = MSE_CFO_Classen + (Est_CFO_Classen-CFO)^2;
   end % the end of for (iter) loop
   MSE_CP(i)=MSE_CFO_CP/MaxIter; 
   MSE_Moose(i)=MSE_CFO_Moose/MaxIter; 
   MSE_Classen(i)=MSE_CFO_Classen/MaxIter;
end%ebn0 end    
semilogy(SNRdBs, MSE_CP,'-+'), grid on, hold on
semilogy(SNRdBs, MSE_Moose,'-x'), semilogy(SNRdBs, MSE_Classen,'-*')
xlabel('SNR[dB]'), ylabel('MSE'); title('CFO Estimation'); %axis([0 30 10e-8 10e-2])
% str=sprintf('CFO = %1.2f',CFO);
legend('CP-based technique','Moose (Preamble-based)','Classen (Pilot-based)');
% legend(str);