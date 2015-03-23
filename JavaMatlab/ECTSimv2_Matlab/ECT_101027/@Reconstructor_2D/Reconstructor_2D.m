%> @file Reconstructor_2D.m
%> @brief Class used to reconstruct image. 
% ======================================================================
%> @brief Class used to reconstruct image. Can read capacitance data from file. Display
%> reconstruction results.
% ectsim - Electrical Capacitance Tomography - Image Reconstruction Toolbox
% ======================================================================
classdef Reconstructor_2D < Reconstructor
    
    properties (GetAccess = public)  
        %> Electrical field object with main phantom
        Ef_pha;
        %> Electrical field object with uniform minimal permittivity phantom
        Ef_min;
        %> Electrical field object with uniform maximal permittivity phantom
        Ef_max;
        %> Electrical field object with uniform average permittivity phantom
        Ef_avg;
        
        %> vector of permittivity distribution - start solution
        Ep_0; 
        %> matrix of permittivity distribution - start solution (reshape Ep_0)
        Ep_0_map;        
        %> vector of sensitivity distribution - start solution
        S_0;
        %> matrix of sensitivity distribution - start solution (reshape S_0)
        S_0_map;
        
        %> vector of eps maps in each algorithm iteration        
        Ep_maps_iter; 
        %> number of maps in Ep_maps_iter (usualy start solution + numiter)
        maps_number         
        
        %> capacitance measurement from electrical field pha object
        Cm   
        %> recalculated capacitance in each iteration
        Cr_iter; 
        
        % Algorithm parameters
        %> algorithm name 
        method
        %> number of iteration
        numiter
        %> stop algorithm when difference between current and previous permittivity distribution is less then stop_delta
        stop_delta
        %> update method 'auto' or 'modulo' 
        update_method
        %> recalculate sensitivity matrix when mod(numiter,iter_mod)==0 (update_method must be 'modulo')
        iter_mod
        %> recalculate sensitivity matrix when difference between previous and current capacitances is less than update_delta
        update_delta
        %> current argorithm step
        alpha
        %> previous argorithm step
        alpha_ 
        %> limit of step (alpha) value
        alphalimit
        %> enable regularization - L-curve disable - manual 
        regular
        %> Thikonov regularization factor, regular property must be 'manual'
        u
        %> struct with algorithm parameters
        param;
        
        %> number of last itration
        current_iter; 
        %> struct with capacitance, permittivity and sensitivity errors
        errors
    end
    
    properties (GetAccess = private)  
        
        %> side size of matrix        
        matrix_size;
        %> vector of permittivity distribution of phantom
        Ep_Pha;   
        %> matrix of permittivity distribution of phantom
        Ep_Pha_map;
        %> vector of sensitivity distribution of phantom
        S_Pha;
        %> matrix of sensitivity distribution of phantom
        S_Pha_map;        
        %> vector of permittivity distribution from current iteration
        Ep;
        %> matrix of permittivity distribution from current iteration
        Ep_map; 
        %> vector of permittivity distribution from previous iteration
        Ep_;      
        %> matrix of permittivity distribution from previous iteration
        Ep_map_; 
        %> vector of sensitivity distribution from current iteration
        S;  
        %> matrix of sensitivity distribution from current iteration
        S_map; 
                       
        %> vector of minimal permittivity distribution 
        Ep_min;
        %> matrix of minimal permittivity distribution 
        Ep_min_map;
        %> vector of maximal permittivity distribution 
        Ep_max;
        %> matrix of maximal permittivity distribution 
        Ep_max_map;
        
        %> capacitance normalized measurement
        Cm_n;                                    
        %> capacitance measurement from electrical field max object
        C_max;
        %> capacitance measurement from electrical field min object
        C_min;        
        %> capacitance measurement from reprojection
        Cr         
        %> capacitance vector for initial solution
        Cr_0;
     
        
        %> real data from file (e.g. capacitance data from ET3)
        data_from_file     
        %> flag 0-no real data 1-real values 
        real_data;                 
        
        %> set if previous image becomes current image
        step_back_flag=0;        
    end
    
    methods
        % =================================================================
        %> @brief Constructor.
        %>
        %> @param varargin{1} Ef_pha Electrical_field object with 'main' phantom
        %> @param varargin{2} Ef_max Electrical_field object with uniform max phantom 
        %> @param varargin{3} Ef_min Electrical_field object with uniform min phantom 
        %> @param varargin{4} Ef_avg Electrical_field object with uniform avg phantom         
        %>
        %> @return instance of the Reconstructor_2D class.
        % =================================================================                                   
        function rec_obj=Reconstructor_2D(varargin)
           if nargin == 0 ; % no input arguments
           elseif isa(varargin{1},'Reconstructor_2D')
            rec_obj = varargin{1}; % copy constructor
            display 'copy constructor Reconstructor_2D'
            return;
           else
               
               rec_obj.Ef_pha=varargin{1};
               rec_obj.Ef_max=varargin{2};
               rec_obj.Ef_min=varargin{3};                                            
               rec_obj.Ef_avg=varargin{4};
                                                          
               rec_obj.method='LM';
               rec_obj.numiter=151;
               rec_obj.stop_delta=1e-20;
               rec_obj.update_method='modulo';
               rec_obj.iter_mod=50;
               rec_obj.update_delta=0;
               rec_obj.alpha=0.05;
               rec_obj.alpha_=0.05; %alpha_=alpha;
               rec_obj.alphalimit='noadapt';
               rec_obj.regular='manual';
               rec_obj.u=0.05;
                                                                  
               rec_obj.matrix_size=rec_obj.Ef_pha.discret_matrix_size;
               
               Ef_pha=rec_obj.Ef_pha;
               Ef_max=rec_obj.Ef_max;
               Ef_min=rec_obj.Ef_min;                              
               Ef_avg=rec_obj.Ef_avg;
               
               rec_obj.step_back_flag=0;
               real_data=0;
               
            % #########################################################################
            % object we are looking for - unknown permittivity (epsilon) distribution
            % and the sensitivity calculated for this distribution (true model)
            %  1. numerical phantom - in case of simulation
            %  2. mathematical model - in case of reconstruction from real object
            %  3. maximum epsilon value when we do not know what we reconstruct
           
            rec_obj.Ep_Pha      = Ef_pha.Eps_fovImgToReconstruction;        % vector
            rec_obj.Ep_Pha_map  = Ef_pha.Eps_fovImgToReconstruction_map; % map
            rec_obj.S_Pha       = Ef_pha.S_resize;
            rec_obj.S_Pha_map   = Ef_pha.S_map_resize;
            
            
            % #########################################################################
            % maximum & minimum value permittivity (epsilon) distribution
            rec_obj.Ep_min = Ef_min.Eps_fovImgToReconstruction; 
            rec_obj.Ep_min_map = Ef_min.Eps_fovImgToReconstruction_map;
            rec_obj.Ep_max = Ef_max.Eps_fovImgToReconstruction; 
            rec_obj.Ep_max_map = Ef_max.Eps_fovImgToReconstruction_map;
            
            
            % #########################################################################            
            % initial (start) resize solution 
            % at this moment we start from uniform distribution with minimum value
            % or take a priori 
            rec_obj.Ep_0_map = Ef_avg.Eps_fovImgToReconstruction_map;
            rec_obj.Ep_0     = Ef_avg.Eps_fovImgToReconstruction;
           
            
            rec_obj.S_0     =  Ef_min.S_resize;
            rec_obj.S_0_map =  Ef_min.S_map_resize;            
            
            rec_obj.Ep      = rec_obj.Ep_0;      
            rec_obj.Ep_map  = rec_obj.Ep_0_map; 
            rec_obj.Ep_     = rec_obj.Ep_0;      
            rec_obj.Ep_map_ = rec_obj.Ep_0_map; 
            rec_obj.S       = rec_obj.S_0;  
            rec_obj.S_map   = rec_obj.S_0_map;
            
            % #########################################################################
            % reprojection - projection for initial solution
            rec_obj.C_max = rec_obj.S*rec_obj.Ep_max; 
            rec_obj.C_min = rec_obj.S*rec_obj.Ep_min; 

            rec_obj.Cr_0  = rec_obj.S*rec_obj.Ep;
            %Cr_0  = (Cr_0-C_min)./(C_max-C_min);

            % normalized measurement
            rec_obj.Cm_n = (Ef_pha.C-Ef_min.C)./(Ef_max.C-Ef_min.C);
            % Cm   = Cm_n;
            % projections denormalization using simulated max & min
            rec_obj.Cm   = rec_obj.C_min + rec_obj.Cm_n.*(rec_obj.C_max-rec_obj.C_min);
            rec_obj.Cr   = rec_obj.Cr_0;
                        
           end
        end
        
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
        %function  [Ep] = it_recon(varargin) 
        [Ep] = it_recon(varargin);
        
        % =================================================================
        %> @brief Compute regularization parameters 
        %>
        %> @param varargin regularization method and other parameters
        %> @return reg_params computed regularization parameters
        % =================================================================
        %function reg_params = regularization_method(varargin);
        reg_params = regularization_method(varargin);
        
        
        % =====================================================================
        %> @brief fuction reads measured data from a capacitance tomograph, and set
        %> this value to start solution
        %>
        %> @param file_name  a name of a file contained measuring data
        %> @param M          number of measurements
        %> @param frame1     number of frame contained capacitance measurements.
        %> @param frame2     number of frame contained capacitance measurements.
        %>
        %> @retval object.C_meas  capacitance maeaurements
        %> @retval object.C_min   minimal values of capacitances
        %> @retval object.C_max   maximal values of capacitances
        % =====================================================================
        %function [object] = read_data(rec_obj,file_name,M,frame1,frame2)
        [object] = read_data(rec_obj,file_name,M,frame1,frame2);
                                     
        % =================================================================
        %> @brief Display use during it_recon works
        % =================================================================
        function display(rec_obj)
           if mod(rec_obj.current_iter,rec_obj.iter_mod+1)==0 
            fh_cm = figure (3021);
            set(fh_cm,'Name','Measurements: max (\^), min (v), object (+), reprojection for current estimate (o)');
            plot(rec_obj.C_max,'r-^');
            hold on;
            plot(rec_obj.C_min,'g-v');
            plot(rec_obj.Cm,'k-+');
            plot(rec_obj.Cr,'b-o');
            hold off;
            title('Measurements: max (\^), min (v), object (+), reprojection for current estimate (o)');


            fh_cm2 = figure (3022);
            set(fh_cm2,'Name','C measured (+) and recalulated (o)');
            plot(rec_obj.Cm,'k-+');
            hold on;
            plot(rec_obj.Cr,'b-o');
            hold off;
            title('C measured (+) and recalulated (o)');

            fh_dc = figure (3023); 
            set(fh_dc,'Name','Cr - Cm');            
            Cr_Cm=rec_obj.Cr-rec_obj.Cm;
            plot(Cr_Cm,'r-*');
            title('Cr - Cm');
            xlabel('Pair of electrodes');
            ylabel('Capacitance difference');

            fh_err = figure(3024);
            set(fh_err,'Name','Normalized errors: Capacitance (+), Image (o), Sensitivity (\^)');
            rec_obj.xplot(rec_obj.errors.Cap,'k-','k+');
            hold on;
            rec_obj.xplot(rec_obj.errors.Imag,'b-','bo');
            rec_obj.xplot(rec_obj.errors.Sens,'g-','g^')
            hold off;
            title('Normalized errors: Capacitance (+), Image (o), Sensitivity (\^)');


           end
     
    
        if mod(rec_obj.current_iter,rec_obj.iter_mod+1)==0 
        % electrodes and screen have very high epsylon value
        
        Ep_draw=reshape(rec_obj.Ep_map,rec_obj.Ef_pha.simulation_discret_matrix_size,rec_obj.Ef_pha.simulation_discret_matrix_size);

        % drawedP = log(P+1); 
        vmax = max(max(Ep_draw)); 
        rec_obj.draw_map(3030,'Solution at i-th iteration',0,vmax, Ep_draw);
                
        end
        
   end
        
        % =================================================================
        %> @brief Display permittivity map in i-th iteration
        %>
        %> @param iter number of iteration        
        % =================================================================
        function Eps_at_iter(rec_obj,num)
            if (num<=rec_obj.maps_number)
                map=rec_obj.Ep_maps_iter(:,:,num);
                image(map,'cdatamapping','scaled');
                set(gca,'PlotBoxAspectRatio',[1,1,1]);
                min_v=min(min(map));
                max_v=max(max(map));
                if (max_v<=min_v)
                    max_v=max_v+1;
                end
                caxis([min_v,max_v]);
            end
        end
        
        % =================================================================
        %> @brief Draw reconstruction permittivity, sensitivity and
        %> capacitance errors on the same figure.
        % =================================================================
        function draw_errors(rec_obj)
            hold on;
            rec_obj.xplot(rec_obj.errors.Cap,'k-','k+');            
            rec_obj.xplot(rec_obj.errors.Imag,'b-','bo');
            rec_obj.xplot(rec_obj.errors.Sens,'g-','g^');
            hold off;
            title('Discrepancy: Capacitance (+), Image (o), Sensitivity (\^)');
            xlabel('Iteration')
            ylabel('Normalized errors');
        end
        
        % =================================================================
        %> @brief Draw maximal, minimal, measure and 'reconstruct'
        %> capacitances on the same figure.
        %
        %> @param numb number of 'reconstruct' capacitance
        % =================================================================
        function draw_all_capacitances(rec_obj,numb)
            plot(rec_obj.C_max,'r-^');
            hold on;
            plot(rec_obj.C_min,'g-v');
            % Cm is static (no change during it_recon compute)
            plot(rec_obj.Cm,'k-+');
            plot(rec_obj.Cr_iter(:,numb),'b-o');
            hold off;
            title(' Meas: max (\^), min (v), object (+), reprojection for current estimate (o)');
            ylabel('Capacitance difference [arbitrary units]');
            xlabel('Pair of electrodes');   
        end
        
        % =================================================================
        %> @brief Draw measured and i-th 'reconstruct' capacitance on the
        %> same figure.
        %
        %> @param numb number of 'reconstruct' capacitance
        % =================================================================
        function draw_Cm_Cr(rec_obj,numb)
            plot(rec_obj.Cm,'k-+');
            hold on;
            plot(rec_obj.Cr_iter(:,numb),'b-o');
            hold off;
            ylabel('Capacitance difference [arbitrary units]');
            xlabel('Pair of electrodes');
            title('C measured (+) and recalculated (o)');
        end
        
        % =================================================================
        %> @brief Draw difference between measured and i-th 'reconstruct'
        %> capacitance.
        %>
        %> @param numb number of 'reconstruct' capacitance
        % =================================================================
        function draw_capacitance_diff(rec_obj,num)
            Cr_Cm=rec_obj.Cr_iter(num)-rec_obj.Cm;
            plot(Cr_Cm,'r-*');
            title('Cr - Cm');
            xlabel('Pair of electrodes');
            ylabel('Capacitance difference [arbitrary units]'); 
        end
        
        % =================================================================
        %> @brief Draw algorithm parameters(step, updating, regularization values)                
        % =================================================================
        function draw_alg_params(rec_obj)
            plot(rec_obj.param.Alpha,'k-+');
            hold on;
            plot(rec_obj.param.U,'b-o');
            plot(rec_obj.param.Updating,'g-^');
    
            hold off;
            title('Algorithm parameters: Alpha (+), Regularization U (o),  Updating (\^)');
            xlabel('Iteration')
            ylabel('Parameter value');
        end
             
        % =================================================================
        %> @brief Draw real measured capacitances. First read file.        
        % =================================================================
        function draw_real_data_from_file(rec_obj)
            if(rec_obj.real_data==1)                
                fh_rdata=figure();            
                set(fh_rdata,'Name','Real Data Capacitance');
                hold on;
                plot(rec_obj.data_from_file.C_meas,'b-+');
                plot(rec_obj.data_from_file.C_max,'r-^');
                plot(rec_obj.data_from_file.C_min,'g-o');
                hold off;
                title('Real Data (Capacitance): Measured (+), Max (\^),  Min (o)');
                xlabel('Pair of electrodes');
                ylabel('Capacitance difference [arbitrary units]');
            else
                error('No data from real model to display. First read file.');
            end
        end
        
    end
    
    methods (Access=private)
        
        % =====================================================================
        %> @brief % step_length calculates optimal steps alpha and beta
        %> by minimizing |c-Se(i+1| norm for next step
        %> e(i+1)=e(i) + a inv(S'(SS'+uI))(c-Se(i))
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (column vector)
        %> @param Epp  previous estimation of permittivity distribution (column vector)
        %> @param u    Thikonov regularization factor for matrix pseudo inverse
        %> @retval alpha,beta optimal step lengths
        % =====================================================================
        %function [a b] = step_length(rec_obj,S,Cr,Cm,Ep,Epp,u)
        [a b] = step_length(rec_obj,S,Cr,Cm,Ep,Epp,u);
        
        % =====================================================================
        %> @brief alg_LBP calculates one step LBP
        %>
        %> @param Sn    sensitivity matrix normalized
        %> @param Cm_n  vector of measured normalizedcapacitances
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_LBP(rec_obj,Cm_n,Sn)
        Ep = alg_LBP(rec_obj,Cm,Sn);
                      
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
        %function [Cap_err Imag_err Sens_err] = recon_qual (rec_obj,Ep_Pha, S_Pha, Cm, Ep_0, S_0, Cr_0, Ep, S, Cr, scale)
        [Cap_err Imag_err Sens_err] = recon_qual (rec_obj,Ep_Pha, S_Pha, Cm, Ep_0, S_0, Cr_0, Ep, S, Cr, scale)
        
        
        % =====================================================================
        %> @brief fov_center gets center of fov from sensitivity maps 
        %>
        %> @param sensor     sensor object
        %> @param S_Pha_map  sensitivity map calculated for phantom or model
        %> @param S_0_map    sensitivity map calculated for initial solution Ep(0)
        %> @param S_map      sensitivity map calculated for current solution estimate S(i)
        %>
        %> @retval S_Pha   sensitivity matrix calculated for phantom or model
        %> @retval S_0     sensitivity matrix calculated for initial solution Ep(0)
        %> @retval S       sensitivity matrix calculated for current solution estimate S(i)
        % =====================================================================
        %function [S_Pha, S_0, S] = fov_center (rec_obj, sensor, S_Pha_map, S_0_map, S_map)
        [S_Pha, S_0, S] = fov_center (rec_obj, S_Pha_map, S_0_map, S_map);
        
        %[S]= reshape_sens(rec_obj,S_map, map_size, sens_matrix_num);
        
        % =====================================================================
        %> @brief alg_LevenMarq_Limit calculates one step of Levenberg Marquard iteration
        %> with constrain for permittivity value, that is not less than 1
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
        %> @param alfa relaxation factor (step length)
        %> @param u    Thikonov regularization factor for matrix pseudo inverse
        %> @param constrain 'constrain' to limit permittivity value
        %> @param lt   lower threshold
        %> @param ut   upper threshold
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_LevenMarq_Limit(rec_obj,S,Cr,Cm,Ep,alfa,u,constrain,lt,ut)
        Ep = alg_LevenMarq_Limit(rec_obj,S,Cr,Cm,Ep,alfa,u,constrain,lt,ut);
        
        % =====================================================================
        %> @brief alg_NewtonRa_Limit calculates one step of Newton Raphson iteration
        %> with constrain for permittivity value, that is not less than 1
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
        %> @param alfa relaxation factor (step length)
        %> @param u    Thikonov regularization factor for matrix pseudo inverse
        %> @param constrain 'constrain' to limit permittivity value
        %> @param lt   lower threshold
        %> @param ut   upper threshold
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_NewtonRa_Limit(rec_obj,S,Cr,Cm,Ep,alfa,u,constrain,lt,ut)
        Ep = alg_NewtonRa_Limit(rec_obj,S,Cr,Cm,Ep,alfa,u,constrain,lt,ut);
        
        % =====================================================================
        %> @brief alg_Landweber calculates one step of Landweber iteration
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
        %> @param alfa relaxation factor (step length)
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_Landweber(rec_obj,S,Cr,Cm,Ep,alfa)
        Ep = alg_Landweber(rec_obj,S,Cr,Cm,Ep,alfa);
        
        % =====================================================================
        %> @brief alg_Landweber_Norm calculates one step of modified Landweber iteration
        %>        with normalized transpose of S matrix
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
        %> @param alfa relaxation factor (step length)
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_Landweber_Norm(rec_obj,S,Cr,Cm,Ep,alfa)
        Ep = alg_Landweber_Norm(rec_obj,S,Cr,Cm,Ep,alfa);
        
        % =====================================================================
        %> @brief alg_LevenMarq_Limit calculates one step of Levenberg Marquard iteration
        %> with constrain for permittivity value, that is not less than 1
        %>
        %> @param S    sensitivity matrix
        %> @param Cr   vector of capacitances to be measured for current estimation of Ep
        %> @param Cm   vector of measured capacitances
        %> @param Ep   current estimation of permittivity distribution (previous step) in form of column vector
        %> @param Ep_  previous estimation of permittivity distribution 
        %> @param alfa relaxation factor (step length)
        %> @param beta acceleration
        %> @param u    Thikonov regularization factor for matrix pseudo inverse
        %> @param constrain 'constrain' to limit permittivity value
        %> @param lt   lower threshold
        %> @param ut   upper threshold
        %>
        %> @retval Ep (column vector) new better estimation of permittivity 
        % =====================================================================
        %function Ep = alg_LevenMarq_Limit3(rec_obj,S,Cr,Cm,Ep,Ep_,alfa,beta,u,constrain,lt,ut)
        Ep = alg_LevenMarq_Limit3(rec_obj,S,Cr,Cm,Ep,Ep_,alfa,beta,u,constrain,lt,ut)
        
        % =====================================================================
        %> @brief xplot plots lines with markers better than original one
        %>
        %> @param vector values to plot (vector)
        %> @param line    line color and shape
        %> @param marker  marker color and shape
        %> @retval out return value of this method
        % =====================================================================
        %function[] = xplot(rec_obj,vector, line, marker)
        [] = xplot(rec_obj,vector, line, marker);
        
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
        %function [res]=draw_map(rec_obj,figno,name,lt,ut,map)
        [res]=draw_map(rec_obj,figno,name,lt,ut,mask,flag,map);
        
    end % private methods
    
end
