function [ params ] = sensor_params()

A=imread('sonda_scheme.png');
imshow(A);

% FOV
sens_fov_diam = dlg_data( 'Input for sensor','Sensor FOV diameter[mm]','60' );
sens_fov_radius=sens_fov_diam/2;
params.sens_fov_radius=sens_fov_radius;

sens_fov_perm = dlg_data( 'Input for sensor','Sensor FOV permittivity','1' );
params.sens_fov_perm=sens_fov_perm;

% Pipe
sens_pipe_thick = dlg_data( 'Input for sensor','Sensor pipe thick [mm]','0' );
params.sens_pipe_thick=sens_pipe_thick;

sens_pipe_perm = dlg_data( 'Input for sensor','Sensor pipe permittivity','0' );
params.sens_pipe_perm=sens_pipe_perm;

%Electrodes
sens_electrode_thick = dlg_data( 'Input for sensor','Electrode thick [mm] ','1' );
params.sens_electrode_thick=sens_electrode_thick;

sens_electrode_num = dlg_data( 'Input for sensor','Number of electrodes ','16' );
params.sens_electrode_num=sens_electrode_num;

max_ele_deg=360/sens_electrode_num;
sens_electrode_deg = dlg_data( 'Input for sensor',['Electrode angle [degree]. Must be less than ', num2str(max_ele_deg)],num2str(max_ele_deg-1) );
if (sens_electrode_deg<max_ele_deg)
    ins_deg=max_ele_deg-sens_electrode_deg;
    params.sens_electrode_ins_ratio=sens_electrode_deg/ins_deg;
else
    display('Electrode angle is too high');
end

sens_electrode_permittivity = dlg_data( 'Input for sensor','Electrode_permittivity ','10000' );
params.sens_electrode_permittivity=sens_electrode_permittivity;

% insulator beetween elctrodes
sens_ins2_perm = dlg_data( 'Input for sensor','Insulator beetween electrodes permittivity','2' );
params.sens_ins2_perm=sens_ins2_perm;

%insulator between electrode and screen
sens_ins_thick = dlg_data( 'Input for sensor','Insulator thick [mm]','2' );
params.sens_ins_thick=sens_ins_thick;

sens_ins_perm = dlg_data( 'Input for sensor','Insulator permittivity','3' );
params.sens_ins_perm=sens_ins_perm;

%Screen
sens_screen_thick = dlg_data( 'Input for sensor','Screen thick [mm]','1' );
params.sens_screen_thick=sens_screen_thick;

sens_screen_perm = dlg_data( 'Input for sensor','Screen permittivity','10000' );
params.sens_screen_perm=sens_screen_perm;

%Grid
grid_size = dlg_data( 'Input for sensor','Grid size [mm]','1' );
params.grid_size=grid_size;

%Compute grid
thick_elements_tab=[...
sens_fov_radius,...
sens_pipe_thick,...
sens_electrode_thick,...
sens_ins_thick,...
sens_screen_thick,...
];
% fit sensor elements to grid
% sensor element must be equal to grid size or mustbe multiple of grid size 
parfor i=1:length(thick_elements_tab)
    if(thick_elements_tab(i)==0)
        %don't rescale
    elseif((0<thick_elements_tab(i)) && (thick_elements_tab(i)<grid_size))
        thick_elements_tab(i)=grid_size
        display('sensor element scaled');
    elseif(thick_elements_tab(i)>grid_size)
        gridnum=thick_elements_tab(i)/grid_size
        gridnum=round(gridnum)
        thick_elements_tab(i)=gridnum*grid_size %[mm]
        display('sensor element scaled');
    end
end

sens_fov_radius=thick_elements_tab(1);
% fov must be even
fov_grid_elem=sens_fov_radius/grid_size; %grid elements
fov_even=mod(fov_grid_elem,2);

if(fov_even==0)
    %FOV is even
else
    sens_fov_radius=sens_fov_radius+grid_size;
    thick_elements_tab(1)=sens_fov_radius;
end

%in [mm]
params.sens_fov_radius=thick_elements_tab(1);
params.sens_pipe_thick=thick_elements_tab(2);
params.sens_electrode_thick=thick_elements_tab(3);
params.sens_ins_thick=thick_elements_tab(4);
params.sens_screen_thick=thick_elements_tab(5);

%compute matrix grid size
margin=3*grid_size;% [mm]
matrix_grid_size=2*(params.sens_fov_radius+params.sens_pipe_thick+params.sens_electrode_thick+params.sens_ins_thick+params.sens_screen_thick+margin);%[mm]
%matrix must be even
check_even=matrix_grid_size/grid_size;%grid elements
check_even=mod(check_even,2);
if(check_even==0)
    %do nth
else
    matrix_grid_size=matrix_grid_size+grid_size;
end

params.matrix_grid_size=matrix_grid_size;

params.reconstruction_grid = dlg_data( 'Input for Grid',['FWDP grid is ',num2str(params.matrix_grid_size/grid_size),'. Reconstruction grid in FOV (side size [pix])'],'32' );

end

