% plot_Ray_Ric_channel.m

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

clear, clf
N=200000; level=30; K_dB=[-40 15];
Rayleigh_ch=zeros(1,N); Rician_ch=zeros(2,N);
color=['k']; line=['-']; marker=['s','o','^'];
% Rayleigh model
Rayleigh_ch=Ray_model(N); 
[temp,x]=hist(abs(Rayleigh_ch(1,:)),level);   
plot(x,temp,['k-' marker(1)]), hold on
% Rician model
for i=1:length(K_dB);
    Rician_ch(i,:)=Ric_model(K_dB(i),N);
    [temp x]=hist(abs(Rician_ch(i,:)),level);   
    plot(x,temp,['k-' marker(i+1)]);
end
xlabel('x'), ylabel('Occurance')
legend('Rayleigh','Rician, K=-40dB','Rician, K=15dB')
