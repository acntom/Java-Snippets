% =====================================================================
%> @brief it_recon performs general scheme of iterative reconstruction.
%> Function is overload.
%>         
%> @param First:varargin{1} disp_mode 'display' or 'no_display' during reconstruction
%>
%> @param Second:varargin{1} algorithm params (struct), struct properties are:
%> @param Second:varargin{1}:struct:method iterative algorithm method (equation for one step)
%> @param Second:varargin{1}:struct:method:name 'LBP' linearized backprojection
%> @param Second:varargin{1}:struct:method:name 'Landweber' gradient steepest descent with small step (default)
%> @param Second:varargin{1}:struct:method:name 'LandweberNormalized' Landweber for normalized data
%> @param Second:varargin{1}:struct:method:name 'NewtonRaphson' nonlinear Gauss-Newton with regularization
%> @param Second:varargin{1}:struct:method:name 'NewtonRaphsonConstrained' nonlinear Gauss-Newton with regularization and a constrain
%> @param Second:varargin{1}:struct:method:name 'LM' nonlinear Gauss-Newton with Marquardt regularization        
%> @param Second:varargin{1}:struct:numiter     stop after 'numiter' iterations
%> @param Second:varargin{1}:struct:stop_delta  stop when image changes are lower than 'stop_delta'
%> @param Second:varargin{1}:struct:update_method 'modulo' or 'auto' method of selecting moment for sensitivity matrix update
%> @param Second:varargin{1}:struct:iter_mod      update sensitivity matrix modulo 'iter_mod' iteration 
%> @param Second:varargin{1}:struct:update_delta  update sensitivity where dC becomes lower than 'update_delta'
%> @param Second:varargin{1}:struct:alpha         relaxation factor (step length)
%> @param Second:varargin{1}:struct:alphalimit    limitation of relaxation factor: 'adapt or 'noadapt'
%> @param Second:varargin{1}:struct:regular       'manual', 'l_curve' or 'GCV' selection of regularization parameter u
%> @param Second:varargin{1}:struct:u            Thikonov regularization factor for matrix pseudo inverse
%> @param Second:varargin{2} disp_mode 'display' or 'no_display' during reconstruction
%>
%> @retval Ep new better estimation of permittivity
% =====================================================================
function  [Ep] = it_recon(varargin)                                                                                       

% the last test was
% it_recon(sensor,boundary,object,'NewtonRaphsonLimited',300,5000,1.2,0.0002);
% it_recon(sensor,boundary,object,'NewtonRaphson',300,5000,0.6,0.0002);

if nargin==2 % default algorithm params
    rec_obj=varargin{1};
    
    disp_mode=varargin{2};
    
    if(strcmp(disp_mode,'no_display'))
    elseif(strcmp(disp_mode,'display'))
    else
        error('Unrecognized display option.');
    end
    
    method=rec_obj.method;
    numiter=rec_obj.numiter;
    stop_delta=rec_obj.stop_delta;
    update_method=rec_obj.update_method;
    iter_mod=rec_obj.iter_mod;
    update_delta=rec_obj.update_delta;
    alpha=rec_obj.alpha;
    alphalimit=rec_obj.alphalimit;
    regular=rec_obj.regular;
    u=rec_obj.u;
    
elseif nargin==3, % read algorithm params from struct 
    
    disp_mode=varargin{3};
    
    if(strcmp(disp_mode,'no_display'))
    elseif(strcmp(disp_mode,'display'))
    else
        error('Unrecognized display option.');
    end
    
    alg_params=varargin{2};
    
    if(isstruct(alg_params))
        
        rec_obj=varargin{1};        
        
        method=alg_params.method;
        numiter=alg_params.numiter;
        stop_delta=alg_params.stop_delta;
        update_method=alg_params.update_method;
        iter_mod=alg_params.iter_mod;
        update_delta=alg_params.update_delta;
        alpha=alg_params.alpha;
        alphalimit=alg_params.alphalimit;
        regular=alg_params.regular;
        u=alg_params.u;
        
        rec_obj.method=method;
        rec_obj.numiter=numiter;
        rec_obj.stop_delta=stop_delta;
        rec_obj.update_method=update_method;
        rec_obj.iter_mod=iter_mod;
        rec_obj.update_delta=update_delta;
        rec_obj.alpha=alpha;
        rec_obj.alphalimit=alphalimit;
        rec_obj.regular=regular;
        rec_obj.u=u;
        
    else
        error('This is not struct')
    end
    
