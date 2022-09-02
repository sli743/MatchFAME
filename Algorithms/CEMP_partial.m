function [S] = CEMP_partial(X, keypts_num, m, AdjMat)
index_list = cumsum([0,keypts_num]);
S = zeros(m,m);
W = zeros(m,m,m);
D = zeros(m,m,m);
% Iteratively update sij and wijk
for i=1:m
    Adjlist{i} = find(AdjMat(:,i))';
end
for i=1:m
    for j=1:m
        Adjlistij{i,j} = intersect(Adjlist{i},Adjlist{j});
    end
end
for i = 1:m
    W(i,:,:) = (ones(m,m)-eye(m))/(m-2);
    W(i,i,:) = zeros(1,1,m);
    W(i,:,i) = zeros(1,m,1);
    for j = Adjlist{i}(Adjlist{i}>i)
        uij = Adjlistij{i,j};
        for k = uij(uij>j)
            Xij = X(index_list(i)+1:index_list(i+1), index_list(j)+1:index_list(j+1));
            Xjk = X(index_list(j)+1:index_list(j+1), index_list(k)+1:index_list(k+1));
            Xki = X(index_list(k)+1:index_list(k+1), index_list(i)+1:index_list(i+1));          
            ri = sum(Xki,1)*sum(Xij,2);
            rj = sum(Xij,1)*sum(Xjk,2);
            rk = sum(Xjk,1)*sum(Xki,2);
            ng = sum(diag(Xij*Xjk*Xki));
            rijk = ri+rj+rk;
            if rijk<=0
                D(i,j,k) = nan;
            else
                D(i,j,k) = 1-3*ng/rijk;
            end
            D(i,k,j) = D(i,j,k);
            D(j,k,i) = D(i,j,k);
            D(j,i,k) = D(i,j,k);
            D(k,i,j) = D(i,j,k);
            D(k,j,i) = D(i,j,k);
        end
    end
end
W = W.*(~isnan(D));
beta_rate = 1.2; beta_max = 40; beta = 1; tmax = 25;
for t = 1:tmax
    for i = 1:m
        for j = Adjlist{i}(Adjlist{i}>i)
            S(i,j) = sum(W(i,j,Adjlistij{i,j}).*D(i,j,Adjlistij{i,j}),'omitnan')/sum(W(i,j,Adjlistij{i,j}));
        end
        for j = Adjlist{i}(Adjlist{i}<i)
            S(i,j) = S(j,i);
        end
    end
    for i = 1:m
        for j = Adjlist{i}(Adjlist{i}>i)
            for k = Adjlistij{i,j}
                
                W(i,j,k) = exp(-beta*(S(i,k)+S(k,j)));
                
            end
            if sum(W(i,j,:))>1e-12 
                W(i,j,:) = W(i,j,:)/sum(W(i,j,:));
            end
        end
        for j = Adjlist{i}(Adjlist{i}<i)
            W(i,j,:) = W(j,i,:);
        end
    end
    beta = beta*beta_rate;
    beta = min(beta, beta_max);
end

