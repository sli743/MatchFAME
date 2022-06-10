n=100;
n_pt = 20;
p=0.5;  % prob of connection


rng(1);
%%%%%%%%% two probabilities of corruption:
% q0=0.01;
q1=0; % keypoint match corruption (elementwise)
p_select = 0.8; % probability of a keypoint included in an image
% p_neighbor = 0.9; % probability of neighborhood corruption for a corrupted image
% option = 'mal';
% n_node_corr = 10; % number of corrupted images
% q2=0.75; % partial perm corruption (the entire matrix)
[Z, Z_gt, mat_size, AdjMat, GoodEdge] = local_advers_gen(n,n_pt,n_node_corr,p,p_select,p_neighbor,option);
i=0;
while graphconncomp(AdjMat)~=1
    [Z, Z_gt, mat_size, AdjMat, GoodEdge] = local_advers_gen(n,n_pt,n_node_corr,p,p_select,p_neighbor,option);
    i = i+1;
    if i>=100
        error('Cannot generate data with connected adjacency matrix.\n');
    end
end
dimPerm = mat_size';ncams = n;cumIndex = cumsum([0;dimPerm])';[row_bad,col_bad]=find(GoodEdge == -1);
d = round(mean(dimPerm));
%% Find Bad Blocks

Z_bad = zeros(size(Z));
[Ind_i,Ind_j] = find(GoodEdge);
for l = 1:length(Ind_i)
    i = Ind_i(l);j = Ind_j(l);
    if GoodEdge(i,j)==-1
        Z_bad(cumIndex(i)+1:cumIndex(i+1),cumIndex(j)+1:cumIndex(j+1)) = ones(mat_size(i),mat_size(j));
    end
end
Z_bad = sparse(Z_bad);


%% Evaluate Input error
n_matches_input = nnz(Z);
n_matches_input_M = nnz(Z.*Z_gt);
err_input = norm(Z-Z_gt,'F')^2/norm(Z_gt,'F')^2;
fprintf('\n Error (Input) = %.2f %%\n', err_input*100) ;
err_input_M = norm(Z.*Z_gt-Z,'F')^2/norm(Z_gt,'F')^2;
num_input = n_matches_input;
n_matches_gt = nnz(Z_gt);
fprintf('\nPrecision (Input pr) = %.2f %%\nNumber of matches (Input) = %.2f\n', 100-err_input_M*100,n_matches_input) ;

%% Multi-view Matching (MATCHEIG)

% set the threshold requested by MatchEIG
thresh_matchEIG = 0.25;  % 0.5 for real datasets

tic
Z_matchEIG = MatchEIG(Z,2*d,ncams,dimPerm,thresh_matchEIG);
time_matchEIG = toc;

% evaluate error
n_matches_matchEIG = nnz(Z_matchEIG.*Z);
n_matches_matchEIG_M = nnz(Z_matchEIG.*Z_gt);
% err_matchEIG = norm(Z_matchEIG.*Zv-Zv,'F')^2/norm(Zv,'F')^2;
err_matchEIG_M = norm(Z_matchEIG.*Z.*Z_gt-Z_matchEIG.*Z,'F')^2/norm(Z_matchEIG.*Z,'F')^2;
num_matchEIG = n_matches_matchEIG_M/n_matches_gt;

fprintf('\nPrecision (MatchEIG pr) = %.2f %%\nNumber of matches (MatchEIG) = %.2f\nMatchEIG run in %.0f sec\n',...
    100-err_matchEIG_M*100,n_matches_matchEIG/n_matches_input,time_matchEIG);


%% Multi-view Matching (SPECTRAL)

