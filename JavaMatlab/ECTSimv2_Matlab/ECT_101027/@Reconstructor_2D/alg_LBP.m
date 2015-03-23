% =====================================================================
%> @brief alg_LBP calculates one step LBP
%>
%> @param Sn    sensitivity matrix normalized
%> @param Cm_n  vector of measured normalizedcapacitances
%>
%> @retval Ep (column vector) new better estimation of permittivity 
% =====================================================================
function Ep = alg_LBP(rec_obj,Cm_n,Sn)

% S=rec_obj.S;
% 
% % sum over columns
% sc = sum(S);
% 
% Sn = S;
% 
% parfor j=1:length(sc)
%     if sc(j)~=0
%         Sn(:,j)=S(:,j)/sc(j);
%     end
% end

Ep = Sn'*Cm_n;
Ep=1+Ep.*rec_obj.Ef_max.permittivity_distribution.max_perm_value;
%Ep=Sn'*ones(size(C));
