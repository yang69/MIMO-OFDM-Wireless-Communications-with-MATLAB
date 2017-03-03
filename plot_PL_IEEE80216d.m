% do_PL_IEEE80216d.m

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

clear, clf, clc 
fc=2e9; htx=[30 30]; hrx=[2 10]; distance=[1:1000];
for k=1:2    
  y_IEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt');
  y_MIEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt','mod');
end
subplot(121)
semilogx(distance,y_IEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_IEEE16d(2,:),'k-','linewidth',1.5), grid on 
title(['IEEE 802.16d Path loss Models, f_c=',num2str(fc/1e6),'MHz'])
axis([1 1000 10 150]), xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m',2)
subplot(122)
semilogx(distance,y_MIEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_MIEEE16d(2,:),'k-','linewidth',1.5), grid on 
title(['Modified IEEE 802.16d Path loss Models, f_c=', num2str(fc/1e6), 'MHz'])
axis([1 1000 10 150]), xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m',2)
