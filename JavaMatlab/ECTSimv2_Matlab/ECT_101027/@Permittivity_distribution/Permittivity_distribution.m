%> @file Permittivity_distribution.m
%> @brief This is abstract class. Sum of phantoms in field of view.
% ======================================================================
%> @brief This is abstract class. Sum of phantoms in field of view.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Permittivity_distribution < handle
    
    properties (Abstract = true)
        %> permittivity distribution of phantom sum in FOV
        Discretization_grid_perm;
        %> vector of linear indicies to elements belongs to field of view
        fov_indicies_vector;
        %> vector of phantom object
        phantom_vector;           
    end
    
    methods (Abstract = true)
        % =================================================================
        %> @brief Use to add single phantom.
        %>
        %> @param varargin single Phantom_generator_2D object.
        % =================================================================
        add_Element(varargin)
        
        % =================================================================
        %> @brief Get resize permittivity map from FOV
        %>
        %> @param varargin resize parameters
        % =================================================================
        getFOV(varargin)          
    end
    
end

