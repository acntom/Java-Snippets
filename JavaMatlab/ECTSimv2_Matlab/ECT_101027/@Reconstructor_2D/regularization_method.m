% =================================================================
%> @brief Compute regularization parameters 
%>
%> @param varargin{2} regularization method: 'L-curve'
%> @param varargin{3} sensitivity matrix
%> @param varargin{4} measured capacitances vector
%>
%> @return reg_params computed regularization parameters (cell vector)
% =================================================================
%function reg_params = regularization_method(varargin)
function reg_params = regularization_method(varargin)

    if nargin==4
        rec_obj=varargin{1};
        regular=varargin{2};
        S      =varargin{3};
        Cm     =varargin{4};

        % optimal u (Tikhonov regularization parameter) using l-curve
    else
        error('too less or too many argument number');
    end
    
    if strcmp(regular,'L-curve')==1
        %fh_uTikhonov = figure(3026);
        [U,s,V] = csvd(S);
        [u,G,reg_param] = l_curve(U,s,Cm);

        reg_params=u;
%       reg_params{2}=G;
%       reg_params{3}=reg_param;
    elseif strcmp(regular,'manual')==1
        % do nth
        reg_params=rec_obj.u;
    else
        error('unrecognized regularization method');
    end

end

