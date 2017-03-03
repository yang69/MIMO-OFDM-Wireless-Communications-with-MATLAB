function [symbol_replica_norm]=calculate_norm(symbol_replica,stage)
% Input parameters
%     Y_tilde : Q'*Y
%     R : [Q R] = qr(H)
%     QAM_table : 
%     symbol_replica : M candidate vectors
%     stage : stage number
%     M : M parameter in M-algorithm
%     nT : number of Tx antennas
% Output parameter
%     symbol_replica_norm : norm values of M candidate vectors

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

global  QAM_table  R  Y_tilde  nT  M;
if stage == 1;  m = 1;  else m = M; end
stage_index = (nT+1)-stage;
for i=1:m
    X_temp = zeros(nT,1);
    for a=nT:-1:(nT+2)-stage 
        X_temp(a) = QAM_table(symbol_replica((nT+1)-a,i,stage_index+1));
    end
    X_temp([(nT+2)-stage:(nT)]) = wrev(X_temp([(nT+2)-stage:(nT)])); % reordering
    Y_tilde_now = Y_tilde([(nT+1)-stage:(nT)]); % Y_tilde used in the current stage    
    R_now = R([(nT+1)-stage:(nT)],[(nT+1)-stage:(nT)]);
    % R used in the current stage
    for k = 1:length(QAM_table) % norm calculation,
        % the norm values in the previous stages can be used, however, 
        % we recalculate them in an effort to simplify the MATLAB code        
        X_temp(stage_index) = QAM_table(k);
        X_now = X_temp([(nT+1)-stage:(nT)]);  
        symbol_replica_norm(i,k) = norm(Y_tilde_now - R_now*X_now)^2;
    end
end
