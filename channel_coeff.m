function hh=channel_coeff(NT,NR,N,Rtx,Rrx,type)
%   correlated Rayleigh MIMO channel coefficient
%   Inputs:
%       NT    : number of transmitters
%       NR    : number of receivers
%       N     : legnth of channel matrix
%       Rtx   : correlation vector/matrix of Tx 
%                  e.g.) [1 0.5], [1 0.5;0.5 1]
%       Rrx   : correlation vecotor/matrix of Rx
%       type  : correlation type: 'complex' or 'field'
%   Outputs:
%       hh     : NR x NT x N correlated channel

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

% uncorrelated Rayleigh fading channel, CN(1,0)
h=sqrt(1/2)*(randn(NT*NR,N)+j*randn(NT*NR,N));
if nargin<4,  hh=h;  return;   end    % Uncorrelated channel
if isvector(Rtx),   Rtx=toeplitz(Rtx);   end
if isvector(Rrx),   Rrx=toeplitz(Rrx);   end
% Narrow band correlation coefficient
if strcmp(type,'complex')      
C = chol(kron(Rtx,Rrx))';        % Complex correlation
else                         
C = sqrtm(sqrt(kron(Rtx,Rrx))); % Power (field) correlation
end 
% Apply correlation to channel matrix
hh=zeros(NR,NT,N);
for i=1:N,   tmp=C*h(:,i);  hh(:,:,i)=reshape(tmp,NR,NT);  end
