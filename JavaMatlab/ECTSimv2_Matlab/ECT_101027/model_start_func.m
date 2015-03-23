function []=model_start_func()

clear all;
close all;

global data_type; 
data_type = 'double';

tic


% Sensor elements
fov_thick  = 24;    %[mm]
ins1_thick = 0;     %[mm]
electrode_thick =1; %[mm]
ins3_thick  =3;     %[mm]
screen_thick=1;     %[mm]
matrix_size= 60;    %[mm]
grid_size  = 1;     %[mm]
rekonstruction_mtx_pix_size=48;

ins1_min_r=fov_thick;

% sensor
number_of_electrodes=16;
ratio_electrode_to_insulator=2;
start_ins2_angle=7.5;

% phantoms
d_mm =9;
D_mm =14;

indx=[2,4,6];

pha_perm=3;

pha_min_perm=1;
pha_max_perm=2;
pha_avg_perm=3;


% algorithm
alg_params.method='LBP_LM';
alg_params.numiter=60;
alg_params.stop_delta=1e-20;
alg_params.update_method='modulo';
alg_params.iter_mod=50;
alg_params.update_delta=0;
alg_params.alpha=0.05;
alg_params.alpha_=alg_params.alpha; %alpha_=alpha;
alg_params.alphalimit='noadapt';
alg_params.regular='manual';
alg_params.u=0.05;

%evalins
display 'default values';

komenda=['fov_thick=',num2str(fov_thick)];
evalin('base',komenda);

komenda=['ins1_thick=',num2str(ins1_thick)];
evalin('base',komenda);

komenda=['electrode_thick=',num2str(electrode_thick)];
evalin('base',komenda);

komenda=['ins3_thick=',num2str(ins3_thick)];
evalin('base',komenda);

komenda=['screen_thick=',num2str(screen_thick)];
evalin('base',komenda);

komenda=['matrix_size=',num2str(matrix_size)];
evalin('base',komenda);

komenda=['grid_size=',num2str(grid_size)];
evalin('base',komenda);

komenda=['rekonstruction_mtx_pix_size=',num2str(rekonstruction_mtx_pix_size)];
evalin('base',komenda);

evalin('base','ins1_min_r=fov_thick;');

% sensor
komenda=['number_of_electrodes=',num2str(number_of_electrodes)];
evalin('base',komenda);

komenda=['ratio_electrode_to_insulator=',num2str(ratio_electrode_to_insulator)];
evalin('base',komenda);

komenda=['start_ins2_angle=',num2str(start_ins2_angle)];
evalin('base',komenda);

% phantoms

komenda=['d_mm=',num2str(d_mm)];
evalin('base',komenda);

komenda=['D_mm=',num2str(D_mm)];
evalin('base',komenda);

for i=1:length(indx)
    komenda=['indx(',num2str(i),')','=',num2str(indx(i)),';'];
    evalin('base',komenda);
end
evalin('base','indx');

komenda=['pha_perm=',num2str(pha_perm)];
evalin('base',komenda);

komenda=['pha_min_perm=',num2str(pha_min_perm)];
evalin('base',komenda);

komenda=['pha_max_perm=',num2str(pha_max_perm)];
evalin('base',komenda);

komenda=['pha_avg_perm=',num2str(pha_avg_perm)];
evalin('base',komenda);

% algorithm

