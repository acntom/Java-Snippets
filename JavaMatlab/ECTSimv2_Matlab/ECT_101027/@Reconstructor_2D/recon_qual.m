% =========================================================================
%> @brief recon_qual calculates norms for image (permittivity distribution),
%> sensitivity matrix and measurement
%> recon_qual calculates norms for image (permittivity distribution),
%> sensitivity matrix and measurement
%> the discrepancy (normalized square norm)
%> 1. between numerical phantom or model and reconstructed image
%> 2. between sensitivity matrix for phantom and sensitivity 
%>    matrix for solution estimate
%> 3. between measured values and reprojected using current solution estimate
%> 
%> @param Ep_Pha  permittivity distribution of numerical phantom or model
%> @param S_Pha   sensitivity matrix calculated for phantom or model
%> @param Cm      measurements - real values
%> @param Ep_0    permittivity distribution of initial (start) solution Ep(0)
%> @param S_0     sensitivity matrix calculated for initial solution Ep(0)
%> @param Cr_0    measurements - reprojected values for initial solution Ep(0)
%> @param Ep      permittivity distribution - current solution estimate Ep(i)
%> @param S       sensitivity matrix calculated for current solution estimate S(i)
%> @param Cr      measurements - reprojected values for current solution Ep(i)
%> @param scale   '2one' to scaling to 1 or 'norm' to normalize
%>
%> @retval Cap_err   vector of normalized L2 distance in measurement domain
%> @retval Imag_err  vector of normalized L2 distance in image domain
%> @retval Sens_err  vector of normalized L2 distance between models
% =========================================================================
function [Cap_err Imag_err Sens_err] = recon_qual (rec_obj,Ep_Pha, S_Pha, Cm, ... 
                                                   Ep_0,   S_0,   Cr_0, ...
                                                   Ep,     S,     Cr, scale)
                                                          
% matrices should be reshaped to vectors! or call sum(sum(A));

if strcmp(scale,'2one')==1

    Cap_err  = sum(sum((Cr-Cm).^2))/sum(sum((Cr_0-Cm).^2));
    
    Imag_err = sum(sum((Ep-Ep_Pha).^2))/sum(sum((Ep_0-Ep_Pha).^2));

    Sens_err = sum(sum((S-S_Pha).^2))/sum(sum((S_0-S_Pha).^2));    

elseif strcmp(scale,'norm')==1

    Cap_err  = sum(sum((Cr-Cm).^2))/sum(sum((Cm).^2));

    Imag_err  = sum(sum((Ep-Ep_Pha).^2))/sum(sum((Ep_Pha).^2));

    Sens_err = sum(sum((S-S_Pha).^2))/sum(sum((S_Pha).^2));

else
    disp 'ERR: unknown parameter for reconstruction error scaling mode';
    return;
end


