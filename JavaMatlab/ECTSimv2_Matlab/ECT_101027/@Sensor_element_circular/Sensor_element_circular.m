%> @file Sensor_element_circular.m
%> @brief Circular element of sensor.
% ======================================================================
%> @brief Circular element of sensor.
%>
%> Circular element have permittivty and voltage grid, point vector,
%> and circular geometry.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Sensor_element_circular  < Sensor_element

   properties (GetAccess = public)  
   %> radius-inner part of Sensor_element_circular in grid elements
   rmin;
   %> radius-outer part of Sensor_element_circular in grid elements
   rmax;                 
   %> radius-inner part of Sensor_element_circular in milimeters
   rmin_mm;
   %> radius-outer part of Sensor_element_circular in milimeters
   rmax_mm;
   %> permittivity value
   permittivity = 1; 
   %> vector of indicies (only for this element) linear index to value_list (discretization grid)
   point_list;           
   %> element name
   element_name='Sensor_element_circular';
   %> start angle [degree]
   start_angle;
   %> stop angle [degree]
   stop_angle;
   %> voltage value [volts], 'none' means potential is unknown
   voltage='none';       
   %> grid with permittivity distribution (discretization grid object)
   discretization_grid_of_element; 
   %> grid with boundary conditions (discretization grid object)
   discretization_grid_of_voltage;   
   end
   
   properties (SetAccess=private)
   %> temporary grid (not to use)
   discretization_grid_point_list_tmp; 
   end

   methods (Access=public)
       % ==================================================================
       %> @brief Constructor.
       %>
       %> @param varargin{1} start_angle [degree] where object begins
       %> @param varargin{2} stop_angle [degree] where object ends
       %> @param varargin{3} rmin_mm [milimeters] radius-inner part of element
       %> @param varargin{4} rmax_mm [milimeters] radius-outer part of element
       %> @param varargin{5} discretization grid object (main model grid)
       %> @param varargin{6} voltage [volts], 'none' means potential is unknown            
       %> @param varargin{7} permittivity value                                                                      
       %> @param varargin{8} element name (it is important to name field of view 'fov' and electrode 'electrode')                             
       %> @return instance of the Sensor_element_circular class.
       % ==================================================================
       function Sensor_element_circular_obj = Sensor_element_circular(varargin)           
          if nargin == 0 ; % no input arguments
          elseif isa(varargin{1},'Sensor_element_circular')
            Sensor_element_circular_obj = varargin{1}; % copy constructor
            display 'copy constructor Sensor_element_circular'
            return;          
          else
             switch(nargin)
                case 8,

                    Sensor_element_circular_obj.start_angle=varargin{1};
                    Sensor_element_circular_obj.stop_angle=varargin{2};
                    Sensor_element_circular_obj.rmin_mm=varargin{3}; % [mm]
                    Sensor_element_circular_obj.rmax_mm=varargin{4}; % [mm]
                    
                    
                    discretization_grid_tmp=varargin{5};
                    Sensor_element_circular_obj.voltage=varargin{6};                                                           
                    Sensor_element_circular_obj.permittivity=varargin{7};                   
                    Sensor_element_circular_obj.element_name=varargin{8};
                    
                    if (Sensor_element_circular_obj.permittivity<1)                    
                        error('Permittivity is less than one');   
                    end
                    
                    Sensor_element_circular_obj.rmin=Sensor_element_circular_obj.rmin_mm/discretization_grid_tmp.grid_size_mm; % pixels
                    Sensor_element_circular_obj.rmax=Sensor_element_circular_obj.rmax_mm/discretization_grid_tmp.grid_size_mm; % pixels
                    
                    str=Sensor_element_circular_obj.element_name;
                  
                    fprintf('%s creating \n',str);

                    K=discretization_grid_tmp.number_of_x_axis_pixel;
                    
                    % Each element has own discretization grid. Not
                    % reference to one discretizationgrid
                    ms=discretization_grid_tmp.matrix_size_mm;
                    gs=discretization_grid_tmp.grid_size_mm;
                    Sensor_element_circular_obj.discretization_grid_of_element=Discretization_grid_2D_square(ms,gs);
                    
                    Sensor_element_circular_obj.discretization_grid_point_list_tmp=Discretization_grid_2D_square(ms,gs);
                    
                    Sensor_element_circular_obj.discretization_grid_point_list_tmp.value_list=...
                        ones(1, length(Sensor_element_circular_obj.discretization_grid_point_list_tmp.value_list))*(-1);                    
                    
                    
                    % create dg_voltage only for this elements where voltage!='none'
                    if(~strcmp(Sensor_element_circular_obj.voltage,'none'))
                        Sensor_element_circular_obj.discretization_grid_of_voltage=Discretization_grid_2D_square(ms,gs);
                    end
                    
                    %minimal step angle to draw object
                    %TODO checking round and abs of rmin i rmax
                    radius_length=abs(abs(Sensor_element_circular_obj.rmax)-abs(Sensor_element_circular_obj.rmin));
                    
                    radius_step=abs(discretization_grid_tmp.grid_size_mm/2);
                    
                    for l=1:radius_step:radius_length                       
                        
                    radius=Sensor_element_circular_obj.rmin+l;

                    step_angle=atan(double((pi/180)*(1/radius)));                
                    
                    radian_stop  =( (pi * Sensor_element_circular_obj.stop_angle) / 180 );
                    radian_start =( (pi*Sensor_element_circular_obj.start_angle) / 180 ); 
                   
                    NOP=round((2*(abs(radian_start-radian_stop)))/step_angle);

                   % calculate Sensor_element_circular points                     
                    THETA=linspace(radian_start,radian_stop,NOP);
                    RHO=ones(1,NOP)*radius;
                    [X,Y] = pol2cart(THETA,RHO);
                    
                    max_val=discretization_grid_tmp.number_of_x_axis_pixel;
                    
           
                    R=abs(round(X(:)+(K/2)+0.5));
                    C=abs(round(-Y(:)+(K/2)+0.5));                                        
                  
                    fr1=find(R>max_val,1);                       
                    fr2=find(R<0,1);
                        
                    fc1=find(C>max_val,1);
                    fc2=find(C<0,1);
                        
                    if(isempty(fr1)&&isempty(fr2)&&isempty(fc1)&&isempty(fc2))
                        
                        val_vector_tmp=(ones(1, numel(C))*Sensor_element_circular_obj.permittivity)';


                        Sensor_element_circular_obj.discretization_grid_of_element.insert_value_in_point(C,R,val_vector_tmp);                         

                        Sensor_element_circular_obj.discretization_grid_point_list_tmp.insert_value_in_point(C,R,val_vector_tmp); 


                        % voltage boundary map
                        if(~strcmp(Sensor_element_circular_obj.voltage,'none'))                        

                            voltage_val_vector_tmp=ones(1, numel(C))*Sensor_element_circular_obj.voltage;

                            %lnv=length(Sensor_element_circular_obj.discretization_grid_of_voltage.value_list);
                            % insert zeros ewerywhere in voltage map
                            Sensor_element_circular_obj.discretization_grid_of_voltage.value_list(:)=0;

                            Sensor_element_circular_obj.discretization_grid_of_voltage.insert_value_in_point(C,R,voltage_val_vector_tmp);

                            %b_map=Sensor_element_circular_obj.discretization_grid_of_voltage.value_list;
    %                         ind=find(b_map==1);
    %                         ind
    %                         b_map(ind)=zeros(1,1:numel(ind));
                            %Sensor_element_circular_obj.discretization_grid_of_voltage.value_list=b_map;

                        end




                         tmp_value_list=Sensor_element_circular_obj.discretization_grid_point_list_tmp.value_list;

                         Sensor_element_circular_obj.point_list=find(tmp_value_list==Sensor_element_circular_obj.permittivity);           
                         else
                                 error('Current element is bigger than using discretization grid. Change grid or parameters of element.');                 
                    end % isempty
                    
                    end % 'main' for
                otherwise  
                  error('To less or to much input elements');                    
             end
          end
       %end constructor
       
       end     
       
       % ==================================================================
       %> @brief Geometric sketch of element
       % ==================================================================
       function drawing(s_obj)
           x_cntr=s_obj.discretization_grid_of_element.discret_matrix_size;
           y_cntr=s_obj.discretization_grid_of_element.discret_matrix_size;
           % check is number is odd or even
           if(mod(x_cntr,2)==0) 
               x_center=x_cntr+0.5;
           else
               x_center=x_cntr;
           end
           
           if(mod(y_cntr,2)==0) 
               y_center=y_cntr+0.5;
           else
               y_center=y_cntr;
           end
           s_obj.pie(x_center,y_center,s_obj.rmin*2,s_obj.rmax*2,s_obj.start_angle,s_obj.stop_angle);
       end
       
       % ==================================================================
       %> @brief Draw discrete permittivity representation of element. Two modes are 
       %> available: auto or thresholds.
       %>
       %> @param varargin{1} mode - auto or threshold
       %> @param varargin{2} value of lower threshold (if threshold mode enable else without this field)
       %> @param varargin{3} value of upper threshold (if threshold mode enable else without this field)       
       % ==================================================================
       function draw_permittivity(varargin)                      
           
           % default - auto
           if nargin==1
               se_obj=varargin{1};               
               se_obj.discretization_grid_of_element.set_display_thresholds('auto');
               se_obj.discretization_grid_of_element                           
                
           % thresholds
           elseif nargin==4
                se_obj=varargin{1};
                mode=varargin{2};
                lt_tmp=varargin{3};
                ut_tmp=varargin{4};
                
                if (strcmp(mode,'thresholds'))
                    
                    se_obj.discretization_grid_of_element.set_display_thresholds('thresholds',lt_tmp,ut_tmp);
                    se_obj.discretization_grid_of_element
                else
                    error 'Incorrect threshold mode'
                end                                
                
           else
               error 'Incorrect number of input elements'
           end                      
           
       end % draw_permittivity
              
   end %end methods
   
   methods (Access=private)
       
    % =====================================================================
    %> @brief Draw fragment of circle.
    %>
    %> @param xc,yc center of piece
    %> @param d1,d2 diameter_1,diameter_2 (d1 < d2)
    %> @param a1,a2 start angle,stop angle a1 < a2
    %> @param line,points use to display (optional)
    % =====================================================================
    %function pie(xc,yc,d1,d2,a1,a2,line,points)
    pie(s_obj,xc,yc,d1,d2,a1,a2,line,points)

   end 
   
end %end class

