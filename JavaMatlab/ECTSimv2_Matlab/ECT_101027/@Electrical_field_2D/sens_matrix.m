% =====================================================================
%> @brief sens_matrix calculates sensitivity matrix using sensitivity maps for electrodes pairs
%>
%> @param V     potential map for one pair of electrodes
%> @param draw  draw calculated map if ~= 0
%> @retval S sensitivity map
% =====================================================================
function [S]=sens_matrix(ef_obj,V,draw)

sm = 1;

for el_a=1:ef_obj.number_of_electrodes
    if ef_obj.measurements_all==0
        num = ef_obj.number_of_electrodes;
    else
        num = el_a+ef_obj.number_of_electrodes-1;
    end
    for el_r=el_a+1:num
        if el_r > ef_obj.number_of_electrodes
            el_r = mod(el_r,ef_obj.number_of_electrodes);
        end
        if (el_a==1) d=draw;
        else d=0; 
        end
        S(:,:,sm) = ef_obj.sens_map(V(:,:,el_a), V(:,:,el_r));  
        
            if (el_r-el_a)==1 || (el_r-el_a+1)==ef_obj.number_of_electrodes
                % limit max
                %S(:,:,sm) = sens_map_limit(sensor,S(:,:,sm));
                % smooth
                %S(:,:,sm) = map_smooth(sensor,S(:,:,sm),sensor.calc_sensitivity.flag);
            end
            
        %ef_obj.draw_sensitivity_(S(:,:,sm), el_a, el_r, d); % draw only for first electrode
        sm = sm + 1;
    end
end
        