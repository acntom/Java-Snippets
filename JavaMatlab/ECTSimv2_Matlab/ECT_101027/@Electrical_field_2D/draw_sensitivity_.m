% =========================================================================
%> @brief draws sensitivity map for pair of electrodes
%>
%> @param S sensitivity map
% =========================================================================
function[] = draw_sensitivity_(ef_obj,S)

    image(S,'cdatamapping','scaled');
    set(gca,'PlotBoxAspectRatio',[1,1,1]);
    drawnow;

