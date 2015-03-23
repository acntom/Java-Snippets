% =====================================================================
%> @brief calculates sensitivity map using reciprocity theorem and mutual impedance
%>
%> @param V1 potential map when first electrode is an application electrode
%> @param V2 potential map when 2-nd  electrode is an application electrode
%>
%> @retval S sensitivity map
% =====================================================================
function[S]=sens_map(ef_obj, V1, V2)

global data_type

%V1 = map_smooth(sensor,V1,sensor.calc_sensitivity.mask);
%V2 = map_smooth(sensor,V2,sensor.calc_sensitivity.mask);

[Ex1 Ey1] = gradient(V1,1);
[Ex2 Ey2] = gradient(V2,1);

[Ex1_ Ey1_] = gradient(V1,2);
[Ex2_ Ey2_] = gradient(V2,2);

th=6.5;
[p] = find(abs(Ex1)>th);
Ex1(p) = Ex1_(p);
Ey1(p) = Ey1_(p);
[p] = find(abs(Ey1)>th);
Ex1(p) = Ex1_(p);
Ey1(p) = Ey1_(p);
[p] = find(abs(Ex2)>th);
Ex2(p) = Ex2_(p);
Ey2(p) = Ey2_(p);
[p] = find(abs(Ey2)>th);
Ex2(p) = Ex2_(p);
Ey2(p) = Ey2_(p);

th=6.5;
[p] = find(abs(Ex1)<-th);
Ex1(p) = Ex1_(p);
Ey1(p) = Ey1_(p);
[p] = find(abs(Ey1)<-th);
Ex1(p) = Ex1_(p);
Ey1(p) = Ey1_(p);
[p] = find(abs(Ex2)<-th);
Ex2(p) = Ex2_(p);
Ey2(p) = Ey2_(p);
[p] = find(abs(Ey2)<-th);
Ex2(p) = Ex2_(p);
Ey2(p) = Ey2_(p);


% th=10;
% [Ex1__ Ey1__] = gradient(V1,3);
% [Ex2__ Ey2__] = gradient(V2,3);
% [p] = find(abs(Ex1)>th);
% Ex1(p) = Ex1__(p);
% Ey1(p) = Ey1__(p);
% [p] = find(abs(Ey1)>th);
% Ex1(p) = Ex1__(p);
% Ey1(p) = Ey1_(p);
% [p] = find(abs(Ex2)>th);
% Ex2(p) = Ex2__(p);
% Ey2(p) = Ey2__(p);
% [p] = find(abs(Ey2)>th);
% Ex2(p) = Ex2__(p);
% Ey2(p) = Ey2__(p);


S = - (Ex1.*Ex2 + Ey1.*Ey2);

%[p] = find(bitand(sensor.M,sensor.calc_sensitivity.flag)==0);%insulator1+fov?
%[p] =find(bitand(ef_obj.sensor.discretization_grid.get_matrix(),13)==0);
% [p1] =find(ef_obj.sensor.discretization_grid.get_matrix()==1);
% [p2] =find(ef_obj.sensor.discretization_grid.get_matrix()==23);
% [p3] =find(ef_obj.sensor.discretization_grid.get_matrix()==24);
% [p4] =find(ef_obj.sensor.discretization_grid.get_matrix()==25);
% [p5] =find(ef_obj.sensor.discretization_grid.get_matrix()==26);
% [p6] =find(ef_obj.sensor.discretization_grid.get_matrix()==27);
% [p7] =find(ef_obj.sensor.discretization_grid.get_matrix()==33);
% [p8] =find(ef_obj.sensor.discretization_grid.get_matrix()==34);
% [p9] =find(ef_obj.sensor.discretization_grid.get_matrix()==35);
% [p10] =find(ef_obj.sensor.discretization_grid.get_matrix()==36);
% [p11] =find(ef_obj.sensor.discretization_grid.get_matrix()==37);
% [p12] =find(ef_obj.sensor.discretization_grid.get_matrix()==43);
% [p13] =find(ef_obj.sensor.discretization_grid.get_matrix()==53);
% [p14] =find(ef_obj.sensor.discretization_grid.get_matrix()==13);
% 
% p=[p1' p2' p3' p4' p5' p6' p7' p8' p9' p10' p11' p12' p13' p14'];

% M=ef_obj.discretization_grid_sensor_and_phantom.get_matrix();
% p=find(M > 3);
%M_without_fov=M(M > 3);

%S(p) = 0;


% TODO
% S = medfilt2(S);

% TODO:  sensitivity limitation for neighbour electrodes
%[p] = find(S>8.5);
%S(p)=8.5;







% ############## test szybkosci - wersja A
% [Ex1 Ey1] = gradient(V1);
% [Ex2 Ey2] = gradient(V2);
% 
% S = - (Ex1.*Ex2 + Ey1.*Ey2);
% ###############################

% ############## test szybkosci - WERSJA B
% S = zeros(sensor.discret_matrix_size, sensor.discret_matrix_size,data_type);
% 
% for i=2:sensor.discret_matrix_size-1,
% for j=2:sensor.discret_matrix_size-1,
%     
%         ey1 = -(V1(i+1,j)-V1(i-1,j))/2;
%         ex1 = -(V1(i,j+1)-V1(i,j-1))/2;
%         ey2 = -(V2(i+1,j)-V2(i-1,j))/2;
%         ex2 = -(V2(i,j+1)-V2(i,j-1))/2;
% 
%         S(i,j)= -(ex1*ex2 + ey1*ey2);
% end
% end
% ###############################



% smieci
%#########################################################################
% if(draw==1)
%     h=figure(400+sm);
%     set(h,'Name','Sensivity');
%     image(S,'cdatamapping','scaled');
%     set(gca,'PlotBoxAspectRatio',[1,1,1]);
%     drawnow;
% end
% 

% [x y] = find(bitand(sensor.M,sensor.calc_sensitivity.flag)==0);
% 
% for p=1:size(x,1)
%     i = x(p); 
%     j = y(p);
%     S(i,j) = 0;
% end    


% for i=1:sensor.discret_matrix_size,
% for j=1:sensor.discret_matrix_size,
%   
%     if ~bitand(sensor.M(i,j),sensor.calc_sensitivity.flag)
%         S(i,j) = 0;
%     end
%     if(S(i,j)>4) S(i,j)=4; end 
%     
%     %if(S(i,j)<0) S(i,j)=0; end
% end
% end



