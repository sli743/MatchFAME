function correct_match = evaluate_match(xi,xj,Rij,tij,K,th)
% EVALUATE_MATCH detect if a match is correct on the basis of the Sampson 
%                distance, given ground-truth relative orientation between
%                two images
% ----- Input:
%       xi: point position in image_i
%       xj: point position in image_j
%       Rij: ground-truth relative attitude
%       tij: ground-truth relative position
%       K: matrix of internal parameters
%       th: threshold
% ----- Output:
%       correct_match: indicates if a match is correct (1) or wrong (0) 
% ----- Authors:
%       Eleonora Maset, Federica Arrigoni and Andrea Fusiello, 2017 

% skew-symmetric matrix associated to tij
tij_x = [0 -tij(3) tij(2);tij(3) 0 -tij(1);-tij(2) tij(1) 0];

% Essential matrix
Eij = tij_x*Rij;

% Fundamental matrix 
Fij = inv(K')*Eij*inv(K);

% Compute Samspon distance
d = sqrt(sampson(Fij, xj, xi));

% Establish if the points xi and xj are true/false correspondences
correct_match=(d<=th);

end
