% =====================================================================
%> @brief sens_norm_lbp normalize sensitivity matrix coefficients
%>
%> @param S sensitivity matrix
%> @retval Sn normalized sensitivity matrix
% =====================================================================
function [Sn]=sens_norm_lbp(ef_obj,S)

% sum over columns
sc = sum(S);

Sn = S;

parfor j=1:length(sc)
    if sc(j)~=0
        Sn(:,j)=S(:,j)/sc(j);
    end
end
