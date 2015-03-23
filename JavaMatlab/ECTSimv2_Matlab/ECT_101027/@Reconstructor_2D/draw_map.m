% =====================================================================
%> @brief draw_map draws image
%>
%> @param figno figure number
%> @param name  figure name
%> @param lt    lower threshold
%> @param ut    upper threshold
%> @param map   map to display
%>
%> @retval res  display map
% =====================================================================
function [res]=draw_map(rec_obj,figno,name,lt,ut,map)

h = figure(figno);
set(h,'Name',name);
colorbar;
image(map,'cdatamapping','scaled');
caxis([lt,ut]);   % thresholds
colorbar;
%caxis('manual');
set(gca,'PlotBoxAspectRatio',[1,1,1]);
drawnow;
title(name);
res=map;
