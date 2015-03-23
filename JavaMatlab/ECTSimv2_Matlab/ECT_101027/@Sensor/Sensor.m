%> @file Sensor.m
%> @brief Abstract class of sensor model. 
% ======================================================================
%> @brief Abstract class of sensor model.Calculates sensor model.
%>
%> Permittivity map of sensor and boundary conditions.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Sensor <  handle
   
    properties (Abstract = true)
       %> sensor permittivity distribution  (discretization grid object)
       discretization_grid;      
       %> contains sensor boundary condition (discretization grid object)
       discretization_grid_voltage; 
       %> vector of single sensor elements
       vector_sensor_elements;
       %> number of single sensor elements
       number_of_sensor_elements;
    end
    
    methods (Abstract = true)
    % =====================================================================
    %> @brief add single sensor element to sensor
    %>
    %> @param varargin single sensor element object 
    % =====================================================================    
        add_element(varargin);  
    end
    
end

