function [symbol_replica] = stage_processing1(symbol_replica,stage)
% Input 
%     symbol_replica : M candidate vectors
%     stage : stage number
% Output 
%     symbol_replica : M candidate vectors 

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

global nT M;
% nT: Number of Tx antennas, M= M-algorithm parameter 
if stage == 1; m = 1; else m = M; end 
symbol_replica_norm = calculate_norm(symbol_replica,stage);
[symbol_replica_norm_sorted, symbol_replica_sorted] 
= sort_matrix(symbol_replica_norm);  
% sort in norm order, data is in a matrix form
symbol_replica_norm_sorted = symbol_replica_norm_sorted(1:M);
symbol_replica_sorted = symbol_replica_sorted(:,[1:M]); 
if stage>=2 
    for i=1:m
        symbol_replica_sorted([2:stage],i)  =  ...
        symbol_replica([1:stage-1],symbol_replica_sorted(2,i),(nT+2)-stage);   
    end
end
if stage == 1 % In stage 1, size of symbol_replica_sorted is 2xM, the second row is not necessary  
  symbol_replica([1:stage],:,(nT+1)-stage) = symbol_replica_sorted(1,:);
else
  symbol_replica([1:stage],:,(nT+1)-stage) = symbol_replica_sorted;
end