else
    error('Too less or to much input elements');
end

S      = rec_obj.S;
S_     = S;
Sn_resize=rec_obj.Ef_max.Sn_resize;
Ep_max = rec_obj.Ep_max; 
Ep_min = rec_obj.Ep_min; 
Ep     = rec_obj.Ep;

Ep_map = rec_obj.Ep_map;

Ep_Pha     = rec_obj.Ep_Pha;      
Ep_Pha_map = rec_obj.Ep_Pha_map; 

S_Pha_=rec_obj.S_Pha;
S_0_=rec_obj.S_0;
S_Pha_map=rec_obj.S_Pha_map;
Ep_0=rec_obj.Ep_0;
Ep_maps_iter(:,:,1)=rec_obj.Ep_0_map(:,:); % starting permittivity

matrix_size=rec_obj.matrix_size;


% reprojection - projection for initial solution
C_max = rec_obj.C_max;
C_min = rec_obj.C_min; 
                         
Cr_0  = rec_obj.Cr_0;
%Cr_0  = (Cr_0-C_min)./(C_max-C_min);

% normalized measurement
Cm_n = rec_obj.Cm_n;
%Cm   = Cm_n;            
% projections denormalization using simulated max & min
Cm   = rec_obj.Cm;
Cr   = rec_obj.Cr_0;


% #####################################################################
% reconstruction errors 
%[S_Pha_, S_0_, S_] = rec_obj.fov_center (sensor, S_Pha_map, S_0_map, S_map);
[rec_obj.errors.Cap(1) rec_obj.errors.Imag(1) rec_obj.errors.Sens(1)] = rec_obj.recon_qual(Ep_Pha, S_Pha_, Cm, ... 
                                                            Ep_0,   S_0_,   Cr_0, ...
                                                            Ep,     S_,     Cr, '2one');                                                   
                                                       

% optimal u (Tikhonov regularization parameter) using l-curve

reg_params=rec_obj.regularization_method(regular,S,Cm);
rec_obj.u=reg_params;
% G=reg_params{2};
% reg_param=reg_params{3};

% #####################################################################
            % algorithm parameters

            if (strcmp(method, 'LM3'))
            [a1(1) b1(1)] = rec_obj.step_length(rec_obj.S,Cr,Cm,rec_obj.Ep,rec_obj.Ep_,rec_obj.u);
            else
               a1(1)= rec_obj.alpha;
               b1(1)=0;
            end
            
            rec_obj.alpha = a1(1);
            rec_obj.alpha_ = rec_obj.alpha;
            beta  = b1(1);
            rec_obj.param.Alpha(1) = rec_obj.alpha_;
            u_ = rec_obj.u;
            rec_obj.param.U(1) = rec_obj.u;
            rec_obj.param.Updating(1) = 0;
            
                

% reconstruction should be performed in FOV only
FOVidx=1:1:numel(Ep);

% reconstruction time
t=cputime; 
%tic;

% memory alloc for vector of eps maps in each iteration
rec_obj.Ep_maps_iter=ones(rec_obj.Ef_pha.simulation_discret_matrix_size,rec_obj.Ef_pha.simulation_discret_matrix_size,rec_obj.numiter);

