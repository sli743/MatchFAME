%% require dim = [m1, m2, m3, .... m_n]
%% require d = the size of the universe
%% X = relative partial perm (ij-th block of X is Xij)
%% SMat = n by n matrix of corruption levels (ij-th element is sij estimated by cemp)
%% t_max: number of iterations in PPM
%% m: number of edges
%% [Ind_i, Ind_j] is m by 2 indices matrix


%% make sure that SMat, AdjMat and X are sparse matrices !!!
%% make sure that the diagonal elements of X are 0 by X = X-diag(diag(X));

function P_est = MinimumSpanningTree_dense(SMat,dim,d,m,AdjMat,X)
t_max = 100;
blk_ind = [0, cumsum(dim)];
N = blk_ind(end); % or N=size(X,1);
DG = SMat+2*AdjMat;


[tree,~]=graphminspantree(DG);
[T1, T2, ~] = find(tree);
sizetree=size(T1,1);
n = size(SMat,1);
AdjTree = zeros(n);
for k=1:sizetree
    i=T1(k); j=T2(k);
    AdjTree(i,j)=1;
    AdjTree(j,i)=1;
end
%[~, rootnodes]=max(sum(AdjTree));
[S,C] = graphconncomp(sparse(AdjTree));
rootnodes = find(C==1,1);
added=zeros(1,n);
P_est = zeros(N, d);
P_est((blk_ind(rootnodes)+1):blk_ind(rootnodes+1), :)=eye(dim(rootnodes), d);
added(rootnodes)=1;
newroots = [];
while sum(added)<sum(C==1)
    for node_root = rootnodes
        leaves = find((AdjTree(node_root,:).*(1-added))==1);
        newroots = [newroots, leaves];
        for node_leaf=leaves
            P_new = X((blk_ind(node_leaf)+1):blk_ind(node_leaf+1), (blk_ind(node_root)+1):blk_ind(node_root+1)) * ...
            P_est((blk_ind(node_root)+1):blk_ind(node_root+1), :);
            P_est((blk_ind(node_leaf)+1):blk_ind(node_leaf+1), :) = ...
            matrix2permutation(P_new);
            
            P1 = P_est((blk_ind(node_leaf)+1):blk_ind(node_leaf+1),:);
            EmptyCols = find(sum(P1,1)==0);
            EmptyRows = find(sum(P1,2)==0);
            for i = (blk_ind(node_leaf)+1):blk_ind(node_leaf+1)
                if sum(P_est(i,:))==0
                    j = randsample(EmptyCols,1);
                    P_est(i,j)=1;
                end
            end
%             l = length(EmptyRows)+1;
%             while l > length(EmptyRows)
%                 l = length(EmptyRows);
%                 P1(EmptyRows,EmptyCols) = matrix2permutation(P_new(EmptyRows,EmptyCols));
%                 EmptyRows = find(sum(P1,2)==0);
%             end
%             P_est((blk_ind(node_leaf)+1):blk_ind(node_leaf+1),:) = P1;



%             EmptyNodes = find(~sum(P_est((blk_ind(node_leaf)+1):blk_ind(node_leaf+1), :)));
%             for j=1:dim(node_leaf)
%                 if nnz(P_est(blk_ind(node_leaf)+j,:))==0 
%                     P_est(blk_ind(node_leaf)+j,EmptyNodes(randi([1,length(EmptyNodes)]))) = 1;
%                 end
%             end
            added(node_leaf)=1;
        end
    end
    rootnodes = newroots;
end

% EmptyRows = find(sum(P_est,2)==0);
% for j=1:d
%     if sum(P_est(:,j))==0
%         i = randsample(EmptyRows,1);
% %             P_est(randi([blk_ind(i)+1,blk_ind(i+1)]),j)=1;
%         P_est(i,j)=1;
%     end
% %     EmptyRows = setdiff(EmptyRows,i);
% end
P_est = sparse(P_est);
% Weights = exp(-SMat).*AdjMat;
% row_sum = sum(Weights,2);
% Weights(row_sum==0,:)=1; % avoid zero rowsums
% row_sum(row_sum==0)=n;
% Weights = diag(1./row_sum)*Weights; % weight normalization (the weight matrix has row sum 1 and is NOT symmetric).
% 
% Xw = X;
% for k = 1:m
%     i = Ind_i(k); j = Ind_j(k);
%     Xw((blk_ind(i)+1):blk_ind(i+1), (blk_ind(j)+1):blk_ind(j+1)) = ...
%     X((blk_ind(i)+1):blk_ind(i+1), (blk_ind(j)+1):blk_ind(j+1)) * Weights(i,j);
% 
%     Xw((blk_ind(j)+1):blk_ind(j+1), (blk_ind(i)+1):blk_ind(i+1)) = ...
%     X((blk_ind(j)+1):blk_ind(j+1), (blk_ind(i)+1):blk_ind(i+1)) * Weights(j,i);
% end  
% 
% t=1;
% 
% score = inf;
% while score>1e-8 && t<=t_max
%     
%     P_old = P_est;
%     P_est = Xw * P_old;
%     for i=1:n
%         P_est((blk_ind(i)+1):blk_ind(i+1), :) = matrix2permutation( P_est((blk_ind(i)+1):blk_ind(i+1), :) );
%     end
%   
%     score = (norm(P_est-P_old,'fro'))^2/(2*d);
%    
%     
%     t=t+1;
% 
% end
% 
% X_est = P_est * P_est';  



