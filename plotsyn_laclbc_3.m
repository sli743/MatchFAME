clear all;
load('./Data/data_laclbc.mat');
alglist2 = ["matchEIG","spectral","cemp_ppm_mst",...
    "ppm","cemp_ppm_mst_5_5","cemp_ppm_mst_5_10",...
    "cemp_ppm_mst_20_5","cemp_ppm_mst_20_10"];
markerlist = ["'-o'","'-+'","'-*'","'-s'","'-d'","'-x'","'-p'","'-h'"];
figure(1);
set(gca,'LooseInset',[0,0,0,0]);
% subplot(2,1,1);set(gca,'LooseInset',[0,0,0,0]);
for n_node_corr = 1:6
    for alg = 1:length(alglist2)
        evalc(['F_' alglist2{alg} '_' num2str(n_node_corr) ' = 2*(1-err_bad_' alglist2{alg} '_' num2str(n_node_corr) ') .* recall_' alglist2{alg} '_' num2str(n_node_corr) './ (1-err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' + recall_' alglist2{alg} '_' num2str(n_node_corr) ');' ]);
    end
end

for n_node_corr = 1:6
    for alg = 1:length(alglist2)
        evalc(['mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
%         evalc(['mean_err_' alglist2{alg} '_M_' num2str(n_node_corr) ' = [];']);
        evalc(['mean_num_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_num_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['mean_F_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_F_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
    end
    for alg = 1:length(alglist2)
        evalc(['mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'mean(err_bad_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'std(err_bad_' alglist2{alg} '_' num2str(n_node_corr) ');']);
%         evalc(['mean_err_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
%             'mean(err_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['mean_num_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'mean(num_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_num_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'std(num_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'mean(recall_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'std(recall_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['mean_F_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'mean(F_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_F_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'std(F_' alglist2{alg} '_' num2str(n_node_corr) ');']);
    end
end

for alg = 1:length(alglist2)
    evalc(['mean_err_bad_' alglist2{alg} ' = [];']);
    evalc(['mean_num_' alglist2{alg} ' = [];']);
    evalc(['mean_recall_' alglist2{alg} ' = [];']);
    evalc(['mean_F_' alglist2{alg} ' = [];']);
    evalc(['std_err_bad_' alglist2{alg} ' = [];']);
    evalc(['std_num_' alglist2{alg} ' = [];']);
    evalc(['std_recall_' alglist2{alg} ' = [];']);
    evalc(['std_F_' alglist2{alg} ' = [];']);
%     evalc(['mean_err_' alglist2{alg} ' = [];']);
    for n_node_corr = 1:6
        evalc(['mean_err_bad_' alglist2{alg} ' = [mean_err_bad_' alglist2{alg} ',mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['mean_num_' alglist2{alg} ' = [mean_num_' alglist2{alg} ',mean_num_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['mean_recall_' alglist2{alg} ' = [mean_recall_' alglist2{alg} ',mean_recall_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['mean_F_' alglist2{alg} ' = [mean_F_' alglist2{alg} ',mean_F_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_err_bad_' alglist2{alg} ' = [std_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_num_' alglist2{alg} ' = [std_num_' alglist2{alg} ',std_num_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_recall_' alglist2{alg} ' = [std_recall_' alglist2{alg} ',std_recall_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_F_' alglist2{alg} ' = [std_F_' alglist2{alg} ',std_F_' alglist2{alg} '_' num2str(n_node_corr) '];']);
%         evalc(['mean_err_' alglist2{alg} ' = [mean_err_' alglist2{alg} ',mean_err_' alglist2{alg} '_' num2str(n_node_corr) '];']);
    end
    evalc(['errorbar(linspace(1,6,6),mean_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([-0.3,2.5]);yticks([0,0.5,1]);xlabel('n_c');ylabel('error');figure.outerposition=[0,0,0.95,1];
% [~,objh]=...
    lgd = legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 15, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_error_2.eps','epsc');

clear figure;
figure(2);
for alg = 1:length(alglist2)
    evalc(['plot(linspace(1,6,6),100*mean_num_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([0,100]);xlim([1,6]);xlabel('n_c');ylabel('#M');figure.outerposition=[0,0,0.95,1];
[~,objh]=legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Southwest');
objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);

saveas(gcf,'plotsyn_laclbc_numM_2.eps','epsc');

clear figure;
figure(3);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(1,6,6),1-mean_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([-0.2,2.2]);yticks([0,1]);xlim([1,6]);xlabel('n_c');ylabel('precision');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_precision_2.eps','epsc');

clear figure;
figure(4);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(1,6,6),mean_recall_' alglist2{alg} ',std_recall_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([-0.2,2.2]);yticks([0,0.5,1]);xlim([1,6]);xlabel('n_c');ylabel('recall');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_recall_2.eps','epsc');

clear figure;
figure(5);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(1,6,6),mean_F_' alglist2{alg} ', std_F_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([0,2]);yticks([0,0.5,1]);xlim([1,6]);xlabel('n_c');ylabel('F-score');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_F_2.eps','epsc');