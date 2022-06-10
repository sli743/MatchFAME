function [Wij,Wij_orig,mat_size,AdjMat,GoodEdge] = local_advers_gen(n,d,n_node_corr,p,p_select,p_neighbor,option)
%n_node_corr=6;p_neighbor=0.9;option='mal';
% rng(rr);
% n=50; % number of images
% p=0.8; % prob of connection
q=0;
% d=10;
sigma=0;
% beta=1;
% beta_max=40;
% rate=2;
G = rand(n,n) < p;
G = tril(G,-1);
% generate adjacency matrix
AdjMat = sparse(G + G'); 
[Ind_j, Ind_i] = find(G==1);
Ind = [Ind_j, Ind_i;Ind_i, Ind_j];
m = length(Ind_i);

Inds = [];
% IndEnd = 0;
u = 1:d;
mat_size = [];
IndLog = [];
for i=1:n
    I = rand(d,1)<p_select;
    mat_size = [mat_size,sum(I)];
    Inds = [Inds,d*(i-1)+u(I)];
    IndLog = [IndLog,I];
end

P_orig = zeros(d,d,n);
Wi = zeros(d*n,d);
Wij = sparse(n*d,n*d);
Wij_orig = sparse(n*d,n*d);
for i = 1:n
    TempMat=eye(d);
    P_orig(:,:,i)=TempMat(randperm(d),:);
    Wi((d*i-(d-1)):(d*i),:)=P_orig(:,:,i);
end

Pij_orig = zeros(d,d,m);
IndMat = zeros(n,n);
for k = 1:m
    i=Ind_i(k); j=Ind_j(k); 
    IndMat(i,j) = k;
    IndMat(j,i) = -k;
    Pij_orig(:,:,k)=P_orig(:,:,i)*(P_orig(:,:,j)');
    Wij_orig((d*i-(d-1)):(d*i), (d*j-(d-1)):(d*j))=sparse(Pij_orig(:,:,k));
    Wij_orig((d*j-(d-1)):(d*j), (d*i-(d-1)):(d*i))=sparse((Pij_orig(:,:,k)))';
end
PijMat = Pij_orig;
noiseIndLog = rand(1,m)>=q;
% indices of corrupted edges
corrIndLog = logical(1-noiseIndLog);
noiseInd=find(noiseIndLog);
corrInd=find(corrIndLog);
PijMat(:,:,noiseInd)= ...
PijMat(:,:,noiseInd)+sigma*randn(d,d,length(noiseInd));
for k = noiseInd
    PijMat(:,:,k) = project_hungarian(PijMat(:,:,k));
    i=Ind_i(k); j=Ind_j(k);
    Wij((d*i-(d-1)):(d*i), (d*j-(d-1)):(d*j))=sparse(PijMat(:,:,k));
    Wij((d*j-(d-1)):(d*j), (d*i-(d-1)):(d*i))=sparse((PijMat(:,:,k))');
end    


%nb=[];
node_corr = randperm(n);
node_corr = node_corr(1:n_node_corr);
corrMat = zeros(n,n);


P_corr = zeros(d,d,n);

for i = 1:n
    TempMat=eye(d);
    P_corr(:,:,i)=TempMat(randperm(d),:);
end


GoodEdge = AdjMat;
for i = node_corr
    neighbor_cand = Ind(Ind(:,1)==i,2);
%     neighbor_cand = neighbor_cand(neighbor_cand>i);
    neighbor_cand = reshape(neighbor_cand, 1, length(neighbor_cand));
    neighbor_corr = randperm(length(neighbor_cand));
    n_neighbor = floor(p_neighbor * length(neighbor_cand));
    neighbor_corr = neighbor_corr(1:n_neighbor);
    neighbor_corr = neighbor_cand(neighbor_corr);
    %nb=[nb;neighbor_corr];
    for j = neighbor_corr 
        k = abs(IndMat(i,j));
        corrMat(i,j) = 1;corrMat(j,i) = 1;
        GoodEdge(i,j) = -1;GoodEdge(j,i) = -1;
        TempMat=eye(d);
        P0=TempMat(randperm(d),:);
        PijMat(:,:,k)= P0;    
        if (strcmp(option,'adv'))
            Q=P_corr(:,:,i)*(P_corr(:,:,j)')+sigma*randn(d,d);
            PijMat(:,:,k) = project_hungarian(Q);
        end
        if (strcmp(option,'mal'))
            PijMat(:,:,k) = P_corr(:,:,i)*(P_corr(:,:,j)');
            if (sum((P_orig(:,:,i)'*P_corr(:,:,i)).*((P_orig(:,:,j)'*P_corr(:,:,j))),'all')>=2)
                PijMat(:,:,k)= P0;  
            end
        end
        if strcmp(option,'mal2')
            permind=randperm(d,3);
            PijMat(:,:,k)=zeros(d,d);
            PijMat(setdiff(1:d,permind),setdiff(1:d,permind),k) = eye(d-3);
            PijMat(permind,permind,k)=[0,1,0;0,0,1;1,0,0];
            PijMat(:,:,k)=PijMat(:,:,k)*P_orig(:,:,j)';
        end
        Wij((d*i-(d-1)):(d*i), (d*j-(d-1)):(d*j))=sparse(PijMat(:,:,k));
        Wij((d*j-(d-1)):(d*j), (d*i-(d-1)):(d*i))=sparse((PijMat(:,:,k))');
    end     
        
        
end


Wij = sparse(Wij(Inds,Inds));
Wij_orig = sparse(Wij_orig(Inds,Inds));






