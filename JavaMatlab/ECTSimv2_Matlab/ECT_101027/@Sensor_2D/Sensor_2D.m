%> @file Sensor_2D.m
%> @brief Two dimensional sensor model.
% ======================================================================
%> @brief Two dimensional sensor model..
%>
%> Contains permittivity distribution and boundary condition.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================

classdef Sensor_2D < Sensor

   properties (SetAccess='public')
       %> sensor permittivity distribution (discretization grid object)
       discretization_grid;
       %> sensor boundary condition (discretization grid object)
       discretization_grid_voltage;
       %> vector of single sensor elements
       vector_sensor_elements;
       %> number of single sensor elements
       number_of_sensor_elements;
   end

   methods (Access=public)
       % ==================================================================
       %> @brief Constructor.
       %>
       %> @param varargin{1} Discretization_grid_2D_square object.      
       %>
       %> @return instance of the Sensor_2D class.
       % ==================================================================
       function s_obj=Sensor_2D(varargin)
           if nargin == 0 ; % no input arguments
           elseif isa(varargin{1},'Sensor_2D')
            s_obj = varargin{1}; % copy constructor
            display 'copy constructor Sensor_2D'
            return; 
           else
               switch(nargin)
                   case 1,
                       if(isa(varargin{1},'Discretization_grid_2D_square'))
                            dg_tmp=varargin{1};
                            s_obj.discretization_grid=Discretization_grid_2D_square(dg_tmp.matrix_size_mm,dg_tmp.grid_size_mm);
                            s_obj.discretization_grid_voltage=Discretization_grid_2D_square(dg_tmp.matrix_size_mm,dg_tmp.grid_size_mm);
                                                        
                            s_obj.number_of_sensor_elements=1;  
                            s_obj.vector_sensor_elements=repmat(Sensor_element_circular,1,1);
                                                        
                       else
                           display 'This is not Discretization Grid';
                       end
                   
                   otherwise
                       error('too less or too many input arguments');
               end
           end
       end
       
       % ==================================================================
       %> @brief Add single element to sensor. Update permittivty and
       %> boundary conditions grids.
       %>
       %> @param sensor_element Object of Sensor_element class.        
       % ==================================================================
       function add_element(sensor,sensor_element)      
           
           if(isa(sensor_element,'Sensor_element'))
               length_input_elements=length(sensor_element);
               % You can add one sensor_element or vector of sensor_elements
                   for j=1:length_input_elements
                 
                       sensor.vector_sensor_elements(sensor.number_of_sensor_elements)=sensor_element(j);                     
                       
                       
                       % Permittivity section
                       % find indicies were value is nozero -> less indicies to check
                      
                       vector_of_indecies=sensor_element(j).point_list;
                       length_of_indices_vector=length(vector_of_indecies);
                       for i=1:length_of_indices_vector
                           
                            sensor_element_value=sensor_element(j).discretization_grid_of_element.value_list(vector_of_indecies(i));
                            % 1)blank discretization grid has value '1' in each point
                            % 2)order of the elements is important, last element is on top
                            if(sensor_element_value~=1)
                                sensor.discretization_grid.value_list(vector_of_indecies(i))=sensor_element(j).discretization_grid_of_element.value_list(vector_of_indecies(i));
                            end      
                                                   
                       end       
                       

                       % Voltage section
                       if(~strcmp(sensor_element(j).voltage,'none'))
                           sensor_element_value_tmp=sensor_element(j).discretization_grid_of_voltage.value_list-1;
                           % find indicies were value is nozero -> less indicies to check
                        
                           vector_of_indecies=sensor_element(j).point_list;
                           length_of_indices_vector=length(vector_of_indecies);
                           for i=1:length_of_indices_vector
                               
                                sensor_element_value=sensor_element(j).discretization_grid_of_voltage.value_list(vector_of_indecies(i));
                                % 1)blank discretization grid has value '1' in each point
                                % 2)order of the elements is important, last element is on top
                                if(sensor_element_value~=1)
                                    sensor.discretization_grid_voltage.value_list(vector_of_indecies(i))=sensor_element(j).discretization_grid_of_voltage.value_list(vector_of_indecies(i));
                                end
                           end
                       end
                       
                       for i=1:length_of_indices_vector
                        ln_sens_vc=sensor.number_of_sensor_elements;
                        % to update/cover values must be more then one
                        % sensor element
                        if(ln_sens_vc>1)
                        for m=1:(ln_sens_vc-1)
                             sensor_element=sensor.vector_sensor_elements(m);
                             sensor_element.discretization_grid_of_element.value_list(vector_of_indecies(i))=1;
                             ind_tmp=find(sensor_element.point_list==vector_of_indecies(i));
                             sensor_element.point_list(ind_tmp)=[];
                        end
                        end
                      end
                            
                       sensor.number_of_sensor_elements=sensor.number_of_sensor_elements+1;
                       
                   end
           else
                display 'You are trying add object that is not a sensor element';
           end          
       end
       
       % ==================================================================
       %> @brief Draw geometrical representation of sensor. First create new
       %> figure.       
       % ==================================================================
       function sketch(sensor)
           hold on;
           for i=1:sensor.number_of_sensor_elements-1               
               sensor.vector_sensor_elements(i).drawing;
           end
           hold off;
       end
             
       % ==================================================================
       %> @brief Draw  permittivity representation of sensor in grid. Two modes  
       %> available auto or thresholds.
       %>
       %> @param varargin{1} mode - auto or threshold
       %> @param varargin{2} value of lower threshold (if threshold mode enable else without this field)
       %> @param varargin{3} value of upper threshold (if threshold mode enable else without this field)       
       % ==================================================================
       function draw_permittivity(varargin)                      
           
           % default - auto
           if nargin==1
               s_obj=varargin{1};
               s_obj.discretization_grid.set_display_thresholds('auto');
               s_obj.discretization_grid
                                              
           % thresholds
           elseif nargin==4
                s_obj=varargin{1};
                mode=varargin{2};
                lt_tmp=varargin{3};
                ut_tmp=varargin{4};
                
                if (strcmp(mode,'thresholds'))                    
                    s_obj.discretization_grid.set_display_thresholds('thresholds',lt_tmp,ut_tmp);
                    s_obj.discretization_grid
                else
                    error 'Incorrect threshold mode'
                end                                
                
           else
               error 'Incorrect number of input elements'
           end                      
           
       end % draw_permittivity
           
   end
end 
