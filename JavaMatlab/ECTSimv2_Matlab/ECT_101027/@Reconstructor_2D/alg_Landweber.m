% =====================================================================
%> @brief alg_Landweber calculates one step of Landweber iteration
%>
%> @param S    sensitivity matrix
%> @param Cr   vector of capacitances to be measured for current estimation of Ep
%> @param Cm   vector of measured capacitances
%> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
%> @param alfa relaxation factor (step length)
%>
%> @retval Ep (column vector) new better estimation of permittivity 
% =====================================================================
function Ep = alg_Landweber(rec_obj,S,Cr,Cm,Ep,alfa)

deltaC = Cr-Cm;

Ep = Ep - alfa*S'*deltaC;

% Ep = Ep - alfa*S'*deltaC;
% 
% 
% % inner insulator properties are known
% for n=1:sensor.matrix_size*sensor.matrix_size
%      [ii,jj]=wspolrzedne(n,sensor.matrix_size);
%      if bitand(sensor.M(ii,jj),sensor.insulator1.mask) 
%          Ep(n,1)=sensor.insulator1.permit;
%      end
% end

% FOVidx=bitand(sensor.M,sensor.fov.mask)==sensor.fov.mask;
% Ep(FOVidx)=Ep(FOVidx)-alfa*S(:,FOVidx)'*deltaC;
