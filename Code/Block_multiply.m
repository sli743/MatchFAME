function X = Block_multiply(X,cumIndex,S)
[m,n] = size(X);
[i,j,v] = find(X);
IndMap = zeros(1,n);
for k=1:length(cumIndex)-1
    IndMap(cumIndex(k)+1:cumIndex(k+1))=k;
end
for k=1:length(v)
    v(k) = v(k)*S(IndMap(i(k)),IndMap(j(k)));
end
X = sparse(i,j,v,m,n);