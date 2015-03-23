% =====================================================================
%> @brief alg_NewtonRa_Limit calculates one step of Newton Raphson iteration
%> with constrain for permittivity value, that is not less than 1
%>
%> @param S    sensitivity matrix
%> @param Cr   vector of capacitances to be measured for current estimation of Ep
%> @param Cm   vector of measured capacitances
%> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
%> @param alfa relaxation factor (step length)
%> @param u    Thikonov regularization factor for matrix pseudo inverse
%> @param constrain 'constrain' to limit permittivity value
%> @param lt   lower threshold
%> @param ut   upper threshold
%>
%> @retval Ep (column vector) new better estimation of permittivity 
% =====================================================================
function Ep = alg_NewtonRa_Limit(rec_obj,S,Cr,Cm,Ep,alfa,u,constrain,lt,ut)

deltaC = Cr-Cm;

pinvS = S'*inv(S*S' + u*eye(size(S,1),size(S,1))); 

Ep = Ep - alfa*pinvS*deltaC;

% constrain: we know that eps >= 1
if strcmp(constrain,'constrain')==1
    [p] = find(Ep<lt);
    Ep(p) = lt;
    [p] = find(Ep>ut);
    Ep(p) = ut;
end
    
    
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

% ######
% S=normsens(S);
% 
% Ep=Ep-alfa*S'*deltaC;
% ######


    
% MO rekonstrukcja powinna byæ w ma³ej rozdzielczoœci
% for n=1:sensor.discret_matrix_size*sensor.discret_matrix_size
%     [ii,jj]=map_coord(n,sensor.discret_matrix_size);
%     if bitand(sensor.M(ii,jj),sensor.fov.mask) 
%         Ep(n,1)=Ep(n,1) - alfa*S(:,n)'*deltaC;
%     end
% end
