%> @file Phantom_generator_2D.m
%> @brief Two dimensional phantom (cirlces) generator.
% ======================================================================
%> @brief Two dimensional phantom (cirlces) generator.
%>
%> Instance of this class generates phantoms (distibution of circle objects).
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Phantom_generator_2D < Phantom_generator

   properties (SetAccess='public')
       %> diameter of field of view
       fov_diameter;       
       %> number of elements in discretization grid
       discretization_grid_pixels_number;
       %> permittivity distribution of phantom (discretization grid object)
       discretization_grid;
       %> phantom name
       phantom_name;       
       %> permittivity value for all rods (circles)
       eps;       
       %> phantom permittivity distribution map
       ph_map;
       %> point list of phantom - linear index
       point_list;       
       %> vector of rods (circles) number
       indx;
       %> diameter of single rod (circle) [mm]
       d_mm;
       %> diameter of single node [mm]
       D_mm; 
   end
   
   properties (SetAccess='private')
       %> discretization grid side size in milimeters
       discretization_grid_mm;
       %> phantom rotate [degree]
       beta;
       %> rod (circle) list
       list;
       %> diameter of rod (circle) [number of grid element-'pixels'] 
       d=1;
       %> node size [number of grid element-'pixels']
       D=2;    
   end
       
   methods (Access=public)
       % ======================================================================
       %> @brief Constructor is overload. 
       
       %> @param First:varargin{1} field of view (sensor element object) 
       %> @param First:varargin{2} phantom_name='rods_indx' 
       %> @param First:varargin{3} beta [degree] phantom rotate 
       %> @param First:varargin{4} permittivity value for all rods (circles)
       %> @param First:varargin{5} diameter of rod (circle) [milimeters]
       %> @param First:varargin{6} node size [milimeters]
       %> @param First:varargin{7} vector of rods (circle) number
       
       %> @param Second:varargin{1} field of view (sensor element object) 
       %> @param Second:varargin{2} phantom_name='ask_me_all' 
       
       %> @param Second:varargin{1} field of view (sensor element object) 
       %> @param Second:varargin{2} phantom_name='ask_me_less' 
       %> @param Second:varargin{3} beta [degree] phantom rotate 
       %> @param Second:varargin{4} permittivity value for all rods (circles)
       %> @param Second:varargin{5} diameter of rod (circle) [milimeters]
       %> @param Second:varargin{6} node size [milimeters]
       
       %> @param Third:varargin{1} field of view (sensor element object) 
       %> @param Third:varargin{2} phantom_name='uniform' 
       %> @param Third:varargin{3} permittivity value for all points in field of
       %>                    view
       %> @return instance of the Phantom_generator_2D class.
       % =====================================================================
       function ph_obj = Phantom_generator_2D(varargin)           
          if nargin == 0 ; % no input arguments
          elseif isa(varargin{1},'Phantom_generator_2D')
            ph_obj = varargin{1}; % copy constructor
            display 'copy constructor Phantom_generator_2D'
            return;          
          else
             switch(nargin)
                 case 2,
                    fov=varargin{1};
                    ph_obj.phantom_name=varargin{2};                                                                                
                    
                    if strcmp(ph_obj.phantom_name,'ask_me_all')
                        ph_obj.phantom_name='ask_me';
                    
                    A=imread('phantom_scheme.png');
                    imshow(A);
                    
                    % phantom angle
                    prompt = {'Phantom angle rotate[degree]'};
                    dlg_title = 'Input for phantom';
                    num_lines = 1;
                    def = {'0','hsv'};
                    pha_ang = inputdlg(prompt,dlg_title,num_lines,def);
                    pha_ang=str2double(pha_ang);
                    
                    if (isnumeric(pha_ang))                                                
                        pha_ang=mod(pha_ang,360);
                    else    
                        error('This is not a number');
                    end
                    
                    ph_obj.beta=pha_ang;
                    
                    % phantom eps
                    prompt = {'Phantom epsilon'};
                    dlg_title = 'Input for phantom';
                    num_lines = 1;
                    def = {'10','hsv'};
                    pha_eps = inputdlg(prompt,dlg_title,num_lines,def);
                    pha_eps=str2double(pha_eps);
                    
                    if (isnumeric(pha_eps))                                                                        
                    else    
                        error('This is not a number');
                    end
                    
                    ph_obj.eps=pha_eps;
                    
                    %- diameter of circle
                    prompt = {'Phantom d_mm from picture [mm]'};
                    dlg_title = 'Input for phantom';
                    num_lines = 1;
                    def = {'1','hsv'};
                    pha_diam_circ = inputdlg(prompt,dlg_title,num_lines,def);
                    pha_diam_circ=str2double(pha_diam_circ);
                    
                    if (isnumeric(pha_eps))                                                                        
                    else    
                        error('This is not a number');
                    end                                        
                    
                    ph_obj.d_mm=pha_diam_circ;          
                    
                    %- node size
                    prompt = {'Phantom D_mm from picture [mm]'};
                    dlg_title = 'Input for phantom';
                    num_lines = 1;
                    def = {'2','hsv'};
                    pha_diam_node = inputdlg(prompt,dlg_title,num_lines,def);
                    pha_diam_node=str2double(pha_diam_node);
                    
                    if (isnumeric(pha_eps))                                                                        
                    else    
                        error('This is not a number');
                    end                                        
                                        
                    ph_obj.D_mm=pha_diam_node;    
                    
                    %---
                    gs_mm=fov.discretization_grid_of_element.grid_size_mm;
                    
                    ph_obj.d=ph_obj.d_mm;
                    ph_obj.D=ph_obj.D_mm;

                    ph_obj.fov_diameter=fov.rmax_mm*2;
                    
                    if ph_obj.d>ph_obj.D
                        error('circle (d) is bigger than node (D)')
                    elseif ph_obj.d>ph_obj.fov_diameter
                        error('circle (d) is bigger than FOV diameter')
                    elseif ph_obj.D>ph_obj.fov_diameter
                        error('node (D) is bigger than FOV diameter')                        
                    end
                        
                    ph_obj.discretization_grid_mm=fov.discretization_grid_of_element.matrix_size_mm;
                    ph_obj.discretization_grid_pixels_number=fov.discretization_grid_of_element.number_of_x_axis_pixel;                    
                    
                    ph_obj.discretization_grid=Discretization_grid_2D_square(fov.discretization_grid_of_element.matrix_size_mm, fov.discretization_grid_of_element.grid_size_mm);
              
                    
                    
                     ph_obj.list = ph_obj.phantom_rod_list(ph_obj.fov_diameter, ph_obj.d,ph_obj.D, ph_obj.beta, ph_obj.eps);                     
                    
                    
                     [ph_obj.ph_map]= ph_obj.phantom_rods(ph_obj.discretization_grid_mm,ph_obj.discretization_grid_pixels_number, ph_obj.list, fov.permittivity);
                     
                     image(ph_obj.ph_map,'cdatamapping','scaled');
                     set(gca,'PlotBoxAspectRatio',[1,1,1]);
                     
                     ph_obj.discretization_grid.matrix=ph_obj.ph_map;
                     ph_obj.discretization_grid.update_value_list();
                     
                     ph_obj.point_list=find(ph_obj.discretization_grid.matrix==ph_obj.eps);
                     
                    else
                        error('unknown mode');
                    end
                 
                case 6,   
                    fov=varargin{1};
                    ph_obj.phantom_name=varargin{2};
                    ph_obj.beta=varargin{3};
                    ph_obj.eps=varargin{4};
                    ph_obj.d_mm=varargin{5};   %- diameter of (node) circle        
                    ph_obj.D_mm=varargin{6};   %- node size 
                    
                    gs_mm=fov.discretization_grid_of_element.grid_size_mm;

                    
                    ph_obj.d=ph_obj.d_mm;
                    ph_obj.D=ph_obj.D_mm;

                    ph_obj.fov_diameter=fov.rmax_mm*2;
                    
                    if ph_obj.d>ph_obj.D
                        error('circle (d) is bigger than node (D)')
                    elseif ph_obj.d>ph_obj.fov_diameter
                        error('circle (d) is bigger than FOV diameter')
                    elseif ph_obj.D>ph_obj.fov_diameter
                        error('node (D) is bigger than FOV diameter')                        
                    end
                    
                    if strcmp(ph_obj.phantom_name,'ask_me')
                        
                    
                    ph_obj.discretization_grid_mm=fov.discretization_grid_of_element.matrix_size_mm;
                    ph_obj.discretization_grid_pixels_number=fov.discretization_grid_of_element.number_of_x_axis_pixel;                    
                    
                    ph_obj.discretization_grid=Discretization_grid_2D_square(fov.discretization_grid_of_element.matrix_size_mm, fov.discretization_grid_of_element.grid_size_mm);
              
                    
                    
                     ph_obj.list = ph_obj.phantom_rod_list(ph_obj.fov_diameter, ph_obj.d,ph_obj.D, ph_obj.beta, ph_obj.eps);                     
                    
                    
                     [ph_obj.ph_map]= ph_obj.phantom_rods(ph_obj.discretization_grid_mm,ph_obj.discretization_grid_pixels_number, ph_obj.list, fov.permittivity);
                     
                     image(ph_obj.ph_map,'cdatamapping','scaled');
                     set(gca,'PlotBoxAspectRatio',[1,1,1]);
                     
                     ph_obj.discretization_grid.matrix=ph_obj.ph_map;
                     ph_obj.discretization_grid.update_value_list();
                     
                     ph_obj.point_list=find(ph_obj.discretization_grid.matrix==ph_obj.eps);
                     
                    else
                        error('unknown mode');
                    end
                 case 7,
                     
                    fov=varargin{1};
                    ph_obj.phantom_name=varargin{2};
                    ph_obj.beta=varargin{3};
                    ph_obj.eps=varargin{4};
                    ph_obj.d_mm=varargin{5};   %- diameter of (node) circle        
                    ph_obj.D_mm=varargin{6};   %- node size 
                    ph_obj.indx=varargin{7};
                    
                    gs_mm=fov.discretization_grid_of_element.grid_size_mm;

                    
                    ph_obj.d=ph_obj.d_mm;
                    ph_obj.D=ph_obj.D_mm;
                    
                    
                    ph_obj.fov_diameter=fov.rmax_mm*2;
                    
                    if ph_obj.d>ph_obj.D
                        error('circle (d) is bigger than node (D)')
                    elseif ph_obj.d>ph_obj.fov_diameter
                        error('circle (d) is bigger than FOV diameter')
                    elseif ph_obj.D>ph_obj.fov_diameter
                        error('node (D) is bigger than FOV diameter')                        
                    end                                    
                    
                    if strcmp(ph_obj.phantom_name,'rods_indx')
                                            

                    ph_obj.discretization_grid_mm=fov.discretization_grid_of_element.matrix_size_mm;
                    ph_obj.discretization_grid_pixels_number=fov.discretization_grid_of_element.number_of_x_axis_pixel;                    
                    
                    ph_obj.discretization_grid=Discretization_grid_2D_square(fov.discretization_grid_of_element.matrix_size_mm, fov.discretization_grid_of_element.grid_size_mm);
                                                      
                     ph_obj.list = ph_obj.phantom_rod_list(ph_obj.fov_diameter, ph_obj.d,ph_obj.D, ph_obj.beta, ph_obj.eps);                     
                    
                     
                     [ph_obj.ph_map]= ph_obj.phantom_rods(ph_obj.discretization_grid_mm,ph_obj.discretization_grid_pixels_number, ph_obj.list, fov.permittivity);
                                                              
                     ph_obj.discretization_grid.matrix=ph_obj.ph_map;
                     ph_obj.discretization_grid.update_value_list();
                     ph_obj.point_list=find(ph_obj.discretization_grid.matrix==ph_obj.eps);
                    else
                        error('unknown mode');
                    end
                     
                  case 3,
                    fov=varargin{1};
                    ph_obj.phantom_name=varargin{2};                    
                    ph_obj.eps=varargin{3};
                    
                    if strcmp(ph_obj.phantom_name,'uniform')
                             
                        ph_obj.discretization_grid_mm=ph_obj.fov_diameter;
                        ph_obj.discretization_grid_pixels_number=fov.discretization_grid_of_element.number_of_x_axis_pixel;                    
                    
                        ph_obj.discretization_grid=Discretization_grid_2D_square(fov.discretization_grid_of_element.matrix_size_mm, fov.discretization_grid_of_element.grid_size_mm);
                                                


                    vals=ones(1,numel(fov.point_list))*ph_obj.eps;
                    ph_obj.discretization_grid.value_list(fov.point_list)=vals;
                    ph_obj.point_list=fov.point_list;
                    else
                        error('unrecognized phantom name'); 
                    end
                        
                   
                 otherwise
                    display 'no input elements';
             end             
          end
       end       

   end
   
   methods (Access=private)
       
       % ======================================================================
       %> @brief % phantom_rod_list generates list of structures for ellipse objects
       %> structure: 
       %> center of ellipse, axes, ellipse rotation, permittivity value, polar
       %> coordinates of ellipse
       %>
       %> @param imsize diameter of field of view  
       %> @param beta object rotation (use to fit numeric to real object)[mm]
       %> @param d circle [mm]
       %> @param D node [mm]
       %> @param eps_value permittivity value for all rods
       %>
       %> @retval el list of structures for rod parameters
       % =====================================================================
       %function [el] = phantom_rod_list(phobj,imsize,d,D, beta, eps_value)
       [el] = phantom_rod_list(phobj,imsize,d_mm,D_mm, beta, eps_value);
       
       % =====================================================================
       %> @brief hexplot plots circles in hexagonal grid
       %>
       %> @param x0 x position of grid center, (x,0) - center of image
       %> @param y0 y position of grid center, (0,y) - center of image
       %> @param sizeX x side size of image [mm]
       %> @param sizeY y side size of image [mm]
       %> @param d diameter of (node) circle
       %> @param D node size
       %> @param ang1 grid rotation
       %> @param mode 'polar' plots all circles with polar coordinates
       %>             'cart'  plots all circles with carthesian coordinates
       %>             'index' plots all circles with index
       %>             'rods'  plots rods
       %>             'rods2' plots all circles and rods
       % =====================================================================
       %function hexplot(phobj,x0,y0,sizeX,sizeY,d,D,ang1,mode,indx)
       hexplot(phobj,x0,y0,sizeX,sizeY,d,D,ang1,mode,indx);
       
       % =====================================================================
       %> @brief Draw circle.
       %>
       %> @param xc center of circle - x coordinate
       %> @param yc center of circle - y coordinate
       %> @param d diameter
       %> @param line line - display parameter  
       %> @param points points - display parameter
       %> @retval ret return value of this method
       % =====================================================================
       %function circle(phobj,xc,yc,d,line,points)
       circle(phobj,xc,yc,d,line,points)
       
       % ======================================================================
       %> @brief Hexgrid generates list of nodes of hexagonal grid 
       %>
       %> @param x0 x position of grid center, (x,0) - center of image
       %> @param y0 y position of grid center, (0,y) - center of image
       %> @param sizeX x side size of image [mm]
       %> @param sizeY y side size of image [mm]
       %> @param d  diameter of (node) circle 
       %> @param D  node size 
       %> @param ang1 grid rotation
       %> @param ang2 not for use, should be 0
       %>
       %> @retval X,Y  cartesian coordinates of nodes
       %> @retval W,H  node width and height (= diameter of circle)
       %> @retval A,R  polar coordinates of nodes
       % =====================================================================
       %function [X Y W H A R] = hexgrid(phobj,x0,y0,sizeX,sizeY,d,D,ang1,ang2)
       [X Y W H A R] = hexgrid(phobj,x0,y0,sizeX,sizeY,d,D,ang1,ang2);

       % ======================================================================
       %> @brief phantom_generate generates map with phantom described by eliptic
       %> elements
       %>
       %> @param mm      'square matrix' side size in [mm]
       %> @param         side size matrix in pixels
       %> @param el      vector with elipses (structure)
       %> @param defVal  permittivity in FOV
       %>
       %> @retval ph  map of permittivity distribution 
       % =====================================================================
       %function ph = phantom_generate(phobj,mm,siz,el,defVal)
       ph = phantom_generate(phobj,mm,size,el,defVal)
       
       % ======================================================================
       %> @brief phantom_rods calculates permittivity distribution for rod phantom
       %> creates numerical phantom with rods using list of positions and values
       %> the permittivity value is calculated only for FOV region
       %>
       %> @param discret_matrix_size_mm   side 'matrix size' in milimeters
       %> @param discret_matrix_size      side matrix size [number of grid elements]
       %> @param list                     vector of structures position (r,a), diameter and value for rods
       %> @param fov_permit               permittivity of field of view 
       %>
       %> @retval ph_map (matrix) permittivity
       % =====================================================================
       %function[ph_map] = phantom_rods(phobj,discret_matrix_size_mm,discret_matrix_size, list, fov_permit)
       [ph_map] = phantom_rods(phobj,discret_matrix_size_mm,discret_matrix_size, list, fov_permit)
       
       % ======================================================================
       %> @brief  Set the elements of the Matrix Image which are in the interior of the
       %> ellipse E with the value 'color'. The ellipse E has center (y0, x0), the
       %> major axe = a, the minor axe = b, and teta is the angle macked by the
       %> major axe with the orizontal axe.
       %>
       %> @param y0 center of ellipse - y coordinate
       %> @param x0 center of ellipse - x coordinate
       %> @param a major axe
       %> @param b minor axe
       %> @param teta angle
       %> @param Image image
       %> @param color
       %>
       %> @retval ret elipse object
       % =====================================================================
       % function ret = ellipseMatrix(phobj,y0, x0, a, b, teta, Image, color)
       ret = ellipseMatrix(phobj,y0, x0, a, b, teta, Image, color)
   end
end 
