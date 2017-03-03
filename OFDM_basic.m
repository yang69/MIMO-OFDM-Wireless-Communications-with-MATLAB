% OFDM_basic.m

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

clear all
NgType=1; % NgType=1/2 for cyclic prefix/zero padding|对于CP或ZP，NgType=1或2
if NgType==1, nt='CP';  elseif NgType==2, nt='ZP';   end
Ch=1;  % Ch=0/1 for AWGN/multipath channel|对于AWGN/多径瑞利信道，channelCh=0/1
if Ch==0, chType='AWGN'; Target_neb=100; else chType='CH'; Target_neb=500; end
figure(Ch+1), clf
PowerdB=[0 -8 -17 -21 -25]; % Channel tap power profile 'dB'|信道抽头功率特性 'dB'
Delay=[0 3 5 6 8];          % Channel delay 'sample'|信道时延（采样点）
Power=10.^(PowerdB/10);     % Channel tap power profile 'linear scale'|信道抽头功率特性（线性尺度）
Ntap=length(PowerdB);       % Chanel tap number|信道抽头数
Lch=Delay(end)+1;           % Channel length|信道长度
Nbps=4; M=2^Nbps;  % Modulation order=2/4/6 for QPSK/16QAM/64QAM|调制阶数=2/4/6：QPSK/16QAM/64QAM
Nfft=64;           % FFT size|FFT大小
Ng=3; %Nfft/4;         % Ng=0: Guard interval length|GI的长度，没有保护间隔时，Ng=0
% Ng=Nfft/4;
Nsym=Nfft+Ng;      % Symbol duration|符号周期
Nvc=Nfft/4;        % Nvc=0: no virtual carrier|Nvc=0：没有VC
Nused=Nfft-Nvc;
 
EbN0=[0:5:20];    % EbN0
N_iter=1e5;       % Number of iterations for each EbN0|对于每一个EbN0的迭代次数
Nframe=3;         % Number of symbols per frame|每一帧的符号数
sigPow=0;         % Signal power initialization|初始信号功率
file_name=['OFDM_BER_' chType '_' nt '_' 'GL' num2str(Ng) '.dat'];
fid=fopen(file_name, 'w+');
norms=[1 sqrt(2) 0 sqrt(10) 0 sqrt(42)];     % BPSK 4-QAM 16-QAM
for i=0:length(EbN0)
   randn('state',0); rand('state',0); 
   Ber=0;%原始代码为Ber2=ber();无法运行 % BER initialization |初始化BER
   Neb=0; Ntb=0; % Initialize the number of error/total bits|初始化错误比特数/总比特数
   for m=1:N_iter
      % Tx______________________________________________________________
      X= randint(1,Nused*Nframe,M); % bit: integer vector
      Xmod= qammod(X,M,0,'gray')/norms(Nbps);
      if NgType~=2, x_GI=zeros(1,Nframe*Nsym);
       elseif NgType==2, x_GI= zeros(1,Nframe*Nsym+Ng);
        % Extend an OFDM symbol by Ng zeros |用Ng个零扩展OFDM符号
      end
      kk1=[1:Nused/2]; kk2=[Nused/2+1:Nused]; kk3=1:Nfft; kk4=1:Nsym;
      for k=1:Nframe
         if Nvc~=0, X_shift= [0 Xmod(kk2) zeros(1,Nvc-1) Xmod(kk1)];
          else      X_shift= [Xmod(kk2) Xmod(kk1)];
         end
         x= ifft(X_shift);
         x_GI(kk4)= guard_interval(Ng,Nfft,NgType,x);
         kk1=kk1+Nused; kk2= kk2+Nused; kk3=kk3+Nfft; kk4=kk4+Nsym;
      end
      if Ch==0, y= x_GI;  % No channel|没有信道
       else  % Multipath fading channel|多径衰落信道
        channel=(randn(1,Ntap)+j*randn(1,Ntap)).*sqrt(Power/2);
        h=zeros(1,Lch); h(Delay+1)=channel; % cir: channel impulse response|信道脉冲响应
        y = conv(x_GI,h); 
      end
      if i==0 % Only to measure the signal power for adding AWGN noise|只测量信号功率
        y1=y(1:Nframe*Nsym); sigPow = sigPow + y1*y1';
        continue;
      end
      % Add AWGN noise________________________________________________|加AWGN噪声
      snr = EbN0(i)+10*log10(Nbps*(Nused/Nfft)); % SNR vs. Eb/N0|式4.28，由频域SNR算时域SNR
      noise_mag = sqrt((10.^(-snr/10))*sigPow/2); % N0=Eb/SNR
      y_GI = y + noise_mag*(randn(size(y))+j*randn(size(y)));
      % Rx_____________________________________________________________
      kk1=(NgType==2)*Ng+[1:Nsym]; kk2=1:Nfft;
      kk3=1:Nused; kk4=Nused/2+Nvc+1:Nfft; kk5=(Nvc~=0)+[1:Nused/2];
      if Ch==1
         H= fft([h zeros(1,Nfft-Lch)]); % Channel frequency response|信道频率响应
         H_shift(kk3)= [H(kk4) H(kk5)]; 
      end
      for k=1:Nframe
         Y(kk2)= fft(remove_GI(Ng,Nsym,NgType,y_GI(kk1)));
         Y_shift=[Y(kk4) Y(kk5)];
         if Ch==0,  Xmod_r(kk3) = Y_shift;
          else Xmod_r(kk3)= Y_shift./H_shift;  % Equalizer - channel compensation|均衡器
         end
         kk1=kk1+Nsym; kk2=kk2+Nfft; kk3=kk3+Nused; kk4=kk4+Nfft; kk5=kk5+Nfft;
      end
      X_r=qamdemod(Xmod_r*norms(Nbps),M,0,'gray');
      Neb=Neb+sum(sum(de2bi(X_r,Nbps)~=de2bi(X,Nbps)));
      Ntb=Ntb+Nused*Nframe*Nbps;  %[Ber,Neb,Ntb]=ber(bit_Rx,bit,Nbps); 
      if Neb>Target_neb, break; end
   end
   if i==0
     sigPow= sigPow/Nsym/Nframe/N_iter;
     fprintf('Signal power= %11.3e\n', sigPow);
     fprintf(fid,'%%Signal power= %11.3e\n%%EbN0[dB]       BER\n', sigPow);
    else
     Ber = Neb/Ntb;     
     fprintf('EbN0=%3d[dB], BER=%4d/%8d =%11.3e\n', EbN0(i), Neb,Ntb,Ber)
     fprintf(fid, '%d\t%11.3e\n', EbN0(i), Ber);
     if Ber<1e-6,  break;  end
   end
end
if (fid~=0),  fclose(fid);   end
disp('Simulation is finished');
plot_ber(file_name,Nbps);
