% =====================================================================
%> @brief fov_center gets center of fov from sensitivity maps 
%>
%> @param sensor     sensor object
%> @param S_Pha_map  sensitivity map calculated for phantom or model
%> @param S_0_map    sensitivity map calculated for initial solution Ep(0)
%> @param S_map      - sensitivity map calculated for current solution estimate S(i)
%>
%> @retval S_Pha   sensitivity matrix calculated for phantom or model
%> @retval S_0     sensitivity matrix calculated for initial solution Ep(0)
%> @retval S       sensitivity matrix calculated for current solution estimate S(i)
% =====================================================================
function [S_Pha, S_0, S] = fov_center (rec_obj, sensor, S_Pha_map, S_0_map, S_map)
                                                        
% matrices should be reshaped to vectors! or call sum(sum(A));

[p] = find(sensor.MC~=sensor.cfov.flag);

for i=1:rec_obj.Ef_pha.sens_matrix_num
    T = S_Pha_map(:,:,i);
    T(p)=0;
    S_Pha_map(:,:,i) = T;
    T = S_0_map(:,:,i);
    T(p)=0;
    S_0_map(:,:,i) = T;
    T = S_map(:,:,i);
    T(p)=0;
    S_map(:,:,i) = T;
end


S_Pha = reshape_sens(S_Pha_map, sensor.discret_matrix_size, rec_obj.Ef_pha.sens_matrix_num);
S_0   = reshape_sens(S_0_map, sensor.discret_matrix_size, rec_obj.Ef_pha.sens_matrix_num);
S     = reshape_sens(S_map, sensor.discret_matrix_size, rec_obj.Ef_pha.sens_matrix_num);

