clear all;
close all;
global data_type; 
data_type = 'double';

%try
    
tic

% Sensor elements
% remember! thick is rmax-rmin,
% 
fov_radius = 40;    %[mm] diameter = 2*fov_radius
ins1_thick = 0;     %[mm]
electrode_thick =1; %[mm]
ins3_thick   =2;     %[mm]
screen_thick =1;     %[mm]
matrix_size = 90;    %[mm]
grid_size  = 1;     %[mm]

rekonstruction_mtx_pix_size_big=80; % fov diameter

ins1_min_r=fov_radius;

%check is matrix size big enough
all_elem_size=2*(fov_radius+ins1_thick+electrode_thick+ins3_thick+screen_thick);
if(all_elem_size>matrix_size)
    error('Sensor elements size are bigger than discretization grid');
end

% sensor
number_of_electrodes=16;
ratio_electrode_to_insulator=2.4;
start_ins2_angle=6.5;

% phantoms
d_mm =10;
D_mm =11.05;

indx = [10 1 18 21 23 31];
    
rotate_pha=17;
pha_perm=3;

pha_min_perm=1;
pha_avg_perm=2;
pha_max_perm=3;

% algorithm LBP_LM
alg_params_LBP_LM.method='LBP_LM';
alg_params_LBP_LM.numiter=115;
alg_params_LBP_LM.stop_delta=1e-10;
alg_params_LBP_LM.update_method='modulo';
alg_params_LBP_LM.iter_mod=55;
alg_params_LBP_LM.update_delta=0.1;
alg_params_LBP_LM.alpha=0.1;
alg_params_LBP_LM.alpha_=0.1; 
alg_params_LBP_LM.alphalimit='noadapt';
alg_params_LBP_LM.regular='L-curve';
alg_params_LBP_LM.u=0.1;

% algorithm LM
alg_params_LM.method='LM';
alg_params_LM.numiter=115;
alg_params_LM.stop_delta=1e-10;
alg_params_LM.update_method='modulo';
alg_params_LM.iter_mod=55;
alg_params_LM.update_delta=0.1;
alg_params_LM.alpha=0.1;
alg_params_LM.alpha_=0.1; 
alg_params_LM.alphalimit='noadapt';
alg_params_LM.regular='L-curve';
alg_params_LM.u=0.1;

% algorithm LBP
alg_params_LBP.method='LBP';
alg_params_LBP.numiter=1;
alg_params_LBP.stop_delta=0;
alg_params_LBP.update_method='modulo';
alg_params_LBP.iter_mod=0;
alg_params_LBP.update_delta=0;
alg_params_LBP.alpha=0;
alg_params_LBP.alpha_=0; %alpha_=alpha;
alg_params_LBP.alphalimit='noadapt';
alg_params_LBP.regular='manual';
alg_params_LBP.u=0;

% discretization grid
dg=Discretization_grid_2D_square(matrix_size,grid_size);

% Field of view
fov=Sensor_element_circular(0,360,0,fov_radius,dg,'none',1,'fov');

% Electrode & Insulator between electrodes
electrode_min_r=ins1_min_r+ins1_thick;

number_of_insulator_beetween_electrodes=number_of_electrodes;
% Memory allocation
Electrodes_vector=repmat(Sensor_element_circular,1,number_of_electrodes);
Insulator2_vector=repmat(Sensor_element_circular,1,number_of_insulator_beetween_electrodes);


electrode_angle=360/(number_of_electrodes*(1+(1/ratio_electrode_to_insulator)));
insulator2_angle=360/(number_of_electrodes*(1+ratio_electrode_to_insulator));

for p=1:1:number_of_electrodes;
    Insulator2_vector(p)=...
        Sensor_element_circular(...
        start_ins2_angle+(p-1)*insulator2_angle+(p-1)*electrode_angle, ...
        start_ins2_angle+(p)*insulator2_angle+(p-1)*electrode_angle, ...
        electrode_min_r,electrode_min_r+electrode_thick,dg,'none',2,'ins2');

    Electrodes_vector(p)=...
        Sensor_element_circular(...
        start_ins2_angle+(p)*insulator2_angle+(p-1)*electrode_angle,...
        start_ins2_angle+(p)*insulator2_angle+(p)*electrode_angle,...
        electrode_min_r,electrode_min_r+electrode_thick,dg,12,10000,'electrode');
end



% Insulator 3
ins3_min_r=electrode_min_r+electrode_thick;
ins3=Sensor_element_circular(0,360,ins3_min_r,ins3_min_r+ins3_thick,dg,'none',2,'ins3');

% Screen
scrn_min_r=ins3_min_r+ins3_thick;
scrn=Sensor_element_circular(0,360,scrn_min_r,scrn_min_r+screen_thick,dg,0,10000,'screen');

% Sensor
% Last element is on top

s=Sensor_2D(dg);
s.add_element(fov);


number_of_insulator_beetween_electrodes=length(Insulator2_vector);
for i=1:number_of_insulator_beetween_electrodes
    s.add_element(Insulator2_vector(i));
end

s.add_element(ins3);
s.add_element(scrn);

number_of_electrodes=numel(Electrodes_vector);
for i=1:number_of_electrodes
        s.add_element(Electrodes_vector(i));
end


%phantom_gen=Phantom_generator_2D(fov,'ask_me',rotate_pha,pha_perm,d_mm,D_mm);       
phantom_gen=Phantom_generator_2D(fov,'rods_indx',rotate_pha,pha_perm,d_mm,D_mm,indx);


pd=Permittivity_distribution_2D(fov);

pd.add_Element(phantom_gen);

% phantom_gen2=Phantom_generator_2D(fov,'ask_me',0,pha_perm,d_mm,D_mm);       
% pd.add_Element(phantom_gen2);



Ef_pha_big=Electrical_field_2D(s,pd,rekonstruction_mtx_pix_size_big);



%max
phantom_max=Phantom_generator_2D(fov,'uniform',pha_max_perm);     
pd_max=Permittivity_distribution_2D(fov);
pd_max.add_Element(phantom_max);
Ef_max_big=Electrical_field_2D(s,pd_max,rekonstruction_mtx_pix_size_big);

%min
phantom_min=Phantom_generator_2D(fov,'uniform',pha_min_perm);     
pd_min=Permittivity_distribution_2D(fov);
pd_min.add_Element(phantom_min);
Ef_min_big=Electrical_field_2D(s,pd_min,rekonstruction_mtx_pix_size_big);


%avg
phantom_avg=Phantom_generator_2D(fov,'uniform',pha_avg_perm);     
pd_avg=Permittivity_distribution_2D(fov);
pd_avg.add_Element(phantom_avg);
Ef_avg_big=Electrical_field_2D(s,pd_avg,rekonstruction_mtx_pix_size_big);


rek_object_LM_big=Reconstructor_2D(Ef_pha_big,Ef_max_big,Ef_min_big,Ef_avg_big);
rek_object_LBP_LM_big=Reconstructor_2D(Ef_pha_big,Ef_max_big,Ef_min_big,Ef_avg_big);
rek_object_LBP_big=Reconstructor_2D(Ef_pha_big,Ef_max_big,Ef_min_big,Ef_avg_big);


rek_object_LM_big.it_recon(alg_params_LM,'no_display');
rek_object_LBP_LM_big.it_recon(alg_params_LBP_LM,'no_display');
rek_object_LBP_big.it_recon(alg_params_LBP,'no_display');
 

toc
S_viewer;
Pot_viewer;
R_viewer;

% error catch
% catch ex
%     disp(ex.message) 
%     disp(ex.cause)
%     disp(ex.stack)
% end
