function X = row_normalize(X)
[m,n] = size(X);
[i,j,v] = find(X);
RowSum = sum(X,2);
for k=1:length(v)
    v(k) = v(k)/RowSum(i(k));
end
X = sparse(i,j,v,m,n);