tic
[Z_spectral,A_spectral] = mmatch_spectral(Z,dimPerm',2*d);
time_spectral = toc;

% evaluate error
n_matches_spectral = nnz(Z_spectral.*Z);
n_matches_spectral_M = nnz(Z_spectral.*Z_gt);
% err_spectral = norm(Z_spectral.*Zv-Zv,'F')^2/norm(Zv,'F')^2;
err_spectral_M = norm(Z_spectral.*Z_gt.*Z-Z_spectral.*Z,'F')^2/norm(Z_spectral.*Z,'F')^2;

num_spectral = n_matches_spectral_M/n_matches_gt;

fprintf('\nPrecision (Spectral pr) = %.2f %%\nNumber of matches (Spectral) = %.2f\nSpectral run in %.0f sec\n', 100-err_spectral_M*100,n_matches_spectral/n_matches_input,time_spectral);





%% spectral init PPM
cumIndex = cumsum([0;dimPerm])';


tic;
% S0 = CEMP_partial(Z, Z, dimPerm', length(dimPerm), 1000, ones(size(dimPerm,1),size(dimPerm,1)));

[Z_ppm,P_ppm] = mmatch_spectral(Z,dimPerm',2*d);
Z_ppm = sparse(Z);

for t=1:60
    P_ppm = Z_ppm*P_ppm;
    for i=1:ncams
        P_ppm(cumIndex(i)+1:cumIndex(i+1),:) = matrix2permutation(P_ppm(cumIndex(i)+1:cumIndex(i+1),:));
    end
end
time_ppm = toc;
Z_ppm = P_ppm*P_ppm';

n_matches_ppm = nnz(Z_ppm.*Z);
n_matches_ppm_M = nnz(Z_ppm.*Z_gt);
% err_ppm = norm(Z_ppm.*Zv-Zv,'F')^2/norm(Zv,'F')^2;
err_ppm_M = norm(Z_ppm.*Z_gt.*Z-Z_ppm.*Z,'F')^2/norm(Z_ppm.*Z,'F')^2;

num_ppm = n_matches_ppm_M/n_matches_gt;

fprintf('\nPrecision (ppm pr) = %.2f %%\nNumber of matches (ppm) = %.2f\nppm run in %.0f sec\n', 100-err_ppm_M*100,n_matches_ppm/n_matches_input,time_ppm);


%% MatchFAME


tic;

gamma = 20;
eps = 1e-2;
P_MatchFAME = MatchFAME(Z,dimPerm,AdjMat,2*d,gamma,eps);

time_MatchFAME = toc;
Z_MatchFAME = P_MatchFAME*P_MatchFAME';

n_MatchFAME = nnz(Z_MatchFAME.*Z);
n_MatchFAME_M = nnz(Z_MatchFAME.*Z_gt);
% err_cemp_ppm_mst_20_5 = norm(Z_cemp_ppm_mst_20_5.*Zv-Zv,'F')^2/norm(Zv,'F')^2;
err_MatchFAME_M = norm(Z_MatchFAME.*Z.*Z_gt-Z_MatchFAME.*Z,'F')^2/norm(Z_MatchFAME.*Z,'F')^2;

num_MatchFAME = n_MatchFAME_M/n_matches_gt;

% fprintf('\nPrecision (cemp_ppm_mst_20_5) = %.2f %%\ncemp_ppm_mst_20_5 run in %.0f sec\n', err_cemp_ppm_mst_20_5*100, time_cemp_ppm_mst_20_5);

fprintf('\nPrecision (MatchFAME pr) = %.2f %%\nNumber of matches (cemp_ppm_mst_20_5) = %.2f\nMatchFAME run in %.0f sec\n', 100-err_MatchFAME_M*100,n_MatchFAME/n_matches_input,time_MatchFAME);


alglist = ["matchEIG","spectral",...
    "ppm","MatchFAME"];
for alg = 1:length(alglist)
    evalc(['recall_' alglist{alg} ' = 1-norm(Z.*Z_gt.*Z_' alglist{alg} ' - Z.*Z_gt,''F'')^2/norm(Z.*Z_gt,''F'')^2 ;']);
    evalc(['recall_bad_' alglist{alg} ' = 1-norm(Z_bad.*Z.*Z_gt.*Z_' alglist{alg} ' - Z_bad.*Z.*Z_gt,''F'')^2/norm(Z_bad.*Z.*Z_gt,''F'')^2 ;']);
    evalc(['err_bad_' alglist{alg} ' = img_err(Z_bad.*Z_gt' ', Z_bad.*Z_' alglist{alg} ');']);
end

