% =====================================================================
%> @brief projections calculates capacitances to be measured with phantom
%>
%> @param error_V capacitance error amplitude e.g. error_V = 0.001 - 1 mV or 'none'
%> @param range_V capacitance error range e.g. range_V = 10 - 10 V or 'none' 
%>
%> @retval out return value of this method
% =====================================================================
function [C] = projections(ef_obj,error_V,range_V) 

disp 'projections (capacitances) - calculating';

S   = ef_obj.S;

% Compute capacitance only in FOV

point_list=ef_obj.permittivity_distribution.fov_indicies_vector;

% alloc
Perm_FOV=ones(1,numel(point_list));

Perm_FOV=ef_obj.discretization_grid_sensor_and_phantom.value_list(point_list);
Eps=Perm_FOV;

S_tmp=ones(ef_obj.sens_matrix_num,numel(point_list));

S_tmp=S(:,point_list);
S=S_tmp;

C = S*(Eps');

if ~strcmp(error_V,'none')&& ~strcmp(range_V,'none')
    rand('twister', sum(100*clock));
    C = C + error_V/range_V * ( max(C)-min(C))*rand(ef_obj.measurement_count,1);
end

disp 'projections (capacitances). done.';