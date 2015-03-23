% ======================================================================
%> @brief phantom_rods calculates permittivity distribution for rod phantom
%> creates numerical phantom with rods using list of positions and values
%> the permittivity value is calculated only for FOV region
%>
%> @param discret_matrix_size_mm   side 'matrix size' in milimeters
%> @param discret_matrix_size      side matrix size [number of grid elements]
%> @param list                     vector of structures position (r,a), diameter and value for rods
%> @param fov_permit               permittivity of field of view 
%>
%> @retval ph_map (matrix) permittivity
% =====================================================================
function[ph_map] = phantom_rods(phobj,discret_matrix_size_mm,discret_matrix_size, list, fov_permit)

    disp 'phantom - rods 2 map';

    ph_map = phobj.phantom_generate(discret_matrix_size_mm,discret_matrix_size,list,fov_permit);    

    disp 'end'

    