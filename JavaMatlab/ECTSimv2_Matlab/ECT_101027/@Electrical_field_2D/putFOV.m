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
function [img] = putFOV(ef_obj,sensor, perm_distrib, fovImgR, method,fillBorder)

for i=1:length(sensor.vector_sensor_elements)
    name=sensor.vector_sensor_elements(i).element_name;
    if(strcmp(name,'fov'))
        fov_size=sensor.vector_sensor_elements(i).rmax*2;
    end
end

sFOV=fov_size;                      % fov size (pix)
sMtxS=sensor.discretization_grid.number_of_x_axis_pixel;   % simulation matrix size (pix)

sMtxR=length(fovImgR);

% we assume that fov is centered on image
% and image matrix have the same size as simulation matrix
simulation_phantom_matrix = perm_distrib.Discretization_grid_perm.get_matrix();
[sx sy]=size(simulation_phantom_matrix);
if(sx~=sMtxS || sy~=sMtxS),
    img = [];
    display('ERR: Image and simulation matrix size are different.');
    return;
end

% check if filling border is set
if(nargin<5),
    fillBorder=0; % if not set default
end;

%fill (extrapolate) borders if flag set
if(fillBorder),
    % to do
    % recon matrix fov mask (big pixels)
    rmfm=zeros(sMtxR+4);    % add 2 pix margin for further filtering image
    % put resized mask of big pixels fov
    % but first take only fov pixels
    m=round((sMtxS-sFOV)/2);
    
    simulation_phantom_matrix = perm_distrib.Discretization_grid_perm.get_matrix();
    fov=simulation_phantom_matrix(m+(1:1:sFOV),m+(1:1:sFOV));

    rmfm(3:sMtxR+2,3:sMtxR+2)=imresize(fov,[sMtxR,sMtxR]);
    % reconstructed fov with border
    fovR_wb_orig=zeros(sMtxR+4); 
    fovR_wb_orig(3:sMtxR+2,3:sMtxR+2)=fovImgR;
    fovR_wb_extr=fovR_wb_orig;  % image with extrapolated values (to calculate)
    se=strel('square',3);
    rmfm_border=imdilate(rmfm,se)-rmfm;
    % brute forse method with loop ... do it better, if You know how
    for i=1:(sMtxR+4)*(sMtxR+4),
        if(rmfm_border(i)>0),
            %extrapolate border values using four neighbours
            d=sum([rmfm(i+1) rmfm(i-1) rmfm(i+sMtxR+4) rmfm(i-(sMtxR+4))]);
            if d==0, 
                continue;
            end;
            fovR_wb_extr(i)=sum([rmfm(i+1)*fovR_wb_orig(i+1) rmfm(i-1)*fovR_wb_orig(i-1) rmfm(i+sMtxR+4)*fovR_wb_orig(i+sMtxR+4) rmfm(i-(sMtxR+4))*fovR_wb_orig(i-(sMtxR+4))])/d;
        end
    end

    fovImgR=fovR_wb_extr(3:sMtxR+2,3:sMtxR+2);
end


% check if interpolation method is given
if(nargin<4),
    method='bilinear'; % if not set default
end;
% rescale and fit reconstruction fov to simulation resolution
fovImgS=zeros(sMtxS);
margin=round((sMtxS-sFOV)/2);
fovImgS(margin+1:margin+sFOV,margin+1:margin+sFOV)= ...
    imresize(fovImgR,[sFOV,sFOV],method);

fovImgS(find(fovImgS==0))=1;

img=fovImgS;

return;

    
