function [W,W_gt,keypts_num,AdjMat,G] = Unif_corr_data_gen(p,q,p0,m,n)
% Input:
% p = 0.4; q = 0.75; m = 100; n = 15;
% p is the probability of each point observed in an image
% q is the corruption probability
% p0 is the probability for image Erdos Renyi graph
% m is the number of images
% n is the size of universe
% r is the random number generator

% Output:
% W: Observed key point correspondence matrix
% W_gt: Ground truth correspondence matrix
% perms_gt: Ground truth key point - universe correspondence matrix
% images: Ground truth key point label for each image
% keypts_num: key point number of each image
% index_list: cumsum of [0,keypts_num], stored for convenience

% rng(r);
A = rand(m,n) < p;
for i = 1:m
    images{i} = find(A(i,:));
    keypts_num(i) = length(images{i});
end

X = eye(n);
perms_gt = [];

for i = 1:m
    Y = randperm(n);
    perms_gt_vec{i} = Y(images{i});
    perms_gt = [perms_gt, X(:,perms_gt_vec{i})];
end

index_list = cumsum([0,keypts_num]);

perms_gt = sparse(perms_gt);
W_gt = perms_gt'*perms_gt;
W = zeros(size(W_gt,1),size(W_gt,2));
G = rand(m,m)<p0;
G = tril(G,-1);
G = G+G';
AdjMat = sparse(G);
while graphconncomp(AdjMat)~=1
    G = rand(m,m)<p0;
    G = tril(G,-1);
    G = G+G';
    AdjMat = sparse(G);
end
for i = 1:m
    l = find(AdjMat(i,:));
    for j = l(l>i)
        if rand<q
            G(i,j) = -1; G(j,i) = -1;
            Y = randperm(n);
            Y = X(:,Y);
            Y = Y(images{i},images{j});
            W(index_list(i)+1:index_list(i+1), index_list(j)+1:index_list(j+1)) = Y;
%             W = Block_add(W,index_list,i,j,Y);
            W(index_list(j)+1:index_list(j+1), index_list(i)+1:index_list(i+1)) = Y';
%             W = Block_add(W,index_list,j,i,Y');
        else
            W(index_list(i)+1:index_list(i+1), index_list(j)+1:index_list(j+1)) = ...
                W_gt(index_list(i)+1:index_list(i+1), index_list(j)+1:index_list(j+1));
            W(index_list(j)+1:index_list(j+1), index_list(i)+1:index_list(i+1)) = ...
                W_gt(index_list(j)+1:index_list(j+1), index_list(i)+1:index_list(i+1));
        end
    end
end

W = sparse(W);