% clear;
% load('./Data/data_laclbc.mat');
alglist2 = ["matchEIG","spectral","MatchFAME",...
    "ppm"];
markerlist = ["'-o'","'-+'","'-*'","'-s'","'-d'","'-x'"];
figure(1);
set(gca,'LooseInset',[0,0,0,0]);
% subplot(2,1,1);set(gca,'LooseInset',[0,0,0,0]);

for n_node_corr = 1:6
    for alg = 1:length(alglist2)
        evalc(['mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = [];']);
    end
    for alg = 1:length(alglist2)
        evalc(['mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'nanmean(err_bad_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'nanstd(err_bad_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'nanmean(recall_' alglist2{alg} '_' num2str(n_node_corr) ');']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(n_node_corr) ' = ' ...
            'nanstd(recall_' alglist2{alg} '_' num2str(n_node_corr) ');']);
    end
end

for alg = 1:length(alglist2)
    evalc(['mean_err_bad_' alglist2{alg} ' = [];']);
    evalc(['mean_recall_' alglist2{alg} ' = [];']);
    evalc(['std_err_bad_' alglist2{alg} ' = [];']);
    evalc(['std_recall_' alglist2{alg} ' = [];']);
    for n_node_corr = 1:6
        evalc(['mean_err_bad_' alglist2{alg} ' = [mean_err_bad_' alglist2{alg} ',mean_err_bad_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['mean_recall_' alglist2{alg} ' = [mean_recall_' alglist2{alg} ',mean_recall_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_err_bad_' alglist2{alg} ' = [std_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} '_' num2str(n_node_corr) '];']);
        evalc(['std_recall_' alglist2{alg} ' = [std_recall_' alglist2{alg} ',std_recall_' alglist2{alg} '_' num2str(n_node_corr) '];']);
    end
    evalc(['errorbar(linspace(1,6,6),mean_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end


clear figure;
figure(1);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(1,6,6),1-mean_err_bad_' alglist2{alg} ',std_err_bad_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([-0.2,2.2]);yticks([0,1]);xlim([1,6]);xlabel('n_c');ylabel('precision');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "PPM",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_precision_2.eps','epsc');

clear figure;
figure(2);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(1,6,6),mean_recall_' alglist2{alg} ',std_recall_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([-0.2,2.2]);yticks([0,0.5,1]);xlim([1,6]);xlabel('n_c');ylabel('recall');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "PPM",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_laclbc_recall_2.eps','epsc');

