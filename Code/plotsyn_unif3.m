clear all;
load('./Data/data_unif2.mat');
alglist2 = ["matchEIG","spectral","cemp_ppm_mst",...
    "ppm","cemp_ppm_mst_5_5","cemp_ppm_mst_5_10",...
    "cemp_ppm_mst_20_5","cemp_ppm_mst_20_10"];
markerlist = ["'-o'","'-+'","'-*'","'-s'","'-d'","'-x'","'-p'","'-h'"];
for p_corrupt = 0.5:0.02:0.9
    for alg = 1:length(alglist2)
        evalc(['F_' alglist2{alg} '_' num2str(p_corrupt*100) ' = 2*(1-err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ') .* recall_' alglist2{alg} '_' num2str(p_corrupt*100) './ (1-err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' + recall_' alglist2{alg} '_' num2str(p_corrupt*100) ');' ]);
    end
end
figure(1);
set(gca,'LooseInset',[0,0,0,0]);
% subplot(2,1,1);set(gca,'LooseInset',[0,0,0,0]);
for p_corrupt = 0.5:0.02:0.9
    for alg = 1:length(alglist2)
        evalc(['mean_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' = [];']);
        evalc(['std_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' = [];']);
%         evalc(['mean_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' = [];']);
        evalc(['mean_num_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['std_num_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['mean_F_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
        evalc(['std_F_' alglist2{alg} '_' num2str(p_corrupt*100) ' = [];']);
    end
    for alg = 1:length(alglist2)
        evalc(['mean_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' = ' ...
            'mean(err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ');']);
        evalc(['std_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ' = ' ...
            'std(err_' alglist2{alg} '_M_' num2str(p_corrupt*100) ');']);
%         evalc(['mean_err_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
%             'mean(err_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['mean_num_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'mean(num_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['std_num_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'std(num_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['mean_recall_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'mean(recall_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['std_recall_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'std(recall_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['mean_F_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'mean(F_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
        evalc(['std_F_' alglist2{alg} '_' num2str(p_corrupt*100) ' = ' ...
            'std(F_' alglist2{alg} '_' num2str(p_corrupt*100) ');']);
    end
end



for alg = 1:length(alglist2)
    evalc(['mean_err_' alglist2{alg} '_M = [];']);
    evalc(['mean_num_' alglist2{alg} ' = [];']);
    evalc(['mean_recall_' alglist2{alg} ' = [];']);
    evalc(['mean_F_' alglist2{alg} ' = [];']);
    evalc(['std_err_' alglist2{alg} '_M = [];']);
    evalc(['std_num_' alglist2{alg} ' = [];']);
    evalc(['std_recall_' alglist2{alg} ' = [];']);
    evalc(['std_F_' alglist2{alg} ' = [];']);
%     evalc(['mean_err_' alglist2{alg} ' = [];']);
    for p_corrupt = 0.5:0.02:0.9
        evalc(['mean_err_' alglist2{alg} '_M = [mean_err_' alglist2{alg} '_M,mean_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) '];']);
        evalc(['mean_num_' alglist2{alg} ' = [mean_num_' alglist2{alg} ',mean_num_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
        evalc(['mean_recall_' alglist2{alg} ' = [mean_recall_' alglist2{alg} ',mean_recall_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
        evalc(['mean_F_' alglist2{alg} ' = [mean_F_' alglist2{alg} ',mean_F_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
        evalc(['std_err_' alglist2{alg} '_M = [std_err_' alglist2{alg} '_M,std_err_' alglist2{alg} '_M_' num2str(p_corrupt*100) '];']);
        evalc(['std_num_' alglist2{alg} ' = [std_num_' alglist2{alg} ',std_num_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
        evalc(['std_recall_' alglist2{alg} ' = [std_recall_' alglist2{alg} ',std_recall_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
        evalc(['std_F_' alglist2{alg} ' = [std_F_' alglist2{alg} ',std_recall_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
%         evalc(['mean_err_' alglist2{alg} ' = [mean_err_' alglist2{alg} ',mean_err_' alglist2{alg} '_' num2str(p_corrupt*100) '];']);
    end
    evalc(['errorbar(linspace(50,90,21),mean_err_' alglist2{alg} '_M, std_err_' alglist2{alg} '_M,' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end

ylim([0,1]);xlabel('q*100');ylabel('error');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_unif2_error.eps','epsc');

clear figure;
figure(2);
for alg = 1:length(alglist2)
    evalc(['plot(linspace(50,90,21),mean_num_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([0,1]);xlim([50,90]);xlabel('q*100');ylabel('#M');figure.outerposition=[0,0,0.95,1];
[~,objh]=legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Northeast');
objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_unif2_numM.eps','epsc');

clear figure;
figure(3);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(50,90,21),mean_recall_' alglist2{alg} ', std_recall_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([-0.3,1]);yticks([0,0.5,1]);xlim([50,90]);xlabel('q*100');ylabel('recall');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Southwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_unif2_recall.eps','epsc');

clear figure;
figure(4);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(50,90,21),1-mean_err_' alglist2{alg} '_M, std_err_' alglist2{alg} '_M,' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([0,1]);xlim([50,90]);xlabel('q*100');ylabel('precision');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Southwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_unif2_precision.eps','epsc');

clear figure;
figure(5);
for alg = 1:length(alglist2)
    evalc(['errorbar(linspace(50,90,21),mean_F_' alglist2{alg} ', std_F_' alglist2{alg} ',' markerlist{alg} ',''MarkerSize'',20,''LineWidth'',3);hold on;' ]);
end
ylim([0,1]);xlim([50,90]);xlabel('q*100');ylabel('F-score');figure.outerposition=[0,0,0.95,1];
legend("MatchEIG","spectral","MatchFAME",...
    "ppm","MatchFAME_5_5","MatchFAME_5_10","MatchFAME_20_5","MatchFAME_20_10",'Fontsize',15,'Location','Southwest');
% objhl = findobj(objh, 'type', 'Line');set(objhl, 'Markersize', 20, 'LineWidth', 3);
set(gca,'FontSize',20);
saveas(gcf,'plotsyn_unif2_F.eps','epsc');