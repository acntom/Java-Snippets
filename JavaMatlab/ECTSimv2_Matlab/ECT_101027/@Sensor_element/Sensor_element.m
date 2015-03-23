%> @file Sensor_element.m
%> @brief Abstract class represents single sensor element. 
% ======================================================================
%> @brief Abstract class represents single sensor element. 
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Sensor_element <  handle
    
   properties (Abstract = true)
       %> permittivity value of element
       permittivity;
       %> voltage value of element
       voltage;
       %> vector of points belongs to the element - linear index
       point_list;
       %> element name
       element_name;
   end

   methods (Abstract = true)

   end
end 
