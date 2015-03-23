%> @file Phantom_generator.m
%> @brief This is Abstract class. Generates phantoms(circles).
% ======================================================================
%> @brief This is Abstract class. Generates phantoms(circles).
%
%> One permittivity value is available for one phantom. Generates permittivity maps.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Phantom_generator < handle
    
    properties (Abstract = true)
        %> phantom name
        phantom_name;
        %> permittivity value of phantom
        eps;
        %> matrix of permittivity distribution of phantom
        ph_map;
        %> phantom permittivity distribution (discretization grid object)
        discretization_grid;  
        %> point list of phantom (linear index)                       
        point_list            
    end
    
    methods (Abstract = true)
    end
    
end

