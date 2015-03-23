% =====================================================================
%> @brief draws potential distribution for application electrode
%>
%> @param varargin{1} potential distribution map
%> @param varargin{2} electrode num (optional)
% =====================================================================
function[] = draw_potential_(varargin)

if(nargin==2)
    V=varargin{2};
    image(V,'cdatamapping','scaled');
    set(gca,'PlotBoxAspectRatio',[1,1,1]);
    drawnow;
    
elseif (nargin==3)
    V=varargin{2};
    num=varargin{3};
    figname = strcat('Electrical Potential El', int2str(num));
    
    h = figure('Name',figname,'NumberTitle','off');
    image(V,'cdatamapping','scaled');
    set(gca,'PlotBoxAspectRatio',[1,1,1]);
    drawnow;
    
end

end
