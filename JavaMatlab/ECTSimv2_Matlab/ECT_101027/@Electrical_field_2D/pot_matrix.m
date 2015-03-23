% =====================================================================
%> @brief pot_matrix creates matrix for potential equation using list of
%> points
%>
%> @param discret_matrix_size    side size of matrix
%> @param potential_points_idx   index use to potential computing
%> @param potential_points_iidx  index to first col of pidx where boundary is set
%> @param P                      map of permittivity distribution
%> @param method - method of calculation of coefficients
%>         'gauss' - (default) using gauss law (integral eqation)
%>         'kirchhof' - calculating potential using capacitor mesh and
%>          Kirchhof law
%>         'finite difference' - not implemented
%>
%> @retval A(pixnum,pixnum) where pixnum is the number of unknown potential points
% =====================================================================
function A=pot_matrix(ef_obj,discret_matrix_size,potential_points_idx,potential_points_iidx,P,method)

global data_type;

disp 'potential matrix - creating';

if nargin==5
    method = 'gauss';
end

% number of rows in potential equation matrix = 
%   number of 'big' (i.e. field of view) pixels - sensor.unknowns
%   + number of small pixels where potential is calculated -
%   sensor.unknowns2 
%   + 2*sensor.discret_matrix_size - this is required because of width of
%   coefficients band

band = discret_matrix_size; 

pidx = potential_points_idx;
vidx = potential_points_iidx + band;

s2 = size(pidx,1) + ...
     2*band;             % diagonal band width
% s2 = sensor.discret_matrix_size^2;              % full

A = zeros(s2,s2,data_type);

                               
rows = discret_matrix_size;
cols = discret_matrix_size;

if strcmp(method, 'gauss')==1
    disp 'pot_matrix - 'gauss'';
    for k=band+1:band+size(pidx,1)

        n=pidx(k-band,1);
        i=pidx(k-band,2);
        j=pidx(k-band,3);

        if pidx(k-band,4)==0  % calculate voltage
            % this may generate problem on the edge
            % arythmetic mean
            a1=P(i,j)+P(i,j-1);
            A(k,vidx(n-rows)) = a1;
            a2=P(i,j)+P(i-1,j);
            A(k,vidx(n-1)) = a2;
            a3=P(i,j)+P(i+1,j);
            A(k,vidx(n+1)) = a3;
            a4=P(i,j)+P(i,j+1);
            A(k,vidx(n+rows)) = a4;
            %A(k,k)=-(4*P(i,j)+P(i+1,j)+P(i,j+1)+P(i-1,j)+P(i,j-1));
            A(k,k)=-(a1+a2+a3+a4);
        else % boundary voltage
            A(k,k)=1;
        end

    %  if j==51 & i==28
    %      P(i,j),P(i,j-1),P(i-1,j),P(i+1,j),P(i,j+1)
    %      a1, a2, a3, a4, A(n,n)
    %  end

    end
elseif strcmp(method,'kirchhof')==1
    disp 'pot_matrix - 'kirchhof'';
    for k=band+1:band+size(pidx,1)

        n=pidx(k-band,1);
        i=pidx(k-band,2);
        j=pidx(k-band,3);
        
        if pidx(k-band,4)==0  % calculate voltage
            % this may generate problem on the edge
            % capacitor mesh
            a1=(P(i,j)*P(i,j-1))/(P(i,j)+P(i,j-1));
            A(k,vidx(n-rows)) = a1;
            a2=(P(i,j)*P(i-1,j))/(P(i,j)+P(i-1,j));
            A(k,vidx(n-1)) = a2;
            a3=(P(i,j)*P(i+1,j))/(P(i,j)+P(i+1,j));
            A(k,vidx(n+1)) = a3;
            a4=(P(i,j)*P(i,j+1))/(P(i,j)+P(i,j+1));
            A(k,vidx(n+rows)) = a4;
            A(k,k)=-(a1+a2+a3+a4);
        else % boundary voltage
            %A(k,k)=1;
        end

    %  if j==51 & i==28
    %      P(i,j),P(i,j-1),P(i-1,j),P(i+1,j),P(i,j+1)
    %      a1, a2, a3, a4, A(n,n)
    %  end

     end
else
    disp 'pot_matrix - Not implemented';
end


% zeros are not recomended on the diagonal
for ii=1:size(A,1);
    if sum(abs(A(ii,:)))==0
        A(ii,ii)=1;
    end
end

% debug
% n=52+(26-1)*sensor.matrix_size;
% A(n,n)=1;
%     h=figure(1000);
% set(h,'Name','PotMatrix');
% image(A*100,'cdatamapping','scaled');
% set(gca,'PlotBoxAspectRatio',[1,1,1]);
% drawnow;


% draw=1;
% if draw==1
    %h=figure(301);
    %set(h,'Name','Macierz równania potencja³u');

    %spy(A);
    %rank (A)
    %det (A)

    %figure(302);
    %plot(svd(A));
%     drawnow;
% end

disp 'potential matrix. end.';

