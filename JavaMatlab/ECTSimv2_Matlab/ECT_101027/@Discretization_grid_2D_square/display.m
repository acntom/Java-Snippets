% =====================================================================
%> @brief Overload matlabs function use to display. Display current
%> value_list from grid.
% =====================================================================
function display(dg_obj)


M=dg_obj.get_matrix();
maxx=max(dg_obj.value_list);
minn=min(dg_obj.value_list);

image(M,'cdatamapping','scaled');

if strcmp(dg_obj.threshold_mode,'auto')  
    lt_v=minn;  
    ut_v=maxx;      
    
elseif strcmp(dg_obj.threshold_mode,'thresholds')
    lt_v=dg_obj.lt;
    ut_v=dg_obj.ut;
    
else
    error('unknow display mode');
end

% values shouldn't be the same
if(lt_v==ut_v)
    lt_v=lt_v-0.1;    
end
    
caxis([lt_v,ut_v]);   % thresholds
colorbar;                 
drawnow;


% methods('Discretization_grid')
% mco = metaclass(dg_obj);
% propcell = mco.Properties;
% ln=length(propcell);
%  for i=1:ln
%      tmp=propcell{i}.Name; % name of first property    
%      tab_name{i}=tmp;
%  end
%  
% tab_name
% http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_oop/br8du8u.
% html
% properties('Discretization_grid')


end
