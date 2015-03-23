% ======================================================================
%> @brief phantom_generate generates map with phantom described by eliptic
%> elements
%>
%> @param mm      'square matrix' side size in [mm]
%> @param         side size matrix in pixels
%> @param el      vector with elipses (structure)
%> @param defVal  permittivity in FOV
%>
%> @retval ph  map of permittivity distribution 
% =====================================================================
function ph = phantom_generate(phobj,mm,siz,el,defVal)

    % elements is vector of structures
    % midpoint  [x0,y0]
    % axes      [a,b]
    % theta     [th]
    % value     [v]
    
    % calculate pixelsize
    ps=mm/siz;
    phmid=mm/2; 
    % create fov image
    ph=ones(siz,siz)*defVal;
    % get number of phantom elements
    n=size(el);    
    for i=1:n,
            % recalculate element sizes from mm to pixels (0,0) point is in the
            % middle of phantom
            
            x0=(el(i,1)+phmid)/ps+0.5;
            y0=(el(i,2)+phmid)/ps+0.5;
            a=el(i,3)/ps;
            b=el(i,4)/ps;
            th=el(i,5);
            v=el(i,6);
            ph=phobj.ellipseMatrix(x0,y0,a,b,th,ph,-defVal);
            ph=phobj.ellipseMatrix(x0,y0,a,b,th,ph,v);
            
        end
    return;