for i=1:numiter
    rec_obj.current_iter=i;
    % remember estimate from previous step
            
    Ep_     = Ep;
    Ep_map_ = Ep_map;
    
    % one step of reconstruction algorithm - Ep(i)
    if strcmp(method, 'LBP')==1        
        Ep = rec_obj.alg_LBP(rec_obj.Cm_n,Sn_resize);
        
    elseif strcmp(method, 'Landweber')==1
        Ep(FOVidx) = rec_obj.alg_Landweber(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha);
    elseif strcmp(method, 'LandweberNormalized')==1
        Ep(FOVidx) = rec_obj.alg_Landweber_Norm(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha);
    elseif strcmp(method, 'NewtonRaphson')==1
        Ep(FOVidx) = rec_obj.alg_NewtonRa_Limit(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha,u,'no');
    elseif strcmp(method, 'NewtonRaphsonConstrained')==1
        Ep(FOVidx) = rec_obj.alg_NewtonRa_Limit(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha,u,'constrain',1,150);
    elseif strcmp(method, 'LBP_LM')==1
         if i==1
          Ep = rec_obj.alg_LBP(rec_obj.Cm_n,Sn_resize);          
         else
        Ep(FOVidx) = rec_obj.alg_LevenMarq_Limit(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha,u,'constrain',0.5,10);
         end
    elseif strcmp(method, 'LM')==1         
        Ep(FOVidx) = rec_obj.alg_LevenMarq_Limit(S(:,FOVidx),Cr,Cm,Ep(FOVidx),alpha,u,'constrain',0.5,10);         
    elseif strcmp(method, 'LM3')==1        
        Ep(FOVidx) = alg_LevenMarq_Limit3(S(:,FOVidx),Cr,Cm,Ep(FOVidx),Ep_(FOVidx),alpha,beta,u,'constrain',1,150);
    else
        disp 'unknown name of reconstruction method';
        return;
    end 

    % vector 2 map
   
    Ep_map = reshape(Ep,rec_obj.Ef_pha.simulation_discret_matrix_size,rec_obj.Ef_pha.simulation_discret_matrix_size);

    % #######################################
    % reprojection - current estimate of solution gives the measurements
    
    % remember previous value
    Cr_ = Cr;
    
    Cr = S * Ep;
    
    Cr_n = (Cr-C_min)./(C_max-C_min);
    
        
    % #####################################################################
    % reconstruction errors 
    %[S_Pha_, S_0_, S_] = fov_center (sensor, S_Pha_map, S_0_map, S_map);
    [rec_obj.errors.Cap(1+i) rec_obj.errors.Imag(1+i) rec_obj.errors.Sens(1+i)] = rec_obj.recon_qual(Ep_Pha, S_Pha_, Cm, ... 
                                                                      Ep_0,   S_0_,   Cr_0, ...
                                                                      Ep,     S_,     Cr , '2one');

            
 if strcmp(alphalimit,'noadapt')==1
       
    elseif strcmp(alphalimit,'adapt')==1
     
        if rec_obj.errors.Cap(1+i) > rec_obj.errors.Cap(i)          
                        Ep     = Ep_;
                        Ep_map = Ep_map_;
                        Cr     = Cr_;
                        
            rec_obj.alpha = rec_obj.alpha/2;  
            rec_obj.alpha_=rec_obj.alpha;
            continue;
        end
 else
        disp 'ERR: unknow value of 'alphalimit' argument';
        return;
 end
    
  rec_obj.Cr_iter(:,i)=rec_obj.Cr(:);  

    % #################################
    % update the sensitivity matrix 
    
        
        if strcmp(update_method,'modulo')==1
            update_sens_flag = 0;
            if mod(i,iter_mod)==0 
                update_sens_flag = 1;
            end
        elseif strcmp(update_method,'auto')==1
            dC = rec_obj.errors.Cap(1+i) - rec_obj.errors.Cap(i);
            update_sens_flag = 0;
            if dC > -update_delta
                update_sens_flag = 1;
                % update_delta = update_delta/2;
            end
        else
            disp 'ERR: unknow value of 'update_method' argument';
            return;
        end        

        if update_sens_flag==1
            rec_obj.param.Updating(1+i) = 0.1;

            ep_map = Ep_map;
            
            % ep_map = enhance(Ep_map,i,0);
            % rec_obj.Ef_pha.permittivity_distribution.getFOV(rec_obj.matrix_size, rescale,threshold, method)
            ep_map = rec_obj.Ef_pha.putFOV(rec_obj.Ef_pha.sensor, rec_obj.Ef_pha.permittivity_distribution, Ep_map, 'bilinear',0);
            % ep_map = putFOV(sensor, Ep_00_map, Ep_map, 'bilinear', 1);
            
            % constrain: we know that eps >= 1
            Ep_map_lim = ep_map;
            [p] = find(Ep_map_lim<1);
            Ep_map_lim(p) = 1;
            
