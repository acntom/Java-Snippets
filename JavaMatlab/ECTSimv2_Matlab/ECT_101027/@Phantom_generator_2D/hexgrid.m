% ======================================================================
%> @brief Hexgrid generates list of nodes of hexagonal grid 
%>
%> @param x0 x position of grid center, (x,0) - center of image
%> @param y0 y position of grid center, (0,y) - center of image
%> @param sizeX x side size of image [mm]
%> @param sizeY y side size of image [mm]
%> @param d  diameter of (node) circle 
%> @param D  node size 
%> @param ang1 grid rotation
%> @param ang2 not for use, should be 0
%>
%> @retval X,Y  cartesian coordinates of nodes
%> @retval W,H  node width and height (= diameter of circle)
%> @retval A,R  polar coordinates of nodes
% =====================================================================
function [X Y W H A R] = hexgrid(phobj,x0,y0,sizeX,sizeY,d,D,ang1,ang2)

%liczenie wektorów siatki
[v1(2),v1(1)] = pol2cart(mod(ang1,60)*2*pi/360,D);
[v2(2),v2(1)] = pol2cart((mod(ang1,60)+60+(mod(ang2,60)))*2*pi/360,D);

%generacja siatki kó³

ind = 1;
for i=1:1:sizeX/D
    for j=0:1:sizeY/D
        x = i*v1(1) + j*v2(1);
        y = i*v1(2) + j*v2(2);
        [a r] = cart2pol(x,y);
        %if x<sizeX/2 && y<sizeY/2 && x>-sizeX/2 && y>-sizeY/2
        if r<(sizeX/2-d/2)
            X(ind) = x;
            Y(ind) = y;
            W(ind) = d;
            H(ind) = d;
            A(ind) = a;
            R(ind) = r;
            ind = ind + 1;
        end
    end
    for j=-1:-1:-2*sizeY/D
        x = i*v1(1) + j*v2(1);
        y = i*v1(2) + j*v2(2);
        [a r] = cart2pol(x,y);
        %if x<sizeX/2 && y<sizeY/2 && x>-sizeX/2 && y>-sizeY/2
        if r<(sizeX/2-d/2)
            X(ind) = x;
            Y(ind) = y;
            W(ind) = d;
            H(ind) = d;
            A(ind) = a;
            R(ind) = r;
            ind = ind + 1;
        end
    end
end
for i=0:-1:-sizeX/D
    for j=0:1:sizeY/D
        x = i*v1(1) + j*v2(1);
        y = i*v1(2) + j*v2(2);
        [a r] = cart2pol(x,y);
        %if x<sizeX/2 && y<sizeY/2 && x>-sizeX/2 && y>-sizeY/2
        if r<(sizeX/2-d/2)
            X(ind) = x;
            Y(ind) = y;
            W(ind) = d;
            H(ind) = d;
            A(ind) = a;
            R(ind) = r;
            ind = ind + 1;
        end
    end
    for j=-1:-1:-2*sizeY/D
        x = i*v1(1) + j*v2(1);
        y = i*v1(2) + j*v2(2);
        [a r] = cart2pol(x,y);
        %if x<sizeX/2 && y<sizeY/2 && x>-sizeX/2 && y>-sizeY/2
        if r<(sizeX/2-d/2)
            X(ind) = x;
            Y(ind) = y;
            W(ind) = d;
            H(ind) = d;
            A(ind) = a;
            R(ind) = r;
            ind = ind + 1;
        end
    end
   
end