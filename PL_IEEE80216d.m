function PL=PL_IEEE80216d(fc,d,type,htx,hrx,corr_fact,mod)
% IEEE 802.16d model
% Input - fc       : carrier frequency
%         d        : between base and terminal
%         type     : selects 'A', 'B', or 'C' 
%         htx      : height of transmitter
%         hrx      : height of receiver
%         corr_fact: if shadowing exists, set to 'ATnT' or 'Okumura'. Otherwise, 'NO'
%         mod      : set to 'mod' to get the modified IEEE 802.16d model
% output - PL      : path loss [dB]

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

Mod='UNMOD';
if nargin>6, Mod=upper(mod);  end
if nargin==6&&corr_fact(1)=='m', Mod='MOD'; corr_fact='NO';  
 elseif nargin<6, corr_fact='NO';
  if nargin==5&&hrx(1)=='m', Mod='MOD'; hrx=2;
   elseif nargin<5, hrx=2;
    if nargin==4&&htx(1)=='m', Mod='MOD'; htx=30;
     elseif nargin<4, htx=30;
      if nargin==3&&type(1)=='m', Mod='MOD'; type='A';         
       elseif nargin<3, type='A';   
      end 
    end
  end    
end
d0 = 100;
Type = upper(type);
if Type~='A'&& Type~='B'&&Type~='C'
  disp('Error: The selected type is not supported');  return;
end
switch upper(corr_fact)
  case 'ATNT',    Cf=6*log10(fc/2e9);  C_Rx=-10.8*log10(hrx/2);
  case 'OKUMURA', Cf=6*log10(fc/2e9);
                  if hrx<=3, C_Rx=-10*log10(hrx/3);  
                   else, C_Rx=-20*log10(hrx/3); 
                  end
  case 'NO',      Cf=0;  C_Rx=0;
end
if Type=='A',  a=4.6; b=0.0075; c=12.6;
 elseif Type=='B',  a=4; b=0.0065; c=17.1;
 else     a=3.6; b=0.005; c=20;
end
lamda=3e8/fc; gamma=a-b*htx+c/htx; d0_pr=d0;
if Mod(1)=='M', d0_pr=d0*10^-((Cf+C_Rx)/(10*gamma)); end
A = 20*log10(4*pi*d0_pr/lamda) + Cf + C_Rx;
%fprintf('Cf+C_Rx=%8.4e,  d0=%8.4f, d0_pr=%8.4f, %s\n', Cf+C_Rx,d0,d0_pr, corr_fact)
for k=1:length(d)
   if d(k)>d0_pr,  PL(k) = A + 10*gamma*log10(d(k)/d0);
    else,  PL(k) = -10*log10((lamda/(4*pi*d(k)))^2);
   end
end
