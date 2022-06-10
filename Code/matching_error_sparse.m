function [err,recall] = matching_error_sparse(ncams,dimPerm,Z_input, Z_est,SIFT,R_true,t_true,K,th)
% MATCHING_ERROR_GLOBAL detect correct/wrong matches given 
% ground-truth cameras
% ----- Input:
%       ncams: number of images
%       dimPerm: size of each permutation
%       Z: pairwise permutation matrix
%       SIFT: cell array containing SIFT descriptors and locations
%       R_true, t_true, K: ground-truth cameras
%       th: threshold
% ----- Output:
%       err: fraction of mismatches (1-precision)
%       correct_matches: cell array indicating if a match is correct (1) or wrong (0) 
%       n_matches: total number of matches
% ----- Authors:
%       Eleonora Maset, Federica Arrigoni and Andrea Fusiello, 2017 

correct_matches = cell(ncams,ncams);
n_g = 0; % number of mismatches
cumDim = [0;cumsum(dimPerm(1:end-1))];
Z = Z_input;
for i = 1:ncams
    for j = i+1:ncams
        
        Zij = Z(1+cumDim(i):cumDim(i)+dimPerm(i),1+cumDim(j):cumDim(j)+dimPerm(j));
        % ind1 and ind2 encode the matches between image_i and image_j
        [ind1,ind2] = find(Zij);
        
        % xi,xj are the matching points for the pair (i,j)
        Xi = [SIFT{i}.locs(ind1,1)';SIFT{i}.locs(ind1,2)'];
        Xj = [SIFT{j}.locs(ind2,1)';SIFT{j}.locs(ind2,2)'];
        
        % ground-truth relative rotation/translation
        Rij = R_true(:,:,i)*R_true(:,:,j)';
        tij = -R_true(:,:,i)*R_true(:,:,j)'*t_true(:,j)+t_true(:,i);
        
        % detect correct/wrong matches base on the Samspon error
        correct_matches{i,j} = evaluate_match(Xi,Xj,Rij,tij,K,th);
        
        % Number of mismatches
        n_g = n_g + nnz( (correct_matches{i,j}) );
        % Total number of matches
        %n_matches = n_matches + length(correct_matches{i,j});
        
    end
end

Z = Z_input.*Z_est;
n_g_est = 0;
n_est = 0;
for i = 1:ncams
    for j = i+1:ncams
        
        Zij = Z(1+cumDim(i):cumDim(i)+dimPerm(i),1+cumDim(j):cumDim(j)+dimPerm(j));
        % ind1 and ind2 encode the matches between image_i and image_j
        [ind1,ind2] = find(Zij);
        
        % xi,xj are the matching points for the pair (i,j)
        Xi = [SIFT{i}.locs(ind1,1)';SIFT{i}.locs(ind1,2)'];
        Xj = [SIFT{j}.locs(ind2,1)';SIFT{j}.locs(ind2,2)'];
        
        % ground-truth relative rotation/translation
        Rij = R_true(:,:,i)*R_true(:,:,j)';
        tij = -R_true(:,:,i)*R_true(:,:,j)'*t_true(:,j)+t_true(:,i);
        
        % detect correct/wrong matches base on the Samspon error
        correct_matches{i,j} = evaluate_match(Xi,Xj,Rij,tij,K,th);
        
        % Number of mismatches
        n_g_est = n_g_est + nnz( (correct_matches{i,j}) );
        % Total number of matches
        n_est = n_est + length(correct_matches{i,j});
        
    end
end

err = 1-n_g_est/(n_g+n_est-n_g_est); % fraction of mismatches
recall = n_g_est/n_g;

end