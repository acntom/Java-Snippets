clear;
close all;
global data_type; 
data_type = 'double';

tic

% Sensor elements
fov_thick  = 24;    %[mm]
ins1_thick = 0;     %[mm]
electrode_thick =1; %[mm]
ins3_thick  =1;     %[mm]
screen_thick=1;     %[mm]
matrix_size= 60;    %[mm]
grid_size  = 1;     %[mm]
rekonstruction_mtx_pix_size=64;

ins1_min_r=fov_thick;

% sensor
number_of_electrodes=8;
ratio_electrode_to_insulator=2;
start_ins2_angle=7.5;


%algorythm
alg_params.method='LBP_LM';
alg_params.numiter=20;% maximum iteration number
alg_params.stop_delta=1e-20; % also control iteration number
alg_params.update_method='modulo';
alg_params.iter_mod=50;
alg_params.update_delta=0;
alg_params.alpha=0.1;
alg_params.alpha_=0.1; %alpha_=alpha;
alg_params.alphalimit='noadapt';
alg_params.regular='L-curve';
alg_params.u=0.1;


% alg_params_LBP.method='LBP';
% alg_params_LBP.numiter=1;
% alg_params_LBP.stop_delta=0;
% alg_params_LBP.update_method='modulo';
% alg_params_LBP.iter_mod=0;
% alg_params_LBP.update_delta=0;
% alg_params_LBP.alpha=0;
% alg_params_LBP.alpha_=0; %alpha_=alpha;
% alg_params_LBP.alphalimit='noadapt';
% alg_params_LBP.regular='manual';
% alg_params_LBP.u=0;


% alg_params_LM.method='LM';
% alg_params_LM.numiter=220;
% alg_params_LM.stop_delta=1e-10;
% alg_params_LM.update_method='modulo';
% alg_params_LM.iter_mod=55;
% alg_params_LM.update_delta=0.1;
% alg_params_LM.alpha=0.1;
% alg_params_LM.alpha_=0.1; 
% alg_params_LM.alphalimit='noadapt';
% alg_params_LM.regular='L-curve';
% alg_params_LM.u=0.1;

% Discretization Grid

dg=Discretization_grid_2D_square(matrix_size,grid_size);

% Field of view
fov=Sensor_element_circular(0,360,0,fov_thick,dg,'none',1,'fov');

% Electrode & Insulator between electrodes
electrode_min_r=ins1_min_r+ins1_thick;

% Memory allocation
Electrodes_vector=repmat(Sensor_element_circular,1,number_of_electrodes);



electrode_angle=360/(number_of_electrodes*(1+(1/ratio_electrode_to_insulator)));
insulator2_angle=360/(number_of_electrodes*(1+ratio_electrode_to_insulator));

for p=1:1:number_of_electrodes;

    Electrodes_vector(p)=...
        Sensor_element_circular(...
        start_ins2_angle+(p)*insulator2_angle+(p-1)*electrode_angle,...
        start_ins2_angle+(p)*insulator2_angle+(p)*electrode_angle,...
        electrode_min_r,electrode_min_r+electrode_thick,dg,12,10000,'electrode');
end

% Sensor
% Last element is on top

s=Sensor_2D(dg);
s.add_element(fov);

number_of_electrodes=numel(Electrodes_vector);
for i=1:number_of_electrodes
        s.add_element(Electrodes_vector(i));
end

phantom_gen=Phantom_generator_2D(fov,'uniform',2);
pd=Permittivity_distribution_2D(fov);
pd.add_Element(phantom_gen);
Ef_pha=Electrical_field_2D(s,pd,rekonstruction_mtx_pix_size);

phantom_max=Phantom_generator_2D(fov,'uniform',3);     
pd_max=Permittivity_distribution_2D(fov);
pd_max.add_Element(phantom_max);
Ef_max=Electrical_field_2D(s,pd_max,rekonstruction_mtx_pix_size);


phantom_min=Phantom_generator_2D(fov,'uniform',1);     
pd_min=Permittivity_distribution_2D(fov);
pd_min.add_Element(phantom_min);
Ef_min=Electrical_field_2D(s,pd_min,rekonstruction_mtx_pix_size);


phantom_avg=Phantom_generator_2D(fov,'uniform',2);     
pd_avg=Permittivity_distribution_2D(fov);
pd_avg.add_Element(phantom_avg);
Ef_avg=Electrical_field_2D(s,pd_avg,rekonstruction_mtx_pix_size);

rek_object=Reconstructor_2D(Ef_pha,Ef_max,Ef_min,Ef_avg);
   rek_object.read_data('rawData.txt',28,3,3);
   rek_object.it_recon(alg_params,'display'); %IMP!!!!!!!!



toc
S_viewer;
Pot_viewer;
R_viewer;

