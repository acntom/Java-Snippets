% =====================================================================
%> @brief reshape_sens reshape vector sensitivity maps to single matrix
%>
%> @param S_map           vector of sensitivity maps
%> @param map_size        size of single map
%> @param sens_matrix_num number of sensitivity maps
%>
%> @retval out reshape sensitivity map
% =====================================================================
function [S]=reshape_sens(rec_obj,S_map, map_size, sens_matrix_num)

S = reshape(S_map, [map_size*map_size sens_matrix_num])';

