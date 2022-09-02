function [err,correct_matches,n_matches] = matching_error_homography(ncams,dimPerm,Z,SIFT,H,th)
% MATCHING_ERROR_HOMOGRAPHY detect correct/wrong matches given 
% ground-truth homographies
% ----- Input:
%       ncams: number of images
%       dimPerm: size of each permutation
%       Z: pairwise permutation matrix
%       SIFT: cell array containing SIFT descriptors and locations
%       H: ground-truth homographies
%       th: threshold
% ----- Output:
%       err: fraction of mismatches (1-precision)
%       correct_matches: cell array indicating if a match is correct (1) or wrong (0) 
%       n_matches: total number of matches
% ----- Authors:
%       Eleonora Maset, Federica Arrigoni and Andrea Fusiello, 2017 

correct_matches = cell(1,ncams-1);
err = 0; % number of mismatches
n_matches = 0; % total number of matches
cumDim = [0;cumsum(dimPerm(1:end-1))];

i = 1;
% ground-truth homographies describe the transformation between image 1 and
% the other images
for j = i+1:ncams
    
    Zij = Z(1+cumDim(i):cumDim(i)+dimPerm(i),1+cumDim(j):cumDim(j)+dimPerm(j));
    % ind1 and ind2 encode the matches between image_i and image_j
    [ind1,ind2] = find(Zij);
       
    % xi,xj are the matching points for the pair (i,j)
    Xi = [SIFT{i}.locs(ind1,1)';SIFT{i}.locs(ind1,2)';ones(1,length(ind1))];
    Xj = [SIFT{j}.locs(ind2,1)';SIFT{j}.locs(ind2,2)';ones(1,length(ind2))];
    
    % Compute ground-truth correspondence
    Yi = H(:,:,j-1)*Xi;
    Yi(1,:) = Yi(1,:)./Yi(3,:);
    Yi(2,:) = Yi(2,:)./Yi(3,:);
    
    % Detect correct/wrong matches 
    correct_matches{j-1} = sqrt(sum((Yi-Xj).^2,1))<=th;
    
    % Number of mismatches
    err = err + nnz( not(correct_matches{j-1}) );
    % Total number of matches
    n_matches = n_matches + length(correct_matches{j-1});
    
end

err = err/n_matches; % fraction of mismatches

end