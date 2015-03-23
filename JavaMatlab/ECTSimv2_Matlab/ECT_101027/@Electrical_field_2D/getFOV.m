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

function [fovImg] = getFOV(ef_obj,sensor,image_matrix_size, simulation_phantom_matrix, rescale, method)

for i=1:length(sensor.vector_sensor_elements)
    name=sensor.vector_sensor_elements(i).element_name;
    if(strcmp(name,'fov'))
        fov_size=sensor.vector_sensor_elements(i).rmax*2;
    end
end

sFOV  = fov_size;             % fov size (pix)
sMtxS = sensor.discretization_grid.number_of_x_axis_pixel;  % simulation matrix size (pix)
sMtxR = image_matrix_size;    % reconstruction matrix size (pix)

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
end;

return;
    
