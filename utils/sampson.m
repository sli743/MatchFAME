function  d = sampson(F, m1, m2)
% SAMPSON compute Sampson error.  Evaluate the first order approximation 
%         of the fit of F  with respect to a set of matched points m1, m2.
% ----- Input:
%       F: fundamental matrix
%       m1, m2: positions of matched points
% ----- Output:
%       d: approximation of the **squared** distance from the 4d joint-space 
%          point [m1;m2] to the F manifold. 
% ----- Authors:
%       Eleonora Maset, Federica Arrigoni and Andrea Fusiello, 2017 

if size(m1,1) < 3
    m1 = [m1;ones(1,size(m1,2))];
    m2 = [m2;ones(1,size(m2,2))];
end

lng = size(m1,2);

m2tFm1 = zeros(1,lng);
for n = 1:lng
    m2tFm1(n) = m2(:,n)'*F*m1(:,n);
end

Fm1 = F*m1;
Ftm2 = F'*m2;

% Evaluate squared distances
d =  m2tFm1.^2 ./ (Fm1(1,:).^2 + Fm1(2,:).^2 + Ftm2(1,:).^2 + Ftm2(2,:).^2);


