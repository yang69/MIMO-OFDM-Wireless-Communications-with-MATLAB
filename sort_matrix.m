function [entry_sorted,entry_index_sorted] =  sort_matrix(matrix)
% Input parameters
%    matrix : a matrix to be sorted
% Output parameters
%    entry_sorted : increasingly ordered norm
%    entry_index_sorted : ordered QAM_table index

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

[Nrow,Ncol] = size(matrix);
flag=0; % flag = 1 ? the least norm is found
matrix_T=matrix.'; vector=matrix_T(:).'; % matrix  ? vector form
entry_index_sorted =[];
for m=1:Nrow*Ncol 
    entry_min = min(vector);
    flag=0;
    for i = 1:Nrow 
        if flag==1 break;
        end
        for k = 1:Ncol 
            if flag==1,   break;   end
            entry_temp = matrix(i,k);
            if entry_min == entry_temp
              entry_index_sorted = [entry_index_sorted [k; i]];
              entry_sorted(m) = entry_temp;
              vector((i-1)*Ncol+k)=10000000; 
              flag=1;
            end
        end
    end
end
