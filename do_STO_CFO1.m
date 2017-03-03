%do_CFO

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

clear, clf
pi2 = pi*2; pm = 1; CFO = 0.023; ph_offset = 0; % pilot, CFO, and phase offset
a = 10;  % Set a = 1~10 for full/no consideration of channel effect 
KC_CFO = 1; % Set to 1 or 0 for CFO compensation or not
KC_PH = 1;  % Set to 1 or 0 for Phase compensation
N_FFT=64; N_GI=16; N_GI1=N_GI+1; N_FFT1=N_FFT+1; % N_Prefix=16; 
N_SD=N_FFT+N_GI; N_SD1=N_SD+1; Nw=N_SD; Nw1=Nw+1; Nw2=Nw*2; Nw4=Nw*4;  
%N_d=120; % the remaining period of the last symbol in the previous frame
Nbps=2; Ncp=4; N_Null=N_SD; N_OFDM=2;   gsymbols = 'v<>^'; %N_OFDM symbols
ch_coef = exp(-a*[0:15]).'; H = fft(ch_coef,N_FFT);  % Channel response 
w_energy = zeros(1,Nw1); power = zeros(1,Nw1); energy_ratios = zeros(1,Nw1);
corr_sig1 = zeros(1,N_GI1);   corr_sig2 = zeros(1,N_FFT1);
ch_length = length(ch_coef);  ch_length1 = ch_length - 1;
ch_buf = zeros(1,ch_length);  rx_buf = zeros(1,N_SD1);  rxs_buf = [];
subplot(331), hold on
n = 0; i_STO = 0; nose = 0; % nose = number of symbol errors
w_corr1 = 0; w_corr10 = 0; w_corr2 = 0; 
Max_energy_ratio=0; Min_energy_ratio=1e10;
Frame_start_point = -N_SD; OFDM_start_points = [-N_SD];   
[short_tr_seq,short_tr] = short_training_sequence(N_FFT);
[long_tr_seq,long_tr] = long_training_sequence(N_FFT);
% time-domain training symbol and two OFDM symbols
Nd=80; any_symbol = 0.1*(rand(1,Nd)+j*rand(1,Nd));
tx = [any_symbol zeros(1,N_Null) short_tr_seq long_tr_seq];
Start_found = 0; Null_found = 0; Null_start_point = 0;
for i=1:6+N_OFDM
   if i<7,  tx_cp = tx((i-1)*N_SD+[1:N_SD]);   
    else  msg = randint(1,N_FFT*Nbps); % msgs = [msgs msg];
          if i>7,  tx_mod_prev = tx_mod;  
           elseif i==7,  tx_mod_prev = tx_cp;  % long_tr not to be compared with any QAM
          end    % tx_mod transmitted previously
          tx_mod = QAM(msg,Nbps);                    % QAM
          tx_mod([8 22 44 58]) = [pm -pm pm pm];     % pilot
          tx_ifft = ifft(tx_mod,N_FFT);              % IFFT
          tx_cp = [tx_ifft(end-N_GI+1:end) tx_ifft]; % add CP
          for m=[1:7 9:21 23:43 45:57 59:64]
             txm = tx_mod(m); tmp = [real(txm) imag(txm)]>0;
             gsymbol = gsymbols(bin2deci(tmp,Nbps)+1);  plot(txm,gsymbol)  
          end
   end
   for in=1:N_SD
      n = n+1;
      ch_buf = [tx_cp(in) ch_buf(1:end-1)];  % the channel buffer
      rxn = ch_buf*ch_coef*exp(j*2*pi*CFO/N_FFT*(n-1)+ph_offset); % received signal with CFO
      rxn = rxn + 0.01*(randn+j*randn); rxs_buf = [rxs_buf rxn];
      rx_buf = [rx_buf(2:end) rxn]; % the received signal buffer
      % the window of instantaneous signal power
      power = [power(2:end) rx_buf(end)'*rx_buf(end)];  
      % the window of signal energy for the duration of N_GI
      w_energy = [w_energy(2:end) w_energy(end)+power(end)]; 
      if n>Nw, w_energy(end) = w_energy(end)-power(1); end % N_GI+N_FFT
      if n>Nw1
        energy_ratio = w_energy(end)/w_energy(1);
        energy_ratios = [energy_ratios energy_ratio];
        if energy_ratio<Min_energy_ratio
          Min_energy_ratio = energy_ratio; 
         elseif Null_found<1, Null_start_point = n-1-Nw; Null_found = 1;
        end
        if energy_ratio>Max_energy_ratio
          Max_energy_ratio = energy_ratio; Start_found = 0; 
         elseif Start_found<10&Null_start_point>0&n-Null_start_point>50+Nw
          Frame_start_point = n-Start_found-Nw; Start_found = Start_found+1;
        end
        %if Frame_start_point-, close_to_Frame_start = 1; end
      end
      corr_sig1(1:end-1) = corr_sig1(2:end);  corr_sig2(1:end-1) = corr_sig2(2:end);
      if Frame_start_point>0&n>Frame_start_point
        % correlation between two points spaced N_GI samples apart for short-time training seq
        if n<Frame_start_point+Nw2        
          corr_sig1(end) = rx_buf(end)*rx_buf(end-N_GI)';  
          w_corr1 = w_corr1 + corr_sig1(end); 
        end  
        if n>Frame_start_point+N_GI,  w_corr1 = w_corr1 - corr_sig1(1);  end
        if n==Frame_start_point+8*N_GI, w_corr10 = w_corr1;  end
        if n==Frame_start_point+9*N_GI
          coarse_CFO_est = (angle(w_corr10)+angle(w_corr1))/pi
        end
      end
      if Start_found>9&n>Frame_start_point+Nw2
        % correlation between two points spaced N_FFT samples apart for long-time training seq
        if n<=Frame_start_point+Nw4
          corr_sig2(end) = rx_buf(end)*rx_buf(end-N_FFT)';  
          w_corr2 = w_corr2 + corr_sig2(end); 
        end
        if n>Frame_start_point+Nw2+N_FFT,  w_corr2 = w_corr2 - corr_sig2(1);  end
        if n==Frame_start_point+Nw4, fine_CFO_est = angle(w_corr2)/pi2,  end
      end
      %CFO_est = coarse_CFO_est
      if Frame_start_point>0&n>Frame_start_point+Nw4+Nw&(mod(n,N_SD)==2)  
        rx_wo_CP = rx_buf(end-N_FFT1:end-2); % CP removed
        if KC_CFO>0
          rx_wo_CP = rx_wo_CP.*exp(-j*2*pi*CFO/N_FFT*[n-2-N_FFT:n-3]); % CFO compensated
        end  
        rx_fft = fft(rx_wo_CP,N_FFT);
        rx_fft_ch_comp = rx_fft.*H'/(H'*H);  % Channel compensation
        phd14 = angle(rx_fft_ch_comp(22))+pi-angle(rx_fft_ch_comp(8));
        while phd14>=pi,  phd14 = phd14 - pi2;  end
        phd = phd14/14
        rx_fft_ph_comp = rx_fft_ch_comp;
        if KC_PH>0, rx_fft_ph_comp = rx_fft_ch_comp.*exp(-j*phd*[0:N_FFT-1]); end 
        rx_sliced = QAM4_slicer(rx_fft_ph_comp);
        rx_dem = QAM_dem(rx_sliced,Nbps);
        tx_block1 = tx_mod_prev([1:7 9:21 23:43 45:57 59:64]);
        rx_sliced1 = rx_sliced([1:7 9:21 23:43 45:57 59:64]);
        nose = nose + sum(tx_block1~=rx_sliced1);
        for m=[1:7 9:21 23:43 45:57 59:64] 
           txm = tx_mod_prev(m); tmp = [real(txm) imag(txm)]>0;
           gsymbol = gsymbols(bin2deci(tmp,Nbps)+1);    
           subplot(332), hold on, plot(rx_fft_ch_comp(m),gsymbol);  
           subplot(333), hold on, plot(rx_sliced(m),gsymbol);
        end
      end
   end
end
%no_of_bit_errors = sum(msgs([1:length(rxs_dem)])~=rxs_dem)
no_of_symbol_errors = nose
subplot(312), plot(energy_ratios,'m'), hold on
height=50; plot(height*abs(rxs_buf))
Frame_start_point
length_txs_cp = n; % Total number of samples
True_start_points = 1+[0 80 160 320 480 560 640];
N_True_start_points=length(True_start_points);
stem(True_start_points,height*ones(1,N_True_start_points),'k*')
stem(Frame_start_point,height,'rx'), stem(Frame_start_point+Nw-1,height,'r:'), 
title('Estimated Frame Start Point and Energy Ratio across N_Null samples')

