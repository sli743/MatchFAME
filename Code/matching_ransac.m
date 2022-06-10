function [pairwiseEst,Z] = matching_ransac(ncams,SIFT,t_ransac,dimPerm)
% MATCHING_RANSAC performs pairwise matching and remove outliers using
%       RANSAC algorithm
% ----- Input:
%       ncams: number of images
%       SIFT: cell array containing SIFT descriptors and locations
%       t_ransac: RANSAC threshold
%       dimPerm: size of each permutation
% ----- Output:
%       pairwiseEst: cell array containing the indices of pairwise matches
%       Z: permutation matrix representing pairwise matches
% ----- Authors:
%       Eleonora Maset, Federica Arrigoni and Andrea Fusiello, 2017 

pairwiseEst = cell(ncams,ncams);
% pairwiseEst{i,j} contains the indices of the matches between image i and j
Z = sparse(sum(dimPerm));
% Z contains relative permutations
cumDim = [0;cumsum(dimPerm(1:end-1))];

for i = 1:ncams;
    Zii = speye(dimPerm(i));
    Z(1+cumDim(i):cumDim(i)+dimPerm(i),1+cumDim(i):cumDim(i)+dimPerm(i)) = Zii;
  
    for j = i+1:ncams;
        % Consider the pair (i,j)
        fprintf('\nPair of images %d %d\n',i,j) ;
        tic;
        % Match the pair (i,j)
        [index,scores] = vl_ubcmatch(SIFT{i}.desc,SIFT{j}.desc,1.5); 
        fprintf('Matched in %.3f s\n', toc) ;
        
        % ind1 and ind2 encode the matches between image_i and image_j
        ind1 = index(1,:);
        ind2 = index(2,:);
        
        % xi,xj are the matching points for the pair (i,j)
        xi = [SIFT{i}.locs(ind1,1)';SIFT{i}.locs(ind1,2)'];
        xj = [SIFT{j}.locs(ind2,1)';SIFT{j}.locs(ind2,2)'];
                
        fprintf('Number of matches: %d \n', length(ind1)) ;
        if size(index,2) >= 8 
            % the 8-point algorithm is used to compute fundamental matrix
            tic
            % Compute the fundamental matrix in a RANSAC scheme
            [~,inliers] = ransacfitfundmatrix(xi,xj,t_ransac);
            fprintf('Number of inliers: %d \n', length(inliers)) ;
            fprintf('RANSAC run in %.3f s\n',toc);
            
            % Keep only inlier correspondences
            ind1 = ind1(inliers);
            ind2 = ind2(inliers);
        end
        
        pairwiseEst{i,j}.ind1 = ind1;
        pairwiseEst{i,j}.ind2 = ind2;
        Zij = sparse(ind1,ind2,1,dimPerm(i),dimPerm(j));
        Z(1+cumDim(i):cumDim(i)+dimPerm(i),1+cumDim(j):cumDim(j)+dimPerm(j)) = Zij;
        Z(1+cumDim(j):cumDim(j)+dimPerm(j),1+cumDim(i):cumDim(i)+dimPerm(i)) = Zij';
    
    end
end

end