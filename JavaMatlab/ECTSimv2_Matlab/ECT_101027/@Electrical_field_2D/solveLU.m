% =====================================================================
%> @brief solveLU performs backward step of Gauss elimination calculates potential distrubutions 
%> using matrix A and many vectors of free elements (boundary conditions)
%>
%> @param m witdh of matrix band
%> @param A  matrix of linear system for potential distribution
%> @param B  vectors with boundary conditions
%>
%> @retval V potential matrix to solve
% =====================================================================
function [V] = solveLU(ef_obj,m,A,B)

global data_type;


% solve upper triangular
n=size(A,1);
V=zeros(n,1,data_type);

% back step
for i=n:-1:1
    sum = 0;
    stop = min(i+m,n);
    for k=i+1:stop
        sum=sum + A(i,k)*V(k);
    end;
    dif = B(i)-sum;
    V(i) = dif/A(i,i);
end;