%             [p] = find(Ep_map_lim>80);
%             Ep_map_lim(p) = 80;

            % compute new sensitivity matrix
            k=length(rec_obj.Ef_pha.sensor.vector_sensor_elements);
            for l=1:k
                name=rec_obj.Ef_pha.sensor.vector_sensor_elements(l).element_name;
                if strcmp(name,'fov')
                    fov=rec_obj.Ef_pha.sensor.vector_sensor_elements(l);
                end
            end
            
            tmp_perm=Permittivity_distribution_2D(fov);
            tmp_perm.Discretization_grid_perm.value_list=reshape(ep_map,1,numel(ep_map));
            Ef_tmp=Electrical_field_2D(rec_obj.Ef_pha.sensor,tmp_perm,rec_obj.Ef_pha.simulation_discret_matrix_size);
            S=Ef_tmp.S_resize;
            S_=S;
            S_map=Ef_tmp.S_map_resize;
%            [S S_map V_map Sn Sn_map] = make_sensitivity_matrix(sensor,boundary,Ep_map_lim,0);
            %object.sens.S_map_updated = S_map;
                        
            % Decymacja mapy czu³osci do rozmiaru rekonstrukcji


            % new u when new estimate of S is calculated
            % optimal u (Tikhonov regularization parameter) using l-curve
            reg_params=[];
            reg_params=rec_obj.regularization_method(regular,S,Cm);
            rec_obj.u=reg_params;
%             G=reg_params{2};
%             reg_param=reg_params{3};

            % modify step lenght (relaxation parameter)
            % alpha = alpha/40;
            % u = u / 5;
        end % update of sensitivity
                    
    %%%%
    % jeœli w³¹czona odpowiednia opcja u¿yj metody Koreañczyków
    if i>0
        if (strcmp(method, 'LM3'))
           [a1(i+1) b1(i+1)] = rec_obj.step_length(S,Cr,Cm,Ep,Ep_,u);
        else
           a1(i+1)= rec_obj.alpha;
           b1(i+1)=0;
        end
        
        object.a1=a1;
        object.b1=b1;
        alpha = a1(i+1);
        beta = b1(i+1);
    end
    %%%%    

     rec_obj.param.Alpha(1+i) = alpha;
     rec_obj.param.U(1+i) = u;
%     param.Updating(1+i) = 0;    
  
    
rec_obj.S=S;
rec_obj.Ep_max=Ep_max; 
rec_obj.Ep_min=Ep_min; 

rec_obj.Ep=Ep;
rec_obj.maps_number=i+1;
rec_obj.Ep_maps_iter(:,:,rec_obj.maps_number)=Ep_map(:,:); % first map is start solution


rec_obj.Ep_map=Ep_map;
rec_obj.Cr=Cr;
rec_obj.Cr_iter(:,i)=rec_obj.Cr(:);

rec_obj.Cm=Cm;
rec_obj.C_min=C_min;
rec_obj.Cm_n=Cm_n;
rec_obj.C_max=C_max;

if(strcmp(disp_mode,'display'))
    rec_obj.display();
elseif(strcmp(disp_mode,'no_display'))
else
    error('Unrecognized display option');
end

    % stop the iteration whene there is no progres
dE = abs(rec_obj.errors.Imag(1+i) - rec_obj.errors.Imag(i));
if dE < stop_delta
   disp 'STOP: no change of estimate.';
return;
end

end  % of iteration step

disp 'STOP. Maximum number of iteration reached.';
% reconstruction time 
cputime-t
% toc
