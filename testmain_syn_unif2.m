% script for synthetic experiment on uniform corruption
clear;
diary output_main_syn_unif2_0327.log;
addpath ./utils
alglist = ["matchEIG","spectral",...
    "ppm","MatchFAME"];
for p_corrupt = 0.5:0.02:0.9
    for alg = 1:length(alglist)
        evalc(['err_bad_' alglist{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['err_' alglist{alg} '_M_' num2str(p_corrupt*100) ' = [];']);
        evalc(['num_' alglist{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['recall_' alglist{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['recall_bad_' alglist{alg} '_' num2str(p_corrupt*100) ' = [];']);
    end
    for iter_num = 1:10
        testsyn_unif2;
        for alg = 1:length(alglist)
            evalc(['err_bad_' alglist{alg} '_' num2str(p_corrupt*100) ' = [' ...
                'err_bad_' alglist{alg} '_' num2str(p_corrupt*100) ', err_bad_' ...
                alglist{alg} '];']);
            evalc(['err_' alglist{alg} '_M_' num2str(p_corrupt*100) ' = [' ...
                'err_' alglist{alg} '_M_' num2str(p_corrupt*100) ', err_' ...
                alglist{alg} '_M];']);
            evalc(['num_' alglist{alg} '_' num2str(p_corrupt*100) ' = [' ...
                 'num_' alglist{alg} '_' num2str(p_corrupt*100) ', n_matches_' ...
                 alglist{alg} '/n_matches_input];']);
             evalc(['recall_' alglist{alg} '_' num2str(p_corrupt*100) ' = [' ...
                 'recall_' alglist{alg} '_' num2str(p_corrupt*100) ', recall_' ...
                 alglist{alg} '];']);
             evalc(['recall_bad_' alglist{alg} '_' num2str(p_corrupt*100) ' = [' ...
                 'recall_bad_' alglist{alg} '_' num2str(p_corrupt*100) ', recall_bad_' ...
                 alglist{alg} '];']);
        end
    end
end
save('./Data/data_unif2.mat');
plotsyn_unif2;
diary off