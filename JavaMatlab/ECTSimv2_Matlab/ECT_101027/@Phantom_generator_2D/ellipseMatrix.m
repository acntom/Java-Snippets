% ======================================================================
%> @brief  Set the elements of the Matrix Image which are in the interior of the
%> ellipse E with the value 'color'. The ellipse E has center (y0, x0), the
%> major axe = a, the minor axe = b, and teta is the angle macked by the
%> major axe with the orizontal axe.
%>
%> @param y0 center of ellipse - y coordinate
%> @param x0 center of ellipse - x coordinate
%> @param a major axe
%> @param b minor axe
%> @param teta angle
%> @param Image image
%> @param color
%>
%> @retval ret elipse object
% =====================================================================
function ret = ellipseMatrix(phobj,y0, x0, a, b, teta, Image, color)

if a==0 & b==0
    ret = Image;
    return;
end


im = Image;
[ny, nx] = size(im);
imtemp = zeros(ny, nx);
list = zeros(ny * nx, 2);
toplist = 1;
c = sqrt(a * a - b * b);

%x0 = round(x0);
%y0 = round(y0);
list(toplist, 1) = round(y0);
list(toplist, 2) = round(x0);
im(round(y0), round(x0)) = im(round(y0), round(x0))+color;
imtemp(round(y0), round(x0)) = imtemp(round(y0), round(x0))+color;

while (toplist > 0)
    y = list(toplist, 1);
    x = list(toplist, 2);
    toplist = toplist - 1;
    
    if local_isValid(y, x + 1, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y;
        list(toplist, 2) = x + 1;
        im(list(toplist, 1), list(toplist, 2)) = im(list(toplist, 1), list(toplist, 2))+color;
        imtemp(list(toplist, 1), list(toplist, 2)) = imtemp(list(toplist, 1), list(toplist, 2))+color;        
    end
    if local_isValid(y - 1, x, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y - 1;
        list(toplist, 2) = x;
        im(list(toplist, 1), list(toplist, 2)) = im(list(toplist, 1), list(toplist, 2))+color;
        imtemp(list(toplist, 1), list(toplist, 2)) = imtemp(list(toplist, 1), list(toplist, 2))+color;        
    end
    if local_isValid(y, x - 1, y0, x0, a, c, teta, imtemp, ny, nx, color)
        toplist = toplist + 1;
        list(toplist, 1) = y;
        list(toplist, 2) = x - 1;
        im(list(toplist, 1), list(toplist, 2)) = im(list(toplist, 1), list(toplist, 2))+color;
        imtemp(list(toplist, 1), list(toplist, 2)) = imtemp(list(toplist, 1), list(toplist, 2))+color;        
    end
    if local_isValid(y + 1, x, y0, x0, a, c, teta, imtemp, ny, nx, color) == 1
        toplist = toplist + 1;
        list(toplist, 1) = y + 1;
        list(toplist, 2) = x;
        im(list(toplist, 1), list(toplist, 2)) = im(list(toplist, 1), list(toplist, 2))+color;
        imtemp(list(toplist, 1), list(toplist, 2)) = imtemp(list(toplist, 1), list(toplist, 2))+color;        
    end
end
ret = im;


%--------------------------------------------------------------------------
function is_val = local_isValid(y, x, y0, x0, a, c, teta, im, ny, nx, color)

%     y=y-0.5; x=x-0.5;
%     y0=y0-0.5; x0=x0-0.5;
    d1 = (x - x0 - c * cos(teta))^2 + (y - y0 - c * sin(teta))^2;
    d1 = sqrt(d1);
    d2 = (x - x0 + c * cos(teta))^2 + (y - y0 + c * sin(teta))^2;
    d2 = sqrt(d2);
    if (x>0) && (y>0) && (x <= nx) && (y <= ny) &&  ...
            (d1 + d2 <= 2*a) && (im(round(y), round(x)) ~= color)
        is_val = 1;
    else
        is_val = 0;
    end