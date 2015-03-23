% =====================================================================
%> @brief hexplot plots circles in hexagonal grid
%>
%> @param x0 x position of grid center, (x,0) - center of image
%> @param y0 y position of grid center, (0,y) - center of image
%> @param sizeX x side size of image [mm]
%> @param sizeY y side size of image [mm]
%> @param d diameter of (node) circle
%> @param D node size
%> @param ang1 grid rotation
%> @param mode 'polar' plots all circles with polar coordinates
%>             'cart'  plots all circles with carthesian coordinates
%>             'index' plots all circles with index
%>             'rods'  plots rods
%>             'rods2' plots all circles and rods
% =====================================================================
function hexplot(phobj,x0,y0,sizeX,sizeY,d,D,ang1,mode,indx)

fsize = 9;

% calculate hexagonal grid of rods (holes)
[x y w h a r] = phobj.hexgrid(x0,y0,sizeX,sizeY,d,D,ang1,0);

% draw big circle - FOV of sensor
phobj.circle(x0, y0, sizeX);
    
% draw all holes with description - position in polar system (r,a)
if strcmp(mode,'polar')==1
    for i=1:length(x)
        phobj.circle(x(i), y(i), w(i));
        [str err] = sprintf('%5.1f,%5.1f', r(i), a(i)*180/pi);
        text(x(i),y(i), str,'HorizontalAlignment','center','FontSize',fsize);
    end
end

% draw all holes with description - position in carthesian system (x,y)
if strcmp(mode,'cart')==1
    for i=1:length(x)
        phobj.circle(x(i), y(i), w(i));
        [str err] = sprintf('%5.1f,%5.1f', x(i), y(i));
        text(x(i),y(i), str,'HorizontalAlignment','center','FontSize',fsize);
    end
end

% draw all holes (position on the list)
if strcmp(mode,'index')==1
    for i=1:length(x)
        phobj.circle(x(i), y(i), w(i), '--b','--b');
        [str err] = sprintf('%3.0f', i);
        text(x(i),y(i), str,'HorizontalAlignment','center','FontSize',fsize);
    end
end

if strcmp(mode,'rods')==1 || strcmp(mode,'rods2')==1
    if strcmp(mode,'rods2')==1
        for i=1:length(x)
            phobj.circle(x(i), y(i), w(i), '--b','--b');
        end
    end
    % draw six rods with description
    for k=1:length(indx)
        i = indx(k);
        phobj.circle(x(i), y(i), w(i), '-k','k');

        [str err] = sprintf('%5.1f,%5.1f', r(i), a(i)*180/pi);
        text(x(i),y(i)-h(i), str,'HorizontalAlignment','center','FontSize',fsize);
    end
end

drawnow;
set(gca,'PlotBoxAspectRatio',[1,1,1]);