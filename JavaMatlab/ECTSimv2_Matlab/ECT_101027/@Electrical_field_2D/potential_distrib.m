% =====================================================================
%> @brief potential_distrib calculates potential distrubution 
%>
%> @param method - method of calculation of coefficients
%>         'gauss' - (default) using gauss law (integral eqation)
%>         'kirchhof' - calculating potential using capacitor mesh and
%>          Kirchhof law
%>         'finite difference' - not implemented
%>
%> @retval V potential distribution vector of maps
% =====================================================================
function [V]=potential_distrib(ef_obj,method)

global data_type

disp 'potential distribution - calculating';

discret_matrix_size=ef_obj.discret_matrix_size;
pidxx=ef_obj.pidx;
iidx=ef_obj.iidx;
B_map=ef_obj.B_map;
number_of_electrodes=ef_obj.number_of_electrodes;
eps_map=ef_obj.eps_map;

A = ef_obj.pot_matrix(discret_matrix_size,pidxx,iidx,eps_map,method);


parfor el=1:number_of_electrodes
    BV(:,el) = reshape(B_map(:,:,el),discret_matrix_size*discret_matrix_size,1);
end

% only selected pixels ()
pidx = pidxx;
band = discret_matrix_size; 
for el=1:number_of_electrodes
    for i=1:size(pidx,1)
        bv(band+i,el) = BV(pidx(i,1),el);
    end
end
bv(band*2+size(pidx,1),number_of_electrodes) = 0;

size(pidxx);
size(bv);

% potential distribution calculations (for electrode.num stimulations)

% upper triangular form of matrix (thomas2)
[A,bd]=ef_obj.thomas2(discret_matrix_size,discret_matrix_size,A,number_of_electrodes,bv);

% solveLU
v = zeros(discret_matrix_size^2,1,data_type);
for el=1:number_of_electrodes
    
    vt = ef_obj.solveLU(discret_matrix_size,A,bd(:,el));
    % version with inverse
    % vt = inv(A)*bv(:,el);
    
    % all pixels
    for i=1:size(pidx,1)
            %if pidx(i)~=0
                v(pidx(i)) = vt(i+band);
            %end
    end    

    V(:,:,el)=reshape(v, discret_matrix_size,discret_matrix_size);
    
end;

disp 'potential distribution. done.';
