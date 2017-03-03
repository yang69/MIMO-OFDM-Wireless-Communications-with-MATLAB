function y_STO=add_STO(y,iSTO)
% 施加STO
%   y：接收信号
% iSTO：对应于STO的采样数

% MIMO-OFDM Wireless Communications with MATLAB㈢   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
% 2010 John Wiley & Sons (Asia) Pte Ltd

% http://www.wiley.com//legacy/wileychi/cho/

if iSTO>=0, 
    y_STO = [y(iSTO+1:end) zeros(1,iSTO)]; % advance|提前
else
    y_STO = [zeros(1,-iSTO) y(1:end+iSTO)];  % delay|滞后
end