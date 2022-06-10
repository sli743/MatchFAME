function err = img_err(A,B)
if nnz(B)==0
    err = 0;
else
    err = 1-nnz(A.*B)/nnz(B);
end