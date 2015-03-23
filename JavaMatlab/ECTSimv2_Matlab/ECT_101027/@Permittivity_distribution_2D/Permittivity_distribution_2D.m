%> @file Permittivity_distribution_2D.m
%> @brief Two dimensional sum of phantoms (permittivity distributions) in field of view. 
% ======================================================================
%> @brief Two dimensional sum of phantoms (permittivity distributions) in field of view.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Permittivity_distribution_2D < Permittivity_distribution

   properties (SetAccess=public)
       %> permittivity distribution of object (discretization grid object) 
       Discretization_grid_perm;
       %> permittivity distribution of object (vector - linear index)
       fov_eps_vector_full_discretization_grid;
       %> vector of linear indicies to elements belongs to field of view
       fov_indicies_vector;
       %> diameter of field of view [grid elements-'pixels']
       fov_size; 
       %> name of object e.g. Min, Max, Avg, Phantom
       pd_name='Permittivity Distribution';
       %> maks permittivity value in Discretization_grid_perm
       max_perm_value; 
       %> vector of phantom object
       phantom_vector 
       %> number of phantoms
       number_of_phantoms  
   end

   methods (Access=public)
       % ==================================================================
       %> @brief Class constructor.
       %>
       %> @param varargin{1} sensor_element object represent field of view
       %> 
       %> @return instance of the Permittivity_distribution_2D class.
       % ==================================================================
       function pd_obj=Permittivity_distribution_2D(varargin)
           if nargin == 0 ; % no input arguments
           elseif isa(varargin{1},'Permittivity_distribution_2D')
            pd_obj = varargin{1}; % copy constructor
            display 'copy constructor Permittivity_distribution_2D'
            return; 
           else
               switch(nargin)
                   case 1;
                       display 'creating permittivity distribution '
                       if isa(varargin{1},'Sensor_element_circular') %FOV object
                           fov=varargin{1};
                           pd_obj.fov_indicies_vector=fov.point_list;                           
                           pd_obj.fov_size=fov.rmax*2;
                                                      
                           pd_obj.number_of_phantoms=1;
                           pd_obj.phantom_vector=repmat(Phantom_generator_2D,1,1);
                           % background is taken from FOV grid
                           pd_obj.Discretization_grid_perm=Discretization_grid_2D_square(fov.discretization_grid_of_element.matrix_size_mm,fov.discretization_grid_of_element.grid_size_mm);                            pd_obj.Discretization_grid_perm.value_list=fov.discretization_grid_of_element.value_list;
                       
                           pd_obj.fov_eps_vector_full_discretization_grid=pd_obj.Discretization_grid_perm.value_list;
                       end
                otherwise
                       error('too less or too many input arguments');
               end     
           end
       end
       
       % ==================================================================
       %> @brief Use to add Phantom_generator_2D object to field of view. 
       %>
       %> @param ph_object Phantom_generator_2D object
       % ==================================================================
       function add_Element(pd_obj,ph_object)
           % last element is on top
           
           % we can add element using Phantom_generator
           % discretization grid must be the same as other elements have
           % e.g. sensor
           % We use points which only belongs to FOV
           
           if isa(ph_object,'Phantom_generator_2D')                     
               
               pd_obj.phantom_vector(pd_obj.number_of_phantoms)=ph_object;
               pd_obj.number_of_phantoms=pd_obj.number_of_phantoms+1;
               
               % check all point from phantom 
               for i=1:length(ph_object.point_list)
                   ph_index=ph_object.point_list(i);
                   
                   % is point in FOV vector?
                   empty=isempty(find(pd_obj.fov_indicies_vector==ph_index,1));                   
                   if(~empty)                       
                       new_val=ph_object.discretization_grid.value_list(ph_index);
                       pd_obj.Discretization_grid_perm.value_list(ph_index)=new_val;
                   end
                   pd_obj.max_perm_value=max(pd_obj.Discretization_grid_perm.value_list);
               end                                  
              
           else
              
            end
       end
       
       % ==================================================================
       %> @brief GetFOV returns FOV part of given image using sensor data
       %> structure. This function require image processing toolbox.
       %>
       %> @param image_matrix_size rescale side size [pix]
       %> @param rescale flag if rescale to reconsruction matrix size have to be done
       %> 0 no, 1 yes (default value is 1)
       %> @param threshold 0-without, other value - use it
       %> @param method interpolating method for image rescaling (default is bilinear).
       %> For more see imresize help.
       %>
       %> @retval out return value of this method
       % ==================================================================
       function [fovImg] = getFOV(pd_obj,image_matrix_size, rescale,threshold, method)
        sFOV  = pd_obj.fov_size;             % fov size                    (pix)
        sMtxS = pd_obj.Discretization_grid_perm.number_of_x_axis_pixel;  % simulation matrix size      (pix)
        sMtxR = image_matrix_size;    % reconstruction matrix size  (pix)

        simulation_phantom_matrix = pd_obj.Discretization_grid_perm.get_matrix();
        
    
        % we assume that fov is centered on image
        % and image matrix have the same size as simulation matrix
        [sx sy]=size(simulation_phantom_matrix);
        if(sx~=sMtxS || sy~=sMtxS),
            fovImg = [];
            display('ERR: Image and simulation matrix size are different.');
            return;
        end

        margin=round((sMtxS-sFOV)/2);
        
        fovImg=simulation_phantom_matrix(margin+(1:1:sFOV),margin+(1:1:sFOV));


        if(nargin<3),
            rescale=1;
        end;
        if(nargin<4),
            method='bilinear';
        end;
        if(rescale==1),
            fovImg=imresize(fovImg,[sMtxR,sMtxR],method,'Antialiasing',1);            
            if(threshold~=0)
                indmin=find(fovImg<threshold);
                [r,c]=size(indmin);                
                indmin=reshape(indmin,1,r);
                
                indmax=find(fovImg>=threshold);
                [r,c]=size(indmax);            
                indmax=reshape(indmax,1,r);
                
                % maximum value in each columns
                m_val=max(fovImg);
                % maximum value in vector
                m_val=max(m_val);
                
                n_x=numel(indmax);
                n_m=numel(indmin);
                
                tmp=ones(1,n_x);
                size(tmp);
                tmp=tmp.*m_val;
                fovImg(indmax)=tmp;
                
                tmp2=zeros(1,n_m);
                fovImg(indmin)=tmp2;
            end
        end;

        return;       
       end
       %end get resize permittivity
    end 
end 
