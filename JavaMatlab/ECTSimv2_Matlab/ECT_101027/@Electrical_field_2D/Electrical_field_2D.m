%> @file Electrical_field.m
%> @brief Compute two dimensional sensitivity, potential
%> maps.
% ======================================================================
%> @brief Compute two dimensional sensitivity and potential
%> maps for 2D sensor and phantom. Compute capacitances.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Electrical_field_2D < Electrical_field

   properties (SetAccess=public)
       %> discretization grid object, sum of sensor and phantom permittivity grids       
       discretization_grid_sensor_and_phantom;
       %> sensor object
       sensor;
       %> permitivity distribution object (phantom use to solve forward problem)
       permittivity_distribution;
       %> potential distribution maps (forward problem output)
       potential_distribution_maps;
       %> sensitivity maps (vector of full maps)
       S_map; 
       %> resized sensitivity single matrix
       S_resize 
       %> vector resize sensitivity  maps
       S_map_resize;
       %> capacitance [vector]
       C;
       %> rescale permittivity distribution from FOV (matrix)
       Eps_fovImgToReconstruction_map;
       %> rescale permittivity distribution from FOV (vector)
       Eps_fovImgToReconstruction;   
       %> number of sensitivity maps
       sens_matrix_num;
       %> number of grid side size [grid elements-pixels]
       discret_matrix_size;
       %> discrete side size of simulation dimension
       simulation_discret_matrix_size;
       %> number of electrodes
       number_of_electrodes;
       %> normalized rescale sensitivity full size single matrix
       Sn_resize;
   end
   
   properties (SetAccess=private)
       %> grid use to temporary computing
       discretization_grid; 
       %> index use to potential computing
       pidx;   
       %> maximal length of pidx index
       max_len_pidx;
       %> index to first col of pidx where boundary is set
       iidx;
       %> vector of boundary maps
       B_map;
       %> number of measurement
       measurement_count;
       %> permittivity map (contain merged sensor and phantom permittivty map)
       eps_map;
       %> flag use to set electrode combination (with or without repeat)
       measurements_all;
       %> full size sensitivity single matrix
       S;
       %> full size single normalized sensitivity matrix
       Sn; 
       %> method of creating potential matrix (gauss or kirchoff(use if you know how))
       pot_method       
       %> vector of normalized sensitivity maps
       Sn_map;           
       %> capacitance error amplitude e.g. error_V = 0.001 - 1 mV or 'none'
       error_V='none';
       %> capacitance error range e.g. range_V = 10 - 10 V or 'none'
       range_V='none';
   end
   
   methods (Access=public)
       
         % ================================================================
         %> @brief Constructor. Overload.       
         %>         
         %> @param First:varargin{1} sensor object
         %> @param First:varargin{2} permittivity_distribution object
         %> @param First:varargin{3} side size of square simulation matrix         
         %> @param Second:varargin{1} sensor object
         %> @param Second:varargin{2} permittivity_distribution object
         %> @param Second:varargin{3} side size of square simulation matrix
         %> @param Second:varargin{4} capacitance error amplitude e.g. error_V = 0.001 - 1 mV or 'none'
         %> @param Second:varargin{5} capacitance error range e.g. range_V = 10 - 10 V or 'none'                        
         %> @param Second:varargin{6} method use to compute potential maps 'gauss' or 'kirchoff' (set if you know how to use it)                                 
         %>
         %> @return instance of the Electrical_field_2D class.
         % ================================================================
         function ef_obj = Electrical_field_2D(varargin)           
          if nargin == 0 ; % no input arguments
          elseif isa(varargin{1},'Electrical_field_2D')
            ef_obj = varargin{1}; % copy constructor
            display 'copy constructor Electrical_field_2D'
            return;          
          else
             switch(nargin)
                case 3, 
                    display 'creating electrical field'
                    if((isa(varargin{1},'Sensor_2D')==1)&&(isa(varargin{2},'Permittivity_distribution_2D')==1))
                        display 'creating Sensor_2D'
                        ef_obj.sensor=varargin{1};
                        ef_obj.permittivity_distribution=varargin{2};
                        ef_obj.simulation_discret_matrix_size=varargin{3};
                        ef_obj.pot_method='gauss';
                        ef_obj.error_V='none';
                        ef_obj.range_V='none';
                    end
                case 6, 
                    display 'creating electrical field'
                    if((isa(varargin{1},'Sensor_2D')==1)&&(isa(varargin{2},'Permittivity_distribution_2D')==1))
                        display 'creating Sensor_2D'
                        ef_obj.sensor=varargin{1};
                        ef_obj.permittivity_distribution=varargin{2};
                        ef_obj.simulation_discret_matrix_size=varargin{3};
                        ef_obj.error_V=varargin{4};
                        ef_obj.range_V=varargin{5};
                        ef_obj.pot_method=varargin{6}; % 'gauss or kirchoff'
                    end
                    
             otherwise
                    display 'no input elements';                   
             end   
                    
                        ms=ef_obj.sensor.discretization_grid.matrix_size_mm;
                        gs=ef_obj.sensor.discretization_grid.grid_size_mm;
                        ef_obj.discretization_grid=Discretization_grid_2D_square(ms,gs);
                        
                        ef_obj.discretization_grid=ef_obj.sensor.discretization_grid+ef_obj.permittivity_distribution.Discretization_grid_perm;
                        
                        ef_obj.iidx=1:ef_obj.discretization_grid.discret_matrix_size*ef_obj.discretization_grid.discret_matrix_size;
                        ef_obj.iidx=ef_obj.iidx.*0;                                        
                                                                                               
                        len_sens_elements=length(ef_obj.sensor.vector_sensor_elements);
                        
                        for n=1:len_sens_elements
                            ef_obj.max_len_pidx=ef_obj.max_len_pidx + length(ef_obj.sensor.vector_sensor_elements(n).point_list); 
                        end
                        
                        tmp=1:ef_obj.max_len_pidx;
                        tmp=tmp'.*0;
                        ef_obj.pidx(:,1)=tmp;
                        ef_obj.pidx(:,2)=tmp;
                        ef_obj.pidx(:,3)=tmp;
                        ef_obj.pidx(:,4)=tmp;
                        
                        
                        % create pidx only for elements inside screen and
                        % for screen
                        size(1,1)=ef_obj.sensor.discretization_grid.discret_matrix_size;
                        size(1,2)=ef_obj.sensor.discretization_grid.discret_matrix_size;
                                                
                        ef_obj.number_of_electrodes=0;
                        
                        for i=1:len_sens_elements
                                                                                   
                            vol=ef_obj.sensor.vector_sensor_elements(i).voltage;     
                            
                            if(strcmp(vol,'none'))
                                pot_flag = 0;   % not boundary condition
                            else
                                pot_flag = 1;   % boundary condition
                            end

                            el_name=ef_obj.sensor.vector_sensor_elements(i).element_name;
                            
                            if(strcmp(el_name,'electrode'))
                                ef_obj.number_of_electrodes=ef_obj.number_of_electrodes+1;
                                ef_obj.B_map(:,:,ef_obj.number_of_electrodes)=ef_obj.sensor.vector_sensor_elements(i).discretization_grid_of_voltage.get_matrix();                                                                
                            end
                                                                 
                                pl=ef_obj.sensor.vector_sensor_elements(i).point_list;
                                ind=length(ef_obj.pidx);
                                for k=1:length(pl)
                                    % linear index
                                    ef_obj.pidx(ind+k,1)=pl(k);

                                    [x,y]=ind2sub(size,pl(k));

                                    ef_obj.pidx(ind+k,2)=x;
                                    ef_obj.pidx(ind+k,3)=y;
                                    ef_obj.pidx(ind+k,4)=pot_flag;
                                end
                          
                        end  % end for all elements in the sensor
                        
                        % pidx must be in ascending order
                        ef_obj.pidx=sortrows(ef_obj.pidx,1);
                                                     
                            for m=1:length(ef_obj.pidx)
                                ef_obj.iidx(ef_obj.pidx(m))=m;
                            end                            
                                                                       
                        % number of measurements (electrode pairs) all=1 with, all=0 without repeats
                            
                            ef_obj.measurements_all = 0;
                        if ef_obj.measurements_all==1 % electrode combinations
                            ef_obj.measurement_count = ef_obj.number_of_electrodes*(ef_obj.number_of_electrodes-1);  % number of measurement 
                        else
                            ef_obj.measurement_count = ef_obj.number_of_electrodes*(ef_obj.number_of_electrodes-1)/2;  % number of measurement 
                        end

                        % should be equal to sensor.measurement_count
                        ef_obj.sens_matrix_num = ef_obj.measurement_count;  % number of sub sensitivity matrixs
                            
                            
                       ef_obj.discret_matrix_size=ef_obj.permittivity_distribution.Discretization_grid_perm.discret_matrix_size;
                       
                       % adding phantom do sensor discretization grid,
                       % phantom should be merged with FOV (FOV values included)
                       point_list=ef_obj.permittivity_distribution.fov_indicies_vector;
                       ef_obj.discretization_grid_sensor_and_phantom=ef_obj.sensor.discretization_grid;                                                                     
                       ef_obj.discretization_grid_sensor_and_phantom.value_list(point_list)=ef_obj.permittivity_distribution.Discretization_grid_perm.value_list(point_list);
                      
                       ef_obj.eps_map=ef_obj.discretization_grid_sensor_and_phantom.get_matrix();
                       
                       ef_obj.potential_distribution_maps=ef_obj.potential_distrib(ef_obj.pot_method);
                       ef_obj.S_map=ef_obj.sens_matrix(ef_obj.potential_distribution_maps,1);
                                                                                            
                       %reshape;
                        ef_obj.S = reshape(ef_obj.S_map, ef_obj.discret_matrix_size*ef_obj.discret_matrix_size,  ef_obj.sens_matrix_num)';% ?
                                         
                        ef_obj.Sn = ef_obj.sens_norm_lbp(ef_obj.S);  
                       
                        
                        ef_obj.Sn_map = reshape(ef_obj.Sn', ef_obj.discret_matrix_size, ef_obj.discret_matrix_size, ef_obj.sens_matrix_num);% ?
                        
                   
                    simulation_matrix=ef_obj.permittivity_distribution.Discretization_grid_perm.get_matrix();
        
                    ef_obj.C = ef_obj.projections(ef_obj.error_V,ef_obj.range_V);

                    sim_discret_matrix_size=ef_obj.simulation_discret_matrix_size;
                    ef_obj.Eps_fovImgToReconstruction_map = ef_obj.getFOV(ef_obj.sensor,sim_discret_matrix_size, simulation_matrix, 1,'bilinear');                    
             
                    
                    ef_obj.Eps_fovImgToReconstruction=reshape(ef_obj.Eps_fovImgToReconstruction_map,numel(ef_obj.Eps_fovImgToReconstruction_map),1);
                    
                    ef_obj.S_resize = ef_obj.get_resize_sensitivity(sim_discret_matrix_size,'bilinear');
                    
                    ef_obj.Sn_resize = ef_obj.sens_norm_lbp(ef_obj.S_resize);  
                           
          end
         
         end
         
         % ================================================================
         %> @brief Draw values of all capacitances. Use current figure.
         % ================================================================
         function draw_capacitances(ef_obj)
          
            plot(ef_obj.C);                                       
            title('Capacitances between electrode pairs');
            xlabel('Pair of electrodes');
            ylabel('Capacitance [arbitrary units]');
         end
         
         % ================================================================        
         %> @brief Draw permittivity distribution for sensor and phantom. Two modes  
         %> available: auto or thresholds.
         %>
         %> @param varargin{1} mode - auto or threshold
         %> @param varargin{2} value of lower threshold (if threshold mode enable else witout this field)
         %> @param varargin{3} value of upper threshold (if threshold mode enable else witout this field)       
         % ================================================================        
         function draw_eps_map(varargin)  
           
           % default - auto
           if nargin==1
               ef_obj=varargin{1};
               ef_obj.discretization_grid_sensor_and_phantom.set_display_thresholds('auto');
               ef_obj.discretization_grid_sensor_and_phantom
                                              
           % thresholds
           elseif nargin==4
                ef_obj=varargin{1};
                mode=varargin{2};
                lt_tmp=varargin{3};
                ut_tmp=varargin{4};
                
                if (strcmp(mode,'thresholds'))                    
                    ef_obj.discretization_grid_sensor_and_phantom.set_display_thresholds('thresholds',lt_tmp,ut_tmp);
                    ef_obj.discretization_grid_sensor_and_phantom
                else
                    error 'Incorrect threshold mode'
                end                                
                
           else
               error 'Incorrect number of input elements'
           end                  
             
         end
          
         % ================================================================         
         %> @brief Draw potential map for one or all electrodes.
         %>
         %> @param el electrode number - draw set potential map or 'all' - draw all potential maps
         % ================================================================         
         function [] = draw_potential(ef_obj,el) 
                
             if (strcmp(el,'all'))
                ef_obj.draw_potential_(ef_obj.potential_distribution_maps(:,:,el), el);
             else
                ef_obj.draw_potential_(ef_obj.potential_distribution_maps(:,:,el));
             end
           
         end
         
         % ================================================================         
         %> @brief Draw one sensitivity map or all maps. 
         %>
         %> @param val sensitivity map number - draw set sensitivity map or 'all' - draw all sensitivity maps
         % ================================================================         
         function [] = draw_sensitivity(ef_obj,val)
             
             if(strcmp(val,'all'))
                           
                for sm=1:1:ef_obj.sens_matrix_num
                    figure;
                    ef_obj.draw_sensitivity_(ef_obj.S_map(:,:,sm)); % draw only for first electrode                 
                end
                                 
             else      
                 ef_obj.draw_sensitivity_(ef_obj.S_map(:,:,val));       
             end   

         end
         
         % =================================================================        
         %> @brief Function gets full size sensitivity single matrix then resize
         %> each map. Return resize sensitivity single matrix and set this
         %> matrix into object.
         %>
         %> @param image_matrix_size size of matrix side (resize matrix size)
         %> @param method see imresize (image processsing toolbox)
         %> @retval S_resize vector of resized sensitivity maps
         % ================================================================         
         function S_resize = get_resize_sensitivity(ef_obj,image_matrix_size,method)  
             S=ef_obj.S;
             [r,c]=size(S);
             x=ef_obj.discretization_grid.number_of_x_axis_pixel;
             y=ef_obj.discretization_grid.number_of_y_axis_pixel;
             for i=1:1:r
                 S_vector=S(i,:);                 
                 S_single = reshape(S_vector,y,x);
                 fovSensR = ef_obj.getFOV(ef_obj.sensor,image_matrix_size, S_single, 1,method);
                 S_single = reshape(fovSensR,1,numel(fovSensR));
                 S_resize(i,:)=S_single(:);
                 res=reshape(S_single,image_matrix_size,image_matrix_size);
                 S_map_resize(:,:,i)=res(:,:);
             end
             ef_obj.S_resize=S_resize;
             ef_obj.S_map_resize=S_map_resize;
             return
         end
        
         % ================================================================
         %> @brief Draw sum of sensitivity maps.         
         % ================================================================
         function [] = draw_sum_S_map(ef_obj)
            map=sum(ef_obj.S_map,3);
            mesh(map);
            set(gca,'PlotBoxAspectRatio',[1,1,1]);
            title('Full Size Sensitivity Maps Sum');
            zlabel('Sensitivity [arbitrary units]');
            xlabel('grid:x');
            ylabel('grid:y');
         end
         
         % ================================================================
         %> @brief Draw inverse sum of sensitivity maps.         
         % ================================================================
         function [] = draw_inv_S_map(ef_obj,u);
            S=ef_obj.S;
                    
            mtx_size=ef_obj.discret_matrix_size;     
            sens_mtx_number=ef_obj.sens_matrix_num;
            iS = S'/(S*S' + u*diag(diag(S*S')));
            res=reshape(iS,[mtx_size mtx_size sens_mtx_number]);
            wyn=sum(res,3);
            mesh(wyn)
            set(gca,'PlotBoxAspectRatio',[1,1,1]);
            title('Inverse Full Size Sensitivity Maps Sum');
            zlabel('Sensitivity [arbitrary units]');
            xlabel('grid:x');
            ylabel('grid:y');
         end
         
         % ================================================================
         %> @brief Draw sum of resize sensitivity maps.
         % ================================================================
         function [] = draw_sum_resize_S_map(ef_obj)
            map=sum(ef_obj.S_map_resize,3);
            mesh(map);
            set(gca,'PlotBoxAspectRatio',[1,1,1]);
            title('Resize Sensitivity Maps Sum');
            zlabel('Sensitivity [arbitrary units]');
            xlabel('grid:x');
            ylabel('grid:y');
         end
         
         % ================================================================
         %> @brief Draw sum of potential maps.
         % ================================================================
         function [] = draw_sum_pot_map(ef_obj)
            map_pot=sum(ef_obj.potential_distribution_maps,3);
            mesh(map_pot);
            set(gca,'PlotBoxAspectRatio',[1,1,1]);                                                  
            title('Potential Maps Sum');
            zlabel('Voltage [V]');
            xlabel('grid:x');
            ylabel('grid:y');
         end
         
         % =====================================================================
         %> @brief Draw resize sensitivity map.
         %>
         %> @param val sensitivity map number or 'all' - draw all maps
         %> @param image_sizex x dimension size of rescale map (x dimension of output drawing)
         %> @param image_sizey y dimension size of rescale map (y dimension of output drawing) 
         %> @param new_figure 1-create new figure 0-don't creat new figure         
         % =====================================================================
         function [] = draw_resize_sensitivity(ef_obj,val,image_sizex,image_sizey,new_figure)
            [r,c]=size(ef_obj.S_resize);
            if(strcmp(val,'all'))                
                for i=1:1:r                    
                    tmp=ef_obj.S_resize(i,:);
                    img=reshape(tmp,image_sizey,image_sizex);
                    if(new_figure==1)
                        figure;
                    end
                    image(img,'cdatamapping','scaled');
                    drawnow;                    
                    set(gca,'PlotBoxAspectRatio',[1,1,1]);
                end
            else
                if(val<=r && val > 0 )
                    tmp=ef_obj.S_resize(val,:);
                    img=reshape(tmp,image_sizey,image_sizex);
                    if(new_figure==1)
                        figure;
                    end
                    image(img,'cdatamapping','scaled');
                    set(gca,'PlotBoxAspectRatio',[1,1,1]);
                else
                    display 'out of index';
                end                
            end            
            % end 'main' if
         end
         % end function draw_resize_sensitivity
        
        % =========================================================================
        %> @brief returns FOV part of given image
        %>
        %> @param sensor sensor object
        %> @param image_matrix_size side size of input image
        %> @param simulation_phantom_matrix side size of rescale image
        %> @param rescale flag if rescale to reconsruction matrix size have to be done
        %> 0 no, 1 yes (default value is 1)
        %> @param method  interpolating method for image rescaling (default is bilinear).
        %> For more see imresize help.
        %>
        %> @retval fovImg rescale permittivity distribution of FOV
        % =========================================================================
        %function [fovImg] = getFOV(ef_obj,sensor,image_matrix_size, simulation_phantom_matrix, rescale, method)
         [fovImg] = getFOV(ef_obj,sensor,image_matrix_size, perm_distrib, rescale, method);
        
        % =========================================================================
        %> @brief putFOV returns image where given fov was put into given image
        %>
        %> @param sensor        sensor object
        %> @param perm_distrib  permittivity distribution object
        %> @param fovImgR       side size of reconstruction image
        %> @param method        interpolating method for image rescaling (default is bilinear).
        %>                      For more see imresize help.
        %> @param fillBorder    flag, 0-1, extrapolate borders of fov to fill whole fov
        %>                      in simulation resolution (0 no fill, 1 fill, default 0)
        %> @retval img          resize image
        % =========================================================================
        %function [img] = putFOV(ef_obj,sensor, perm_distrib, fovImgR, method,fillBorder)
         [fovImg] = putFOV(ef_obj,sensor, perm_distrib, fovImgR, method,fillBorder);
         
        % =====================================================================
        %> @brief potential_distrib calculates potential distrubution 
        %>
        %> @param method - method of calculation of coefficients
        %>         'gauss' - (default) using gauss law (integral eqation)
        %>         'kirchhof' - calculating potential using capacitor mesh and
        %>          Kirchhof law
        %>         'finite difference' - not implemented
        %>
        %> @retval V potential distribution vector of maps
        % =====================================================================
        %function [V]=potential_distrib(ef_obj,method)
        V = potential_distrib(ef_obj,method);   
        
   end % methods
   
   methods(Access=private)
                               
        
        % =====================================================================
        %> @brief pot_matrix creates matrix for potential equation using list of
        %> points
        %>
        %> @param discret_matrix_size    side size of matrix
        %> @param potential_points_idx   index use to potential computing
        %> @param potential_points_iidx  index to first col of pidx where boundary is set
        %> @param P                      map of permittivity distribution
        %> @param method - method of calculation of coefficients
        %>         'gauss' - (default) using gauss law (integral eqation)
        %>         'kirchhof' - calculating potential using capacitor mesh and
        %>          Kirchhof law
        %>         'finite difference' - not implemented
        %>
        %> @retval A(pixnum,pixnum) where pixnum is the number of unknown potential points
        % =====================================================================
        %function A=pot_matrix(ef_obj,discret_matrix_size,potential_points_idx,potential_points_iidx,P,method)
        A = pot_matrix(ef_obj,discret_matrix_size,pidxx,iidx,eps_map,draw,method);
        
        % =====================================================================
        %> @brief solveLU performs backward step of Gauss elimination calculates potential distrubutions 
        %> using matrix A and many vectors of free elements (boundary conditions)
        %>
        %> @param m witdh of matrix band
        %> @param A  matrix of linear system for potential distribution
        %> @param B  vectors with boundary conditions
        %>
        %> @retval V potential matrix to solve
        % =====================================================================
        %function [V] = solveLU(ef_obj,m,A,B)
        [V] = solveLU(ef_obj,m,A,B);
        
        % =====================================================================
        %> @brief thomas2 creates upper triangular matrix using band diagonal
        %> structure of matrix
        %>
        %> @param rows       rows number of potential matrix 
        %> @param cols       cols number of potential matrix 
        %> @param A          potential matrix
        %> @param elnum      number of electrodes, number of columns in B matrix of free elements 
        %> @param B          boundary conditions - maps of applied voltage
        %>
        %> @retval A - upper triangular matrix
        %> @retval B - vector of free elements
        % =====================================================================
        %function [A,B] = thomas2(ef_obj,rows,cols,A,elnum,B)
        [A,B] = thomas2(ef_obj,rows,cols,A,elnum,B,draw);
        
        % =====================================================================
        %> @brief Draw potential distribution
        %>
        %> @param varargin{1} potential distribution map
        %> @param varargin{2} electrode num (optional)
        % =====================================================================
        %function[] = draw_potential_(varargin)
        [] = draw_potential_(ef_obj,V, num)
         
        % =====================================================================
        %> @brief sens_matrix calculates sensitivity matrix using potential maps for electrodes pairs
        %>
        %> @param V     potential map for one pair of electrodes
        %> @param draw  draw calculated map if ~= 0
        %> @retval S    sensitivity map
        % =====================================================================
        %function [S]=sens_matrix(ef_obj,V,draw)
        [S]=sens_matrix(ef_obj,V, draw)
        
        % =====================================================================
        %> @brief Calculates sensitivity map using reciprocity theorem and mutual impedance
        %>
        %> @param V1 potential map when first electrode is an application electrode
        %> @param V2 potential map when 2-nd  electrode is an application electrode
        %>
        %> @retval S sensitivity map
        % =====================================================================
        %function[S]=sens_map(ef_obj, V1, V2)
        [S]=sens_map(ef_obj, V1, V2)
        
        % =========================================================================
        %> @brief Draw sensitivity map for pair of electrodes
        %>
        %> @param S sensitivity map
        % =========================================================================
        %function[] = draw_sensitivity_(ef_obj,S)
        [] = draw_sensitivity_(ef_obj,S, el1, el2, draw)             
         
        % =====================================================================
        %> @brief Sens_norm_lbp normalize sensitivity matrix coefficients
        %>
        %> @param S sensitivity matrix
        %> @retval Sn normalized sensitivity matrix
        % =====================================================================
        %function [Sn]=sens_norm_lbp(ef_obj,S)
        [Sn] = sens_norm_lbp(ef_obj,S)
        
        % =====================================================================
        %> @brief Projections calculates capacitances to be measured with phantom
        %>
        %> @param error_V capacitance error amplitude e.g. error_V = 0.001 - 1 mV or 'none'
        %> @param range_V capacitance error range e.g. range_V = 10 - 10 V or 'none' 
        %>
        %> @retval out return value of this method
        % =====================================================================
        %function [C] = projections(ef_obj,error_V,range_V)
        [C] = projections(ef_obj,error_V,range_V); 
        
   end
      
end 
