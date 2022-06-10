function [P] = MatchFAME(Z,dimPerm,AdjMat,d,gamma,eps,varargin)
% MatchFAME
% gamma = 20 for synthetic data, gamma = 4 for real data
% eps = 1e-2 for synthetic data, eps = 0 for real data
dimPerm = reshape(dimPerm,length(dimPerm),1);
cumIndex = cumsum([0;dimPerm])';
ncams = length(dimPerm);
%% Set diagonal Blocks to zero
Z = Z-diag(diag(Z));
%% CEMP-Partial
S0 = CEMP_partial(Z, dimPerm', length(dimPerm), AdjMat);
S0(isnan(S0))=1;
% Use 2*d for small data or synthetic data (such as EPFL), 16*d for large
% data (such as Photo Tourism)
if length(varargin)==1 && strcmp(varargin{1}, 'dense')
    P_init = MinimumSpanningTree_dense(sparse(S0),dimPerm',2*d,ncams,sparse(AdjMat),Z);
else
    P_init = MinimumSpanningTree(sparse(S0),dimPerm',2*d,ncams,sparse(AdjMat),Z);
end
P = P_init;
Z = sparse(Z);
%% ppm_mst Iteration
% for i=1:ncams
%     for j=i+1:ncams
%         Z(cumIndex(i)+1:cumIndex(i+1),cumIndex(j)+1:cumIndex(j+1)) = ...
%             (exp(-gamma*S0(i,j))) * Z(cumIndex(i)+1:cumIndex(i+1),cumIndex(j)+1:cumIndex(j+1));
%         Z(cumIndex(j)+1:cumIndex(j+1),cumIndex(i)+1:cumIndex(i+1)) = ...
%             (exp(-gamma*S0(j,i))) * Z(cumIndex(j)+1:cumIndex(j+1),cumIndex(i)+1:cumIndex(i+1));
%     end
% end
Z = Block_multiply(Z,cumIndex,exp(-gamma*S0));
Z = Z + speye(size(Z,1));
Z = row_normalize(Z);
% Z = sparse(1:size(Z,1),1:size(Z,1),1./sum(Z,2)) * Z;
for t=1:60
    P = Z*P;
    P(P<eps) = 0;
    for i=1:ncams
        P(cumIndex(i)+1:cumIndex(i+1),:) = matrix2permutation(P(cumIndex(i)+1:cumIndex(i+1),:).*(P(cumIndex(i)+1:cumIndex(i+1),:) > eps));
    end
end