function W = Block_add(W,cumIndex,i,j,Y)
[x,y,v] = find(W);
[x0,y0,v0] = find(Y);
for k=1:length(v0)
    x = [x;cumIndex(i)+x0(k)];
    y = [y;cumIndex(j)+y0(k)];
    v = [v;v0(k)];
end
W = sparse(x,y,v,size(W,1),size(W,2));