%channel_estimation.m
% for LS/DFT Channel Estimation with linear/spline interpolation|采用线性/样条插值的LS/DFT信道估计

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

clear all; close all; figure(1), clf, figure(2), clf
Nfft=32;  Ng=Nfft/8;  Nofdm=Nfft+Ng;  Nsym=100;
Nps=4; Np=Nfft/Nps; Nd=Nfft-Np; % Pilot spacing, Numbers of pilots and data per OFDM symbol|导频间隔、每个OFDM符号的导频数、每个OFDM符号的数据数量
Nbps=4; M=2^Nbps; % Number of bits per (modulated) symbol|每个调制符号的比特数
mod_object = modem.qammod('M',M, 'SymbolOrder','gray');
demod_object = modem.qamdemod('M',M, 'SymbolOrder','gray');
Es=1; A=sqrt(3/2/(M-1)*Es); % Signal energy and QAM normalization factor|信号能量、QAM归一化因子
%fs = 10e6;  ts = 1/fs;  % Sampling frequency and Sampling period
SNRs = [30];  sq2=sqrt(2);
for i=1:length(SNRs)
   SNR = SNRs(i); 
   rand('seed',1); randn('seed',1);
   MSE = zeros(1,6); nose = 0; % 变量nose用于统计错误符号数，Number_of_symbol_errors
   for nsym=1:Nsym
      Xp = 2*(randn(1,Np)>0)-1;    % Pilot sequence generation|生成导频序列，-1和+1的随机序列
      %Data = ((2*(randn(1,Nd)>0)-1) + j*(2*(randn(1,Nd)>0)-1))/sq2; % QPSK modulation
      msgint=randint(1,Nfft-Np,M);    % bit generation|生成比特
      Data = modulate(mod_object,msgint)*A;
      %Data = modulate(mod_object, msgint); Data = modnorm(Data,'avpow',1)*Data;   % normalization
      ip = 0;    pilot_loc = [];
      for k=1:Nfft % 在频域的特定位置加入导频和数据
         if mod(k,Nps)==1
           X(k) = Xp(floor(k/Nps)+1); pilot_loc = [pilot_loc k]; ip = ip+1;
          else        X(k) = Data(k-ip); % ip指示了当前OFDM符号中已经加入的导频的数量
         end
      end
      x = ifft(X,Nfft);                            % IFFT
      xt = [x(Nfft-Ng+1:Nfft) x];                  % Add CP|加循环前缀
      h = [(randn+j*randn) (randn+j*randn)/2];     % generates a (2-tap) channel|产生一个2抽头信道
      H = fft(h,Nfft); channel_length = length(h); % True channel and its time-domain length|实际信道和它的长度
      H_power_dB = 10*log10(abs(H.*conj(H)));      % True channel power in dB|实际信道的功率[dB]
      y_channel = conv(xt, h);                     % Channel path (convolution)|信道路径（卷积）
      sig_pow = mean(y_channel.*conj(y_channel));
      %y_aw(1,1:Nofdm) = y(1,1:Nofdm) + ...
      %   sqrt((10.^(-SNR/10))*sig_pow/2)*(randn(1,Nofdm)+j*randn(1,Nofdm)); % Add noise(AWGN)
      yt = awgn(y_channel,SNR,'measured');  
      y = yt(Ng+1:Nofdm);                   % Remove CP|去CP
      Y = fft(y);                           % FFT
      for m=1:3
         if m==1, H_est = LS_CE(Y,Xp,pilot_loc,Nfft,Nps,'linear'); method='LS-linear'; % LS estimation with linear interpolation
          elseif m==2, H_est = LS_CE(Y,Xp,pilot_loc,Nfft,Nps,'spline'); method='LS-spline'; % LS estimation with spline interpolation
          else  H_est = MMSE_CE(Y,Xp,pilot_loc,Nfft,Nps,h,SNR); method='MMSE'; % MMSE estimation
         end
         H_est_power_dB = 10*log10(abs(H_est.*conj(H_est)));
         h_est = ifft(H_est); h_DFT = h_est(1:channel_length); 
         H_DFT = fft(h_DFT,Nfft); % DFT-based channel estimation
         H_DFT_power_dB = 10*log10(abs(H_DFT.*conj(H_DFT)));
         if nsym==1
           figure(1), subplot(319+2*m), plot(H_power_dB,'b','linewidth',1); grid on; hold on;
           plot(H_est_power_dB,'r:+','Markersize',4,'linewidth',1); axis([0 32 -6 10])
           title(method); xlabel('Subcarrier Index'); ylabel('Power[dB]');
           legend('True Channel',method,4);  set(gca,'fontsize',9)
           subplot(320+2*m), plot(H_power_dB,'b','linewidth',1); grid on; hold on;
           plot(H_DFT_power_dB,'r:+','Markersize',4,'linewidth',1); axis([0 32 -6 10])
           title([method ' with DFT']); xlabel('Subcarrier Index'); ylabel('Power[dB]');
           legend('True Channel',[method ' with DFT'],4);  set(gca,'fontsize',9)
         end
         MSE(m) = MSE(m) + (H-H_est)*(H-H_est)';
         MSE(m+3) = MSE(m+3) + (H-H_DFT)*(H-H_DFT)';
      end
      Y_eq = Y./H_est;
      if nsym>=Nsym-10
        figure(2), subplot(221), plot(Y,'.','Markersize',5), axis([-1.5 1.5 -1.5 1.5])
        axis('equal'), set(gca,'fontsize',9), hold on,
        subplot(222), plot(Y_eq,'.','Markersize',5), axis([-1.5 1.5 -1.5 1.5])
        axis('equal'), set(gca,'fontsize',9), hold on,       
      end
      ip = 0;
      for k=1:Nfft
         if mod(k,Nps)==1, ip=ip+1;  else  Data_extracted(k-ip)=Y_eq(k);  end
      end
      msg_detected = demodulate(demod_object,Data_extracted/A);
      nose = nose + sum(msg_detected~=msgint);
   end   
   MSEs(i,:) = MSE/(Nfft*Nsym);
end   
Number_of_symbol_errors=nose
figure(3), clf, semilogy(SNRs',MSEs(:,1),'-x', SNRs',MSEs(:,3),'-o')
legend('LS-linear','MMSE')
fprintf('MSE of LS-linear/LS-spline/MMSE Channel Estimation = %6.4e/%6.4e/%6.4e\n',MSEs(end,1:3));
fprintf('MSE of LS-linear/LS-spline/MMSE Channel Estimation with DFT = %6.4e/%6.4e/%6.4e\n',MSEs(end,4:6));