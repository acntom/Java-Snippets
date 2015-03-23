%> @file Discretization_grid.m
%> @brief This is a abstract class.
% ======================================================================
%> @brief This is a abstract class.
%
%> This class contains basic properties and methods for other discretization grid objects.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Discretization_grid < handle
    
   properties (Abstract = true)
       %> linear index of values (in each grid point)
       value_list;  
       %> matrix version of value_list
       matrix;      
   end

   methods (Abstract = true)
    % ======================================================================
    %> @brief method use to insert value in discretization grid (value 
    %> is inserted to value_list vector) 
    %>
    %> @param varagin point coordinate and value
    % =====================================================================
     insert_value_in_point(varagin); 
   end
   
end 

    


