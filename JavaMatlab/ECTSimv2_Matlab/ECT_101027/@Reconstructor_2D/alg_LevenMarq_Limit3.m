% =====================================================================
%> @brief alg_LevenMarq_Limit calculates one step of Levenberg Marquard iteration
% with constrain for permittivity value, that is not less than 1
%>
%> @param S    sensitivity matrix
%> @param Cr   vector of capacitances to be measured for current estimation of Ep
%> @param Cm   vector of measured capacitances
%> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
%> @param Ep_  previous estimation of permittivity distribution 
%> @param alfa relaxation factor (step length)
%> @param beta acceleration
%> @param u    Thikonov regularization factor for matrix pseudo inverse
%> @param constrain 'constrain' to limit permittivity value
%> @param lt   lower threshold
%> @param ut   upper threshold
%>
%> @retval Ep (column vector) new better estimation of permittivity 
% =====================================================================
function Ep = alg_LevenMarq_Limit3(rec_obj,S,Cr,Cm,Ep,Ep_,alfa,beta,u,constrain,lt,ut)


deltaC = Cr-Cm;

pinvS = S'*inv(S*S' + u*diag(diag(S*S'))); 
        
Ep = Ep - alfa*pinvS*deltaC + beta*(Ep-Ep_);

% constrain: we know that eps >= 1
if strcmp(constrain,'constrain')==1
    [p] = find(Ep<lt);
    Ep(p) = lt;
    [p] = find(Ep>ut);
    Ep(p) = ut;
end

    
%         mask = find(S'<0);
%         mpinvS=pinvS;
%         mpinvS(mask)=mpinvS(mask)/1000;
