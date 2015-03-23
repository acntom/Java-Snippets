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
function [object] = read_data(rec_obj,file_name,M,frame1,frame2)

if nargin == 3
    frame1 = 3;
    frame2 = 3;
end

% ECT3 export text file
% 1st column is frame time [ms]
% 1st line are data for full filled sensor or maximum permittivity
% 2nd line are data for empty sensor or minimum permittivity
% 3rd and following lines are frames data
% frame data are normalized Cn=(C-Cmin)/(Cmax-Cmin);
C_max = dlmread(file_name,'',[0 1 0 M])'; 
C_min = dlmread(file_name,'',[1 1 1 M])';
%C_min = object.C_min;

% read frame data and denormalize
C_n  = dlmread(file_name,'',[frame1 1 frame2 M]);
% TODO error when frame1 = frame2
C    = mean(C_n,1)';
C_un = C_min + C.*(C_max-C_min);

rec_obj.real_data=1;
% STATISTICS
c_n = C_n';
parfor i=1:size(c_n,2)
    c_un(:,i) = C_min + c_n(:,i).*(C_max-C_min);
end
c_un = c_un';
c_mean = mean(c_un,1);
c_std = std(c_un);


object.C_max  = C_max;
object.C_min  = C_min;
object.C_meas = C_un;

rec_obj.data_from_file=object;


      % #########################################################################
            % reprojection - projection for initial solution
              
             rec_obj.C_max = C_max; 
             rec_obj.C_min = C_min; 
            
            
            rec_obj.Cr_0  = rec_obj.S*rec_obj.Ep;
            %Cr_0  = (Cr_0-C_min)./(C_max-C_min);

            % normalized measurement
            rec_obj.Cm_n = (C_un-C_min)./(C_max-C_min);
            %Cm   = Cm_n;
            % projections denormalization using simulated max & min
            rec_obj.Cm   = rec_obj.C_min + rec_obj.Cm_n.*(rec_obj.C_max-rec_obj.C_min);
            rec_obj.Cr   = rec_obj.Cr_0;
