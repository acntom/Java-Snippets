% jm = findResource('scheduler','type','local');
% http://www.osc.edu/research/hll/matlab/usage.shtml
dg=Discretization_grid(40,1);
%a=dfeval(@Sensor_element_circular,{0,360,0,3,dg,'none',1,'fov'},{0,360,0,4,dg,'none',1,'fov'},'Configuration', 'local');
a=dfeval(@eftest,{1},{2},'Configuration', 'local');