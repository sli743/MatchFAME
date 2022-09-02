% script for experiment on EPFL
clear;
addpath ./utils
DataName = {};
DataName{1} = 'castle19';
DataName{2} = 'castle30';
DataName{3} = 'entry10';
DataName{4} = 'fountain11';
DataName{5} = 'herz8';
DataName{6} = 'herz25';
diary output_main_0325_2.log
for id = 5:5
    test_real_data;
    save(['./Data/data_' datasetname '_small_4.mat']);
    close all
end
diary off