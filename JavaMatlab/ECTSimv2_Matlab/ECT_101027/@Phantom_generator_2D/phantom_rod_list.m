% ======================================================================
%> @brief % phantom_rod_list generates list of structures for ellipse objects
%> structure: 
%> center of ellipse, axes, ellipse rotation, permittivity value, polar
%> coordinates of ellipse
%>
%> @param imsize diameter of field of view  
%> @param beta object rotation (use to fit numeric to real object)[mm]
%> @param d circle [mm]
%> @param D node [mm]
%> @param eps_value permittivity value for all rods
%>
%> @retval el list of structures for rod parameters
% =====================================================================
function [el] = phantom_rod_list(phobj,imsize,d,D, beta, eps_value)

global data_type

x_o=0;
y_o=0;

[x y w h a r] = phobj.hexgrid(x_o,y_o,imsize,imsize,d,D,beta,0);
if strcmp(phobj.phantom_name,'ask_me')
figure;
phobj.hexplot(x_o,y_o,imsize,imsize,d,D,beta,'index',1);

i=1;
work=1;
%indx=[];
while work
%     str='Select rod from picture. e-exit or write one number : ';   
%     num=input(str,'s'); % read to string    

    prompt = {'Select rod from picture.Type ''''e'''' to exit or type one number : '};
    dlg_title = 'Input for phantom';
    num_lines = 1;
    def = {'1','hsv'};
    num = inputdlg(prompt,dlg_title,num_lines,def);
    
    if (strcmp(num,'e'))
        work=0;        
    elseif str2double(num)>length(x)
        errordlg('Number is too big','error')
        error('Number is too big');
    else    
            num=round(str2double(num));
            indx(i)=num;
            i=i+1;            
    end
end
elseif strcmp(phobj.phantom_name,'rods_indx')
    indx=phobj.indx;
end


V = eps_value*ones(1,length(indx));
                
if isempty(indx)
      error('Phantom object is empty ');
end

for k=1:length(indx)
    i = indx(k);
    X(k) = x(i); 
    Y(k) = y(i);
    W(k) = w(i); 
    H(k) = h(i);
    A(k) = a(i); 
    R(k) = r(i);
end

for i=1:length(indx)
    r = R(i);
    alpha = A(i);
    a = W(i)/2;
    b = H(i)/2;
    v = V(i);
    el(i,1)=-r*sin(alpha);
    el(i,2)=r*cos(alpha);
    el(i,3)=a;
    el(i,4)=b;
    el(i,5)=0;
    el(i,6)=v;
end
