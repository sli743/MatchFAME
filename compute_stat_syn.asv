function s = compute_stat_syn(XMat, mat_size, n, n_iter,n_blk,step_size, use2, use3, use4, rounding)

    X = XMat;

    Xind = [0,cumsum(mat_size)];
    N = length(X);


    IndX = find(X>0);
    [IndX_i,IndX_j] = ind2sub(size(X),IndX);
    m = length(IndX_i);

   % n_blk = 100;
    blk_size_end = mod(m,n_blk-1);
    if blk_size_end == 0
        n_blk = n_blk-1;
        blk_size = (m-blk_size_end)/n_blk;
        blk_size_vec = blk_size*ones(1,n_blk);
    else    

        blk_size = (m-blk_size_end)/(n_blk-1);
        blk_size_vec = [blk_size*ones(1,n_blk-1), blk_size_end];
        
    end

    blk_ind = [0,cumsum(blk_size_vec)];


    for t=1:n_iter

        

        if use2 == 1

            X2 = X*X;
            s2_vec_long = zeros(m,1);
            for blk = 1:n_blk
                
                ind_range = (blk_ind(blk)+1):blk_ind(blk+1);

                X2i = X2(:,IndX_i(ind_range));
                X2i_t = X2i';    
                clear X2i;

                X2j = X2(:,IndX_j(ind_range));       
                X2j_t = X2j';
                clear X2j;

                X2ij = X2i_t.*X2j_t;
                X4_vec = sum(X2ij,2);


                s2_vec = zeros(blk_size_vec(blk),1);

                for k = 1:n
                    X2i_blk = X2i_t(:,(Xind(k)+1): Xind(k+1));
                    X2j_blk = X2j_t(:,(Xind(k)+1): Xind(k+1));
                    s2_vec = s2_vec + sum(X2i_blk,2).*sum(X2j_blk,2);
                end

                s2_vec = X4_vec./(s2_vec+1e-4);

                clear X2i_t;
                clear X2j_t;

                s2_vec_long(ind_range) = s2_vec;
            end
            clear X2;


        end




        if use3 == 1

            X3 = X^3;

            s3_vec_long = zeros(m,1);
            for blk = 1:n_blk
                blk
                ind_range = (blk_ind(blk)+1):blk_ind(blk+1);
                X3i = X3(:,IndX_i(ind_range));
                X3i_t = X3i';    
                clear X3i;
                X3j = X3(:,IndX_j(ind_range));
                X3j_t = X3j';
                clear X3j;
                X3ij = X3i_t.*X3j_t;
                X6_vec = sum(X3ij,2);

                s3_vec = zeros(blk_size_vec(blk),1);
                for k = 1:n
                    X3i_blk = X3i_t(:,(Xind(k)+1): Xind(k+1));
                    X3j_blk = X3j_t(:,(Xind(k)+1): Xind(k+1));
                    s3_vec = s3_vec + sum(X3i_blk,2).*sum(X3j_blk,2);
                end

                 s3_vec = X6_vec./(s3_vec+1e-4);
                 clear X3i_t;
                 clear X3j_t;

                s3_vec_long(ind_range) = s3_vec;

            end

            clear X3;

        end




        if use4 == 1

            X4 = X^4;

            s4_vec_long = zeros(m,1);
            for blk = 1:n_blk
                blk
                ind_range = (blk_ind(blk)+1):blk_ind(blk+1);
                X4i = X4(:,IndX_i(ind_range));
                X4i_t = X4i';    
                clear X4i;
                X4j = X4(:,IndX_j(ind_range));
                X4j_t = X4j';
                clear X4j;
                X4ij = X4i_t.*X4j_t;
                X8_vec = sum(X4ij,2);

                s4_vec = zeros(blk_size_vec(blk),1);

                for k = 1:n
                    X4i_blk = X4i_t(:,(Xind(k)+1): Xind(k+1));
                    X4j_blk = X4j_t(:,(Xind(k)+1): Xind(k+1));
                    s4_vec = s4_vec + sum(X4i_blk,2).*sum(X4j_blk,2);
                end
                 s4_vec = X8_vec./(s4_vec+1e-4);
                 clear X4i_t;
                 clear X4j_t;

                 s4_vec_long(ind_range) = s4_vec;
            end
            clear X4;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% chose your statistics


        if use2==1 && use3==0 && use4==0
            s_vec = s2_vec_long;
        end

        if use2==0 && use3==1 && use4==0
            s_vec = s3_vec_long;
        end

        if use2==0 && use3==0 && use4==1
            s_vec = s4_vec_long;
        end

        if use2==1 && use3==1 && use4==0
            s_vec = max(s2_vec_long, s3_vec_long);
        end
        if use2==1 && use3==1 && use4==1
            s_vec = max(s2_vec_long, max(s3_vec_long, s4_vec_long));
        end
        %s_vec = mean([s2_vec, s3_vec, s4_vec],2);
        s = sparse(IndX_i, IndX_j, s_vec, N,N);
       
        X=s;
        
        if rounding ==1
        X=(s>step_size*t);
        end
        
    end


    
end