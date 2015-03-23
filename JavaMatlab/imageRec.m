function [ pixels ] = imageRec(  )
clear ;
close all;
global data_type; 
data_type = 'double';
load('alg_params.mat');
load('Ef_avg.mat');
load('Ef_max.mat');
load('Ef_min.mat');
load('Ef_pha.mat');

rek_object=Reconstructor_2D(Ef_pha,Ef_max,Ef_min,Ef_avg);
rek_object.read_data('rawData.txt',28,3,3); 
%   rek_object.draw_real_data_from_file();
rek_object.it_recon(alg_params,'no_display'); %IMP!!!!!!!!

pixels = ans;
end

