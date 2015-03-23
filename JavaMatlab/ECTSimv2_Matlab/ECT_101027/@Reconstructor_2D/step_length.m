% =====================================================================
%> @brief % step_length calculates optimal steps alpha and beta
%> by minimizing |c-Se(i+1| norm for next step
%> e(i+1)=e(i) + a inv(S'(SS'+uI))(c-Se(i))
%>
%> @param S  - sensitivity matrix
%> @param Cr - vector of capacitances to be measured for current estimation of Ep
%> @param Cm - vector of measured capacitances
%> @param Ep - current estimation of permittivity distribution (column vector)
%> @param Epp - previous estimation of permittivity distribution (column vector)
%> @param u    - Thikonov regularization factor for matrix pseudo inverse
%> @retval alpha,beta optimal step lengths
% =====================================================================
function [a b] = step_length(rec_obj,S,Cr,Cm,Ep,Epp,u)


H = S*S'*inv(S*S' + u*diag(diag(S*S'))); 
e = Cm-Cr;   % Cr=SEp
d = Ep-Epp;

A(1,1) = (H*e)'*H*e;
A(1,2) = (H*e)'*S*d;
A(2,1) = (H*e)'*S*d;
A(2,2) = (S*d)'*S*d;

y(1,1) = e'*H*e;
y(2,1) = e'*S*d;

x = pinv(A)*y;

a=x(1);
b=x(2);
