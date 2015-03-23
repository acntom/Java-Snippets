%> @file Electrical_field.m
%> @brief This is a abstract class.
% ======================================================================
%> @brief This is a abstract class. Describes how to compute 
%> sensitivity, potential maps and capacitances for sensor and phantom.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Electrical_field < handle
    
    properties (Abstract = true)
        %> sensor object
        sensor;
        %> potential distribution maps for sensor and phantom 
        potential_distribution_maps;
        %> vector of sensitivity maps 
        S_map;
        %> resized sensitivity matrix
        S_resize 
        %> capacitance vector 
        C;
        %> rescale permittivity distribution from FOV (matrix)
        Eps_fovImgToReconstruction_map
        %> rescale permittivity distribution from FOV (vector)
        Eps_fovImgToReconstruction
    end
    
    methods (Abstract = true)
        
        % =====================================================================
        %> @brief potential_distrib calculates potential distrubution 
        %>
        %> @param method - method of calculation of coefficients
        %>
        %> @retval V potential distribution vector of maps
        % =====================================================================        
        V = potential_distrib(varargin);           
        
        % =================================================================
        %> @brief Returns image where given FOV was put into given image
        %>
        %> @param varargin rescale parameters
        % =================================================================
        putFOV(varargin);
        
        % =================================================================
        %> @brief Draw one or all potential maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_potential(varargin)
        
        % =================================================================
        %> @brief Draw one or all sensitivity maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_sensitivity(varargin)
        
        % =================================================================
        %> @brief Draw sum of sensitivity maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_sum_S_map(varargin)
        
        % =================================================================
        %> @brief Draw sum of resize sensitivity maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_sum_resize_S_map(varargin)
        
        % =================================================================
        %> @brief Draw sum of potential maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_sum_pot_map(varargin)
        
        % =================================================================
        %> @brief Draw one or all resize sensitivity maps.
        %>
        %> @param varargin draw options
        % =================================================================
        draw_resize_sensitivity(varargin)
    end
    
end

