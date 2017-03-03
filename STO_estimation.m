% STO_estimation.m
% Inputs:
%      Nbps    : Number of bits per (modulated) symbol
%      Nfft    : FFT Size
%      nSTO    : Number of samples corresponding to STO
%      SNR dB
%      MaxIter : No. of iteration

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

clear, figure(1), clf, figure(2), clf
nSTOs = [-3 -3 2 2]; % 对应的STO采样数
CFOs = [0 0.5 0 0.5];
%CFOs = [0 0 0 0];
SNRdB=30; MaxIter=10; % 迭代次数
Nfft=128; Ng=Nfft/4; % FFT size and GI (CP) length |FFT大小，GI(CP)长度
Nofdm=Nfft+Ng; % OFDM symbol length|OFDM符号长度
Nbps=2; M=2^Nbps; % Number of bits per (modulated) symbol
mod_object = modem.qammod('M',M, 'SymbolOrder','gray');
Es=1; A=sqrt(3/2/(M-1)*Es); % Signal energy and QAM normalization factor|信号能量和QAM归一化因子
N=Nfft;  com_delay = Nofdm/2; % Common delay|公共时延
Nsym=100;
%%seed
rand('seed',1); randn('seed',1);
h=[complex(randn,randn),0,0,0,complex(randn,randn)/sqrt(16),complex(randn,randn)/sqrt(18)]/sqrt(2);
h=0.5.^[0:5]; 
h=[complex(randn,randn) 0.5*complex(randn,randn) 0.25*complex(randn,randn) 0.125*complex(randn,randn) 0.0625*complex(randn,randn) 0.03125*complex(randn,randn)];
for i=1:length(nSTOs)
   nSTO= nSTOs(i);  CFO= CFOs(i);
   %if i==3, rand('seed',8); randn('seed',8);  end
   %Transmit signal
   x = []; % Initialize a block of OFDM signals|初始化OFDM信号
   for m=1:Nsym % random bits generates |发送OFDM符号
      msgint=randint(1,N,M); %bits_generator(1,Nsym*N,Nbps)
      %Xf1 = QAM(msgint,Nbps); % constellation mapping. average power=1 
      %Xf= A*qammod(msgint,M); % constellation mapping. average power=1  
      Xf = A*modulate(mod_object,msgint);
      %discrepancy=norm(Xf-Xf1)
      %Xf1= A*modulate(modem.qammod(M),msgint([(m-1)*N+1:m*N]));
      xt = ifft(Xf,Nfft);  
      x_sym = add_CP(xt,Ng);
      x = [x x_sym]; 
   end
   %%channel
   %figure(3), subplot(221), plot(Xf,'.'), %subplot(222), plot(Xf1,'.')
   %channel_(h,0); y= channel_(x_syms);
   y = x;  % No channel effect|没有信道影响
   %%Signal power calculation
   sig_pow = y*y'/length(y); % sig_pow= mean(mean(y.*conj(y),2))
   %%Frequency offset + Symbol Time Offset|加CFO和STO
   y_CFO= add_CFO(y,CFO,Nfft); y_CFO_STO= add_STO(y_CFO,-nSTO);
   v_ML=zeros(1,Ng); v_Cl=zeros(1,Ng);
   Mag_cor= 0; Mag_dif= 0; % 相关函数（式5.12）或差值函数（式5.11）的时变轨迹
   %%Add additive white gaussian noise
   for iter=1:MaxIter
      %y_aw= add_AWGN(y_CFO_STO,sig_pow,SNRdB,'SNR',Nbps);  % AWGN added|
      y_aw = awgn(y_CFO_STO,SNRdB,'measured');
      %%%%%%%Symbol Timing Acqusition|获取符号定时
      [STO_cor,mag_cor]= STO_by_correlation(y_aw,Nfft,Ng,com_delay);
      [STO_dif,mag_dif]= STO_by_difference(y_aw,Nfft,Ng,com_delay);
      v_ML(-STO_cor+Ng/2)= v_ML(-STO_cor+Ng/2)+1;
      v_Cl(-STO_dif+Ng/2)= v_Cl(-STO_dif+Ng/2)+1;
      Mag_cor= Mag_cor+mag_cor;
      Mag_dif= Mag_dif+mag_dif;
   end % End of for loop of iter
   %%%%%%% Probability
   v_ML_v_Cl= [v_ML; v_Cl]*(100/MaxIter);
   figure(1), set(gca,'fontsize',9), subplot(220+i)
   bar(-Ng/2+1:Ng/2,v_ML_v_Cl'), hold on, grid on
   str=sprintf('nSTO Estimation: nSTO=%d, CFO=%1.2f, SNR=%3d[dB]',nSTO,CFO,SNRdB);
   title(str); xlabel('Sample'), ylabel('Probability');
   legend('ML','Classen'); axis([-Ng/2-1 Ng/2+1 0 100])
   %%%%%%% Time metric
   Mag_cor = Mag_cor/MaxIter; [Mag_cor_max,ind_max] = max(Mag_cor); nc= ind_max-1-com_delay; 
   Mag_dif = Mag_dif/MaxIter; [Mag_dif_min,ind_min] = min(Mag_dif); nd= ind_min-1-com_delay;
   nn=-Nofdm/2+[0:length(Mag_cor)-1]; nt= nSTO;
   figure(2), subplot(220+i), plot(nn,Mag_cor,nn,1.5*Mag_dif,'r:','markersize',1), hold on
   stem(nc,Mag_cor_max,'b','markersize',5), stem(nSTO,Mag_cor(nSTO+com_delay+1),'k.','markersize',5) % Estimated/True Maximum value
   str1=sprintf('STO Estimation - ML(b-)/Classen(r:) for nSTO=%d, CFO=%1.2f',nSTO,CFO); %,SNRdB);
   title(str1); xlabel('Sample'), ylabel('Magnitude'); 
   %stem(n1,Mag_dif_min,'r','markersize',5)
   stem(nd,Mag_dif(nd+com_delay+1),'r','markersize',5)
   stem(nSTO,Mag_dif(nSTO+com_delay+1),'k.','markersize',5) % Estimated/True Minimum value
   set(gca,'fontsize',9, 'XLim',[-32 32], 'XTick',[-10 -3 0 2 10]) %, xlim([-50 50]),
end % End of for loop of i