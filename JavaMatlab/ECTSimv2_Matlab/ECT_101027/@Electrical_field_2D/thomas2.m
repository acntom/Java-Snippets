% =====================================================================
%> @brief thomas2 creates upper triangular matrix using band diagonal
%> structure of matrix
%>
%> @param rows       rows number of potential matrix 
%> @param cols       cols number of potential matrix 
%> @param A          potential matrix
%> @param elnum      number of electrodes, number of columns in B matrix of free elements 
%> @param B          boundary conditions - maps of applied voltage
%>
%> @retval A - upper triangular matrix
%> @retval B - vector of free elements
% =====================================================================
function [A,B] = thomas2(ef_obj,rows,cols,A,elnum,B)

disp 'matrix upper triangular - calculating';

sizematrix=size(A,1);

%rank (A)
%det (A)
%figure(303);
%plot(svd(A));


for i=1:sizematrix
for r=1:rows
    if (i+r>sizematrix)
        continue;
    end
    if (A(i+r,i)~=0)
        stop  = i+rows+r;
        if (stop>sizematrix) 
            stop=sizematrix;
        end
        k = A(i+r,i)/A(i,i);
        for j=i:stop
            % ustaw wyrazy macierzy
            A(i+r,j)=A(i+r,j)-A(i,j)*k;
            
            if (abs(A(i+r,j))<0.000000001)
                A(i+r,j)=0;
            end
        end
        % ustaw element wolny (we wszystkich elnum kolumnach wyrazów wolnych)
        for el=1:elnum
            B(i+r,el)=B(i+r,el)-B(i,el)*k;
        end
    end
end
end

% draw=1;
% if draw
    %h=figure(304);
    %set(h,'Name','Macierz gorna trojkatna');
%     spy(A);

    %rank (A)
    %det (A)
    %figure(301);
    %plot(svd(A));
%     drawnow;
% end

disp 'matrix upper triangular. end.';
