%> @file Discretization_grid_2D_square.m
%> @brief This is two dimensional square discretization 
%> grid.
% ======================================================================
%> @brief This is two dimensional square discretization 
%> grid.
%
%> This class contains methods for insert, get and display values from
%> discretization grid. We can also add Discretization_grid_2D_square object's 
%> to each other.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Discretization_grid_2D_square < Discretization_grid

   properties (SetAccess = public)
      %> number of x axis elements
      number_of_x_axis_pixel; 
      %> number of y axis elements
      number_of_y_axis_pixel;
      %> vector of x coordinates - linear index
      x_point_list;
      %> vector of y coordinates - linear index
      y_point_list;
      %> vector of values - linear index
      value_list;
      %> side size of discretization grid [mm]
      matrix_size_mm;
      %> size of one element in discretization grid [mm]
      grid_size_mm;
      %> number of side discret elements in grid (matrix_size/grid_size)
      discret_matrix_size;
      %> matrix version of value_list
      matrix;           
   end
   
   properties (SetAccess='private')
      %> lower threshold (use to display)
      lt=1;        
      %> upper threshold (use to display)
      ut=80;       
      %> display mode. Two modes are available: 'auto' or 'thresholds'      
      threshold_mode='auto' 
   end

   methods (Access=public)
        % =================================================================
        %> @brief Constructor.
        %>
        %> @param varargin{1} matrix_size_mm (side size of discretization grid [mm])
        %> @param varargin{2} grid_size_mm (size of one element in discretization grid [mm])
        %>
        %> @return instance of the Discretization_grid_2D_square class.    
        % =================================================================
       function dg_obj = Discretization_grid_2D_square(varargin)   
           
           if nargin == 0 ; % no input arguments
           elseif isa(varargin{1},'Discretization_grid_2D_square')
            dg_obj = varargin{1}; % copy constructor
            display 'copy constructor Discretization_grid_2D_square'
            return; 
           else
               switch(nargin)
                   case 2, %matrix_size grid_size
                       
                       dg_obj.matrix_size_mm = varargin{1};
                       dg_obj.grid_size_mm   = varargin{2};                       
                       
                       % check is point number is even
                       if(~(mod(dg_obj.matrix_size_mm/dg_obj.grid_size_mm,2)==0))
                           error('The number matrix_size/grid_size_mm must be even');
                       end
                       
                       dg_obj.number_of_x_axis_pixel=varargin{1}/varargin{2};  %matrix_size/grid_size;
                       dg_obj.discret_matrix_size=varargin{1}/varargin{2};     %matrix_size/grid_size;
                       
                       dg_obj.number_of_x_axis_pixel=round(dg_obj.number_of_x_axis_pixel);
                       dg_obj.number_of_y_axis_pixel=round(dg_obj.number_of_x_axis_pixel);
                       
    
                       dg_obj.number_of_x_axis_pixel=dg_obj.number_of_x_axis_pixel; %
                       dg_obj.number_of_y_axis_pixel=dg_obj.number_of_y_axis_pixel;
                       number_of_all_pixel=dg_obj.number_of_x_axis_pixel*dg_obj.number_of_y_axis_pixel;
                       
                       %allocate memory (increase speed)
                       ym=1:number_of_all_pixel;
                       xm=1:number_of_all_pixel;
                       
                       i=0;
                       for k=1:dg_obj.number_of_y_axis_pixel
                           for l=1:dg_obj.number_of_x_axis_pixel
                               i=i+1;
                               xm(i)=k;
                               ym(i)=l;              
                           end
                       end
                       % blank discretization grid has value '1' in each point
                       val_tmp(1:i)=1;
                        
                       % create linear index 
                       dg_obj.x_point_list=xm;
                       dg_obj.y_point_list=ym;
                       dg_obj.value_list=val_tmp;   
                        
                       % matrix version; allocate memory
                       dg_obj.matrix=zeros(dg_obj.discret_matrix_size,dg_obj.discret_matrix_size);                                        
                       
                   otherwise
                       error('To less or to much input elements');                       
               end
           end

       end
       
        % =================================================================
        %> @brief  Insert value in grid (value_list vector) using rows and cols         
        %>         coordintes like in matrix.
        %>
        %> @param matrix_x_v vector of x coordinates
        %> @param matrix_y_v vector of y coordinates
        %> @param val vector of values
        %        
        % =================================================================       
        function insert_value_in_point(dg_obj,matrix_x_v,matrix_y_v,val)

            point=(matrix_x_v-1)*dg_obj.number_of_x_axis_pixel+matrix_y_v;
        
            dg_obj.value_list(point)=val;

        end
        
        % =================================================================
        %> @brief Get matrix version of value_vector.
        %>        
        %> @retval M return matrix
        % =================================================================         
        function M=get_matrix(dg_obj)           
           dg_obj.matrix(:)=dg_obj.value_list(:);           
           M=dg_obj.matrix;
        end
       
        % =================================================================
        %> @brief Update matrix property in object using current value_list
        %> vector from object.
        % =================================================================      
        function update_matrix(dg_obj)           
           dg_obj.matrix(:)=dg_obj.value_list(:);                                 
        end
        
        % =================================================================        
        %> @brief Update value_list vector property in object using current
        %> matrix property from object.
        % =================================================================
        function update_value_list(dg_obj)
           dg_obj.value_list(:)=dg_obj.matrix(:);                         
        end
        
        % =================================================================
        %> @brief Set display threshold. Function is overload. Two modes are 
        %> available: 'thresholds' or 'auto'.
        %>
        %> @param varargin{1} mode - 'auto' or 'threshold'
        %> @param varargin{2} value of lower threshold (if threshold mode enable else without this field)
        %> @param varargin{3} value of upper threshold (if threshold mode enable else without this field)       
        % =================================================================
       function set_display_thresholds(varargin)
           
           % auto
           if nargin==2
                dg_obj=varargin{1};
                mode=varargin{2};
                if (strcmp(mode,'auto'))
                    dg_obj.threshold_mode='auto'; 
                else
                    error 'Incorrect threshold mode'
                end
                
           % thresholds
           elseif nargin==4
                dg_obj=varargin{1};
                mode=varargin{2};
                lt_tmp=varargin{3};
                ut_tmp=varargin{4};
                
                if (strcmp(mode,'thresholds'))
                    dg_obj.threshold_mode='thresholds'; 
                    
                    if(lt_tmp>ut_tmp)
                         error 'lower threshold value is greater than higher';
                    elseif (lt_tmp==ut_tmp)
                        error 'lower threshold value is equal higher'
                    end                          
                    dg_obj.lt=lt_tmp;
                    dg_obj.ut=ut_tmp;
                    dg_obj.threshold_mode=mode;
                    
                else
                    error 'Incorrect threshold mode'
                end                                
                
           else
               error 'Incorrect number of input elements'
           end
           
        end     
    
        % =====================================================================
        %> @brief Overload matlabs function use to display. Display current
        %> value_list (reshaped into matrix form)- graphical representation .
        % =====================================================================
        % function display(dg_obj)
        display(dg_obj);
        
        % =====================================================================
        %> @brief Overload matlabs function use to add objects to each other. Add discretization
        %> grid objects = add objects value_list vectors and create new grid object
        %> (object has the same dimension but with new value_list vector).
        %>
        %> Dimension of p and q must be the same.
        %> @param p discretization grid object
        %> @param q discretization grid object
        %> @retval r discretization grid object
        % =====================================================================
        % function r = plus( p,q )
        r = plus( p,q );
        
   end % methods
   
end % class

