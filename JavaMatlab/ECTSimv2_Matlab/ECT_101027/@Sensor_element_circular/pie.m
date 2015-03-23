% =====================================================================
%> @brief Draw fragment of circle
%>
%> @param xc,yc center of piece
%> @param d1,d2 diameter_1,diameter_2 (d1 < d2)
%> @param a1,a2 start angle,stop angle a1 < a2
%> @param line,points use to display (optional)
% =====================================================================
function pie(s_obj,xc,yc,d1,d2,a1,a2,line,points)

if nargin==7
    line = '-g';
    points = '-g';
end

% otherwise function will work wrong
if(d1>d2)    
    tmp1=d1;
    tmp2=d2;
    d1=tmp2;
    d2=tmp1;
end

if(a1>a2)
    tmp1=a1;
    tmp2=a2;
    a1=tmp2;
    a2=tmp1;
end
    

if ((a1<a2))

a=a1*pi/180:pi/90:a2*pi/180;

r1=d1/2;
r2=d2/2;

[x y] = pol2cart(a,r1);
x1 = x + xc;
y1 = y + yc;

plot(x1,y1,line,x1,y1,points);

[x y] = pol2cart(a,r2);
x2 = x + xc;
y2 = y + yc;
plot(x2,y2,line,x2,y2,points);
if((a1==360 && a2==360) || (a1==0 && a2==0))
    %do nth
%ax+b=y;
elseif((a1==0)&&(a2==360))
    %do nth
else
    %1
    Y=[y1(1);
       y2(1)];
    A=[x1(1) 1;
       x2(1) 1];
    %AX=B;
    X=A\Y;

    if((a1<90)&&(180<a1<270)||(a1==360))
        X_line=x1(1):0.01:x2(1);
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end

    if(a1==90)
        Y_line=y1(1):0.1:y2(1);
        X_line(1:length(Y_line))=x1(1);    
        plot(X_line,Y_line,line);
    end
    if(90<a1<180)
        X_line=x2(1):0.01:x1(1);
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end
    if(a1==180)
        X_line=x2(1):0.01:x1(1);
        Y_line(1:length(X_line))=y1(1);
        plot(X_line,Y_line,line);
    end
    if(a1==270)
        Y_line=y2(1):0.1:y1(1);
        X_line(1:length(Y_line))=x1(1);    
        plot(X_line,Y_line,line);
    end
    if(270<a1<360)
        X_line=x1(1):0.01:x2(1);
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end
    
    %2
    %second



    Y=[y1(length(y1));
       y2(length(y2))];
    A=[x1(length(x1)) 1;
       x2(length(x2)) 1];
    %AX=B;
    X=A\Y;

    % if(a2<90)
    %     X_line=x1(length(x1)):0.01:x2(length(x2));
    %     Y_line=X(1)*X_line+X(2);
    %     plot(X_line,Y_line,line);
    % end

    if((a2<90)&&(180<a2<270)||(a2==360))
        X_line=x1(length(x1)):0.01:x2(length(x2));
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end

    if(a2==90)
        Y_line=y1(length(y1)):0.1:y2(length(y2));
        X_line(1:length(Y_line))=x1(length(x1));    
        plot(X_line,Y_line,line);
    end
    if(90<a2<180)
        X_line=x2(length(x2)):0.01:x1(length(x1));
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end
    if(a2==180)
        X_line=x2(length(x2)):0.01:x1(length(x1));
        Y_line(1:length(X_line))=y1(length(y1));
        plot(X_line,Y_line,line);
    end
    if(a2==270)
        Y_line=y2(length(y2)):0.1:y1(length(y1));
        X_line(1:length(Y_line))=x1(length(x1));    
        plot(X_line,Y_line,line);
    end
    if(270<a2<360)
        X_line=x1(length(x1)):0.01:x2(length(x2));
        Y_line=X(1)*X_line+X(2);
        plot(X_line,Y_line,line);
    end

    
end
end


