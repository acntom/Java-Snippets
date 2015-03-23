% =====================================================================
%> @brief Draw circle.
%>
%> @param xc center of circle - x coordinate
%> @param yc center of circle - y coordinate
%> @param d diameter
%> @param line line - display parameter  
%> @param points points - display parameter
%> @retval ret return value of this method
% =====================================================================
function circle(phobj,xc,yc,d,line,points)

if nargin==4
    line = '-k';
    points = 'k';
end

a=0:pi/90:2*pi;
r=d/2;
[x y] = pol2cart(a,r);
x = x + xc;
y = y + yc;

hold on;
plot(x,y,line,x,y,points);
hold off;


