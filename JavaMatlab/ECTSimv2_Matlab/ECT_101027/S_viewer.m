function varargout = S_viewer(varargin)
% S_VIEWER M-file for S_viewer.fig
%      Run file from main program directory
%      S_VIEWER, by itself, creates a new S_VIEWER or raises the existing
%      singleton*.
%
%      H = S_VIEWER returns the handle to a new S_VIEWER or the handle to
%      the existing singleton*.
%
%      S_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in S_VIEWER.M with the given input arguments.
%
%      S_VIEWER('Property','Value',...) creates a new S_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before S_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to S_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help S_viewer

% Last Modified by GUIDE v2.5 18-Aug-2010 20:28:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @S_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @S_viewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% =====================================================================
%> @brief Executes just before S_viewer is made visible. Search for
%> Electrical field objects. Set them  in list box. Plot third sensitivity
%> distribution map.
% =====================================================================
function S_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to S_viewer (see VARARGIN)

% Choose default command line output for S_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

update_listbox(handles);

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

     komenda=[var1,'.draw_sensitivity(','3',');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda); 
% This sets up the initial plot - only do when we are invisible
% so window can get raised using S_viewer.


% UIWAIT makes S_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = S_viewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% =====================================================================
%> @brief Executes on button press in update. 
%> Set active selected Electrical_field object. Set active selected sensitivy map
%> display from pop-up menu Sensitivity or Resize sensitivity 
% =====================================================================
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axessens);
%cla;
popup_val = get(handles.popupmenu1, 'Value');


list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

%'Sensitivity'
if(popup_val==1)% original sensitivity
     komenda=[var1,'.draw_sensitivity(1);'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);  
     
elseif (popup_val==2) % resize sensitivity
     param=[var1,'.simulation_discret_matrix_size'];
     komenda=[var1,'.draw_resize_sensitivity(','1,',param,',',param,',','0);'];       
     evalin('base',komenda);  
end





% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Sensitivity', 'Resize_Sensitivity'});


% =====================================================================
%> @brief Executes on slider movement. 
%> Change and display sensitivity map for selected Electrical_filed object.
% =====================================================================
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


axes(handles.axessens);
%cla;

popup_val = get(handles.popupmenu1, 'Value');

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 


sliderValue = get(handles.slider1,'Value');
val=round(sliderValue);
% get from workspace
sens_num_max=evalin('base',[var1,'.sens_matrix_num']);
set(handles.slider1,'Max', sens_num_max);
if (~isnumeric(val))
    val=1;
end

if(val<=0)
    val=1;
elseif (val>sens_num_max)
    val=1;
end
%'Sensitivity'
if(popup_val==1)
     komenda=[var1,'.draw_sensitivity(',num2str(val),');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');    
     evalin('base',komenda);     
elseif (popup_val==2)
     param=[var1,'.simulation_discret_matrix_size'];
     komenda=[var1,'.draw_resize_sensitivity(',num2str(val),',',param,',',param,',','0);'];
     %komenda=[var1,'.draw_resize_sensitivity(','1,',param,',',param,',','0);'];      
     evalin('base',komenda);     
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% =====================================================================
%> @brief Search for Electrical field objects in workspace.
% =====================================================================
function update_listbox(handles)
% http://www.mathworks.com/access/helpdesk/help/techdoc/creating_guis/f6-7673.html
vars = evalin('base','who');
k=1;
any_elements=0;
for i=1:length(vars);
        
    komenda=['isa(',vars{i},',','''Electrical_field_2D''',');'];    
    ret = evalin('base',komenda);    
    if ret==1
        ef_vector(k)=vars(i);
        k=k+1;
        any_elements=1;
    end
end
if any_elements==0
    errordlg('There is''t Electrical_field object in workspace. First run simulation.',...
        'Error');
    error('There is''t Electrical_field object in workspace. First run simulation.');
end

set(handles.listbox1,'String',ef_vector)

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% =====================================================================
%> @brief Executes on button sum press. Draw sum of sensitivity maps.
% =====================================================================
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

popup_val = get(handles.popupmenu1, 'Value');

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 


%'Sensitivity'
if (popup_val==1)
 fh_sum = figure;
 name=[var1,' Sensitivity Map Sum'];
 set(fh_sum,'Name',name);
 komenda=[var1,'.draw_sum_S_map();'];
 evalin('base',komenda);
 
elseif (popup_val==2)
    
 fh_sum = figure;
 name=[var1,' Resize Sensitivity Map Sum'];
 set(fh_sum,'Name',name);
 komenda=[var1,'.draw_sum_resize_S_map();'];
 evalin('base',komenda);   
  
end



function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double


% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% =====================================================================
%> @brief Executes on button inv press. Draw inverse sensitivity sum in new
%> figure.
% =====================================================================
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


param_u = get(handles.edit,'String');

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 


% draw inverse S_map sum

 fh_inv_sum = figure;
 name=[var1,' Inverse Sensitivity Map Sum'];
 set(fh_inv_sum,'Name',name);
 komenda=[var1,'.draw_inv_S_map(',param_u,');'];
 evalin('base',komenda);   
 
