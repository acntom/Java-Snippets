% =====================================================================
%> @brief GUI use to display potential distribution, capacitances and
%> potential  map sum.
% =====================================================================
function varargout = Pot_viewer(varargin)
% POT_VIEWER M-file for Pot_viewer.fig
%      Run file from main program directory
%      POT_VIEWER, by itself, creates a new POT_VIEWER or raises the existing
%      singleton*.
%
%      H = POT_VIEWER returns the handle to a new POT_VIEWER or the handle to
%      the existing singleton*.
%
%      POT_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POT_VIEWER.M with the given input arguments.
%
%      POT_VIEWER('Property','Value',...) creates a new POT_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pot_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pot_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pot_viewer

% Last Modified by GUIDE v2.5 18-Aug-2010 20:56:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pot_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @Pot_viewer_OutputFcn, ...
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
%> @brief Executes just before Pot_viewer is made visible. Search for
%> Electrical field objects. Set them  in list box. Plot first potential
%> distribution.
% =====================================================================
function Pot_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pot_viewer (see VARARGIN)

% Choose default command line output for Pot_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


update_listbox(handles)

axes(handles.axessens);
%cla;
%set(handles.axessens,'PlotBoxAspectRatio',[1,1,1]);
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

     komenda=[var1,'.draw_potential(','1',');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);     

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Pot_viewer.


% UIWAIT makes Pot_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pot_viewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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

delete(handles.figure1);


% =====================================================================
%> @brief Executes on slider movement. Change potential map.
% =====================================================================
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


axes(handles.axessens);
%cla;
%set(handles.axessens,'PlotBoxAspectRatio',[1,1,1]);
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
pot_num_max=evalin('base',[var1,'.number_of_electrodes;']);% its equal to number of pot. maps
set(handles.slider1,'Max', pot_num_max);
if(val<=0)
    val=1;
elseif (val>pot_num_max)
    val=1;
end
%'Sensitivity'

     komenda=[var1,'.draw_potential(',num2str(val),');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);     


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
%> @brief Executes on selection change in listbox1. Set active selected 
%> electrical field object and draw first potential map for new selection.
% =====================================================================
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

axes(handles.axessens);
%cla;
%set(handles.axessens,'PlotBoxAspectRatio',[1,1,1]);
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 


%'Sensitivity'

     komenda=[var1,'.draw_potential(','1',');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);   

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
%> @brief Search for Electrical field objects in workspace.
% =====================================================================
function update_listbox(handles)
%http://www.mathworks.com/access/helpdesk/help/techdoc/creating_guis/f6-7673.html
% get all workspace variables
vars = evalin('base','who');
k=1;
any_elements=0;

% search for Electrical_field object in workspace 
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

% =====================================================================
%> @brief Executes on button pot sum press. Draw potential sum map in new
%> figure.
% =====================================================================
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

%'Sensitivity'

 fh_sum = figure;
 name=[var1,' Potential Map Sum'];
 set(fh_sum,'Name',name);
 komenda=[var1,'.draw_sum_pot_map();'];
 evalin('base',komenda);   



% =====================================================================
%> @brief Executes on button capacitance press. Draw capacitance in new
%> figure.
% =====================================================================
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

%'Sensitivity'

 fh_sum = figure;
 name=[var1,' Capacitance'];
 set(fh_sum,'Name',name);
 komenda=[var1,'.draw_capacitances();'];
 evalin('base',komenda);   