komenda=['alg_params.method=','''',alg_params.method,'''',';'];
evalin('base',komenda);

komenda=['alg_params.numiter=',num2str(alg_params.numiter),';'];
evalin('base',komenda);

komenda=['alg_params.stop_delta=',num2str(alg_params.stop_delta),';'];
evalin('base',komenda);

komenda=['alg_params.update_method=','''',alg_params.update_method,'''',';'];
evalin('base',komenda);

komenda=['alg_params.iter_mod=',num2str(alg_params.iter_mod),';'];
evalin('base',komenda);

komenda=['alg_params.update_delta=',num2str(alg_params.update_delta),';'];
evalin('base',komenda);

komenda=['alg_params.alpha=',num2str(alg_params.alpha),';'];
evalin('base',komenda);

komenda=['alg_params.alpha_=',num2str(alg_params.alpha_),';'];
evalin('base',komenda);

komenda=['alg_params.alphalimit=','''',alg_params.alphalimit,'''',';'];
evalin('base',komenda);

komenda=['alg_params.regular=','''',alg_params.regular,'''',';'];
evalin('base',komenda);

komenda=['alg_params.u=',num2str(alg_params.u)];
evalin('base',komenda);

display 'changed values';
  h=model_params();
  uiwait(h);
  

% grid
evalin('base','dg=Discretization_grid_2D_square(matrix_size,grid_size);');


% Field of view
komenda=['fov=Sensor_element_circular(0,360,0,fov_thick,dg,','''','none','''',',1,','''','fov',''');'];
evalin('base',komenda);

% Electrode & Insulator between electrodes
electrode_min_r=ins1_min_r+ins1_thick;
numele=num2str(evalin('base','number_of_electrodes;'));

evalin('base',['number_of_insulator_beetween_electrodes=',numele]);
    % Memory allocation
evalin('base',['Electrodes_vector=repmat(Sensor_element_circular,1,',numele,');']);
evalin('base',['Insulator2_vector=repmat(Sensor_element_circular,1,',numele,');']);

evalin('base','electrode_angle=360/(number_of_electrodes*(1+(1/ratio_electrode_to_insulator)));')
evalin('base','insulator2_angle=360/(number_of_electrodes*(1+ratio_electrode_to_insulator));');

numele=evalin('base','number_of_electrodes;');
for p=1:1:numele;
    
    evalin('base',['ai1=start_ins2_angle+',num2str(p-1),'*insulator2_angle+',num2str(p-1),'*electrode_angle;']);
    evalin('base',['ai2=start_ins2_angle+',num2str(p),'*insulator2_angle+',num2str(p-1),'*electrode_angle;']);
    komenda=['Insulator2_vector(',num2str(p),')=Sensor_element_circular(ai1,ai2,',...        
        num2str(electrode_min_r),',',num2str(electrode_min_r+electrode_thick),',','dg',',','''','none','''',',2,',...
        '''','ins2','''',');'];
    
    evalin('base',komenda);
    
    evalin('base',['ae1=start_ins2_angle+',num2str(p),'*insulator2_angle+',num2str(p-1),'*electrode_angle;']);
    evalin('base',['ae2=start_ins2_angle+',num2str(p),'*insulator2_angle+',num2str(p),'*electrode_angle;']);
    komenda=['Electrodes_vector(',num2str(p),')=Sensor_element_circular(ae1,ae2,',...        
        num2str(electrode_min_r),',',num2str(electrode_min_r+electrode_thick),',','dg',',','12',',10000,',...
        '''','electrode','''',');'];
    
    evalin('base',komenda);    
end

% Insulator 3
ins3_min_r=electrode_min_r+electrode_thick;
komenda=['ins3=Sensor_element_circular(0,360,',num2str(ins3_min_r),',',num2str(ins3_min_r+ins3_thick),',dg,','''','none','''',',','2,','''','ins3','''',');'];

evalin('base',komenda);
% Screen
scrn_min_r=ins3_min_r+ins3_thick;
komenda=['scrn=Sensor_element_circular(0,360,',num2str(scrn_min_r),',',num2str(scrn_min_r+screen_thick),',','dg,','0,','10000,','''','screen','''',');'];
evalin('base',komenda);

% Sensor
% Last element is on top

evalin('base','s=Sensor_2D(dg);');
evalin('base','s.add_element(fov);');
% s.add_element(ins1);


for i=1:evalin('base','number_of_electrodes')
    komenda=['s.add_element(Insulator2_vector(',num2str(i),'));'];
    evalin('base',komenda);
end

evalin('base','s.add_element(ins3);');
evalin('base','s.add_element(scrn);');

for i=1:evalin('base','number_of_electrodes')
        komenda=['s.add_element(Electrodes_vector(',num2str(i),'));'];
        evalin('base',komenda);
end

%phantom_gen=Phantom_generator_2D(fov,'ask_me',0,pha_perm,d_mm,D_mm);       

komenda=['phantom_gen=Phantom_generator_2D(fov,','''','ask_me','''',',0,pha_perm,d_mm,D_mm);'];

evalin('base',komenda);

%phantom_gen=Phantom_generator_2D(fov,'uniform',40);
evalin('base','pd=Permittivity_distribution_2D(fov);');

evalin('base','pd.add_Element(phantom_gen);');

% phantom_gen2=Phantom_generator_2D(fov,'ask_me',0,pha_perm,d_mm,D_mm);       


evalin('base','Ef_pha=Electrical_field_2D(s,pd,rekonstruction_mtx_pix_size);');


komenda=['phantom_max=Phantom_generator_2D(fov,','''','uniform','''',',','pha_max_perm);'];     
evalin('base',komenda);
evalin('base','pd_max=Permittivity_distribution_2D(fov);');
evalin('base','pd_max.add_Element(phantom_max);');
evalin('base','Ef_max=Electrical_field_2D(s,pd_max,rekonstruction_mtx_pix_size);');


komenda=['phantom_min=Phantom_generator_2D(fov,','''','uniform','''',',','pha_min_perm);'];     
evalin('base',komenda);
evalin('base','pd_min=Permittivity_distribution_2D(fov);');
evalin('base','pd_min.add_Element(phantom_min);');
evalin('base','Ef_min=Electrical_field_2D(s,pd_min,rekonstruction_mtx_pix_size);');


komenda=['phantom_avg=Phantom_generator_2D(fov,','''','uniform','''',',','pha_avg_perm);'];     
evalin('base',komenda);
evalin('base','pd_avg=Permittivity_distribution_2D(fov);');
evalin('base','pd_avg.add_Element(phantom_avg);');
evalin('base','Ef_avg=Electrical_field_2D(s,pd_avg,rekonstruction_mtx_pix_size);');

evalin('base','rek_object=Reconstructor_2D(Ef_pha,Ef_max,Ef_min,Ef_avg);');
%   rek_object.read_data('najwieksze_babelki.TXT',120,3,3);
%   rek_object.draw_real_data_from_file();
komenda=['rek_object.it_recon(alg_params,','''','no_display','''',');'];
evalin('base',komenda);

toc
S_viewer;
Pot_viewer;
R_viewer;


 end
