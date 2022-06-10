clear;
addpath ./utils
diary output_main_syn_laclbc_0328.log;
option = 'mal2'; %'mal' for lbc, 'mal2' for lac
p_neighbor = 0.6; %0.9 for lbc, 0.6 for lac
alglist = ["matchEIG","spectral",...
    "ppm","cemp_ppm_mst_20_5"];
for n_node_corr = 1:6
    for alg = 1:length(alglist)
        evalc(['err_bad_' alglist{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['err_' alglist{alg} '_M_' num2str(n_node_corr) ' = [];']);
        evalc(['num_' alglist{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['recall_' alglist{alg} '_' num2str(n_node_corr) ' = [];']);
    end
    for iter_num = 1:20
    testsyn_laclbc_001;
    for alg = 1:length(alglist)
        evalc(['err_bad_' alglist{alg} '_' num2str(n_node_corr) ' = [' ...
            'err_bad_' alglist{alg} '_' num2str(n_node_corr) ', err_bad_' ...
            alglist{alg} '];']);
        evalc(['err_' alglist{alg} '_M_' num2str(n_node_corr) ' = [' ...
            'err_' alglist{alg} '_M_' num2str(n_node_corr) ', err_' ...
            alglist{alg} '_M];']);
        evalc(['num_' alglist{alg} '_' num2str(n_node_corr) ' = [' ...
                 'num_' alglist{alg} '_' num2str(n_node_corr) ', n_matches_' ...
                 alglist{alg} '/n_matches_input];']);
        evalc(['recall_' alglist{alg} '_' num2str(n_node_corr) ' = [' ...
                 'recall_' alglist{alg} '_' num2str(n_node_corr) ', recall_' ...
                 alglist{alg} '];']);
    end
    end
end
save('./Data/data_laclbc.mat');
diary off