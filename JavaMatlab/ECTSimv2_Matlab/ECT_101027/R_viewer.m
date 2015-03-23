function varargout = R_viewer(varargin)
% R_VIEWER M-file for R_viewer.fig
%      Run file from main program directory
%      R_VIEWER, by itself, creates a new R_VIEWER or raises the existing
%      singleton*.
%
%      H = R_VIEWER returns the handle to a new R_VIEWER or the handle to
%      the existing singleton*.
%
%      R_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in R_VIEWER.M with the given input arguments.
%
%      R_VIEWER('Property','Value',...) creates a new R_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before R_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to R_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help R_viewer

% Last Modified by GUIDE v2.5 01-Aug-2010 22:28:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @R_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @R_viewer_OutputFcn, ...
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
%> @brief Executes just before R_viewer is made visible. Search for
%> Reconstructor objects. Set them in list box. Plot last permittivity
%> distribution map (reconstructed image).
% =====================================================================
function R_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to R_viewer (see VARARGIN)

% Choose default command line output for R_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

update_listbox(handles);



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

    % display last iter
     max_iter=[var1,'.maps_number'];
     komenda=[var1,'.Eps_at_iter(',max_iter,');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);          
     
     max_iter= evalin('base',max_iter);          
     max_iter=max_iter-1; % starting solution is zero
     
     set(handles.slider1,'Max',max_iter);
     set(handles.slider1,'Min',1);
          
     if max_iter<0
         error 'Max iter is less than zero'     
     else
        max_iter=num2str(max_iter);     
        set(handles.text1,'String',max_iter);
     end
     
% UIWAIT makes R_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = R_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

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
rec_num_max=evalin('base',[var1,'.maps_number;']);% its equal to number of real reconstruction iteration
set(handles.slider1,'Max', rec_num_max);

if(val<=0)
    val=1;
    set(handles.slider1,'Value', val);
elseif (val>rec_num_max)
    val=1;
    set(handles.slider1,'Value', val);
end


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
%> @brief Executes on slider movement. Change permittivity
%> distribution map (reconstructed image) for selected Reconstructor object.
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
rec_num_max=evalin('base',[var1,'.maps_number;']);% its equal to number of real reconstruction iteration
set(handles.slider1,'Max', rec_num_max);

if(val<=0)
    val=1;
    set(handles.slider1,'Value', 1);
elseif (val>rec_num_max)
    val=1;
    set(handles.slider1,'Value', 1);
end

     komenda=[var1,'.Eps_at_iter(',num2str(val),');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);  
     set(handles.text1,'String',val-1);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
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


% =====================================================================
%> @brief Executes on button press in update. Display for selected object
%> in listbox value from pop-up menu.
% =====================================================================
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% select Reconstructor object 
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
if length(index_selected) ~= 1
	errordlg('You must select one element',...
			'Incorrect Selection','modal')
else
	var1 = list_entries{index_selected(1)};	
end 

% action 
popup_val = get(handles.popupmenu1, 'Value');

% get from workspace
rec_num_max=evalin('base',[var1,'.maps_number;']);% its equal to number of real reconstruction iteration
set(handles.slider1,'Max', rec_num_max);

% pop up menu
if(popup_val==1)% eps_map
            
    % display last iter     
     max_iter=[var1,'.maps_number'];
     komenda=[var1,'.Eps_at_iter(',max_iter,');'];
    %evalin('base', 'Ef.draw_sensitivity(''all'');');     
     evalin('base',komenda);          
     
     max_iter= evalin('base',max_iter);          
     max_iter=max_iter-1; % starting solution is zero
     
     set(handles.slider1,'Value',max_iter);
          
     if max_iter<0
         error 'Max iter is less than zero'     
     else
        max_iter=num2str(max_iter);     
        set(handles.text1,'String',max_iter);
     end
    

elseif(popup_val==2)% errors
    
     fh_error = figure;
     name=[var1,' Image, Sensitivity, Capacitance Errors'];
     set(fh_error,'Name',name);
      
     komenda=[var1,'.draw_errors();'];    
     
     evalin('base',komenda);  
     
elseif(popup_val==3)% C_recalculated-C_measured
     
    % get value from slider
    sliderValue = get(handles.slider1,'Value');
    val=round(sliderValue);

    if(val<=0)
        val=1;
    elseif (val>rec_num_max)
        val=1;
    end
    
     fh_crminuscm = figure;
     name=[var1,' C_recalculated-C_measured'];
     set(fh_crminuscm,'Name',name);
    
     komenda=[var1,'.draw_capacitance_diff(',num2str(val),');'];     
     evalin('base',komenda);  
     
elseif(popup_val==4)% C_recalculated and C_measured on one plot
     
    % get value from slider
    sliderValue = get(handles.slider1,'Value');
    val=round(sliderValue);

    if(val<=0)
        val=1;
    elseif (val>rec_num_max)
        val=1;
    end
    
     fh_crminuscm = figure;
     name=[var1,' C_recalculated and C_measured'];
     set(fh_crminuscm,'Name',name);
     
     komenda=[var1,'.draw_Cm_Cr(',num2str(val),');'];     
     evalin('base',komenda);     
     
elseif(popup_val==5)% params u and alpha
     fh_pams = figure;
     name=[var1,' Algorithm Params Change'];
     set(fh_pams,'Name',name);
     
     komenda=[var1,'.draw_alg_params();'];     
     evalin('base',komenda);     
     
elseif(popup_val==6)%  max min measure recalculated capacitances 
    
    % get value from slider
    sliderValue = get(handles.slider1,'Value');
    val=round(sliderValue); 
    
    if(val<=0)
        val=1;
    elseif (val>rec_num_max)
        val=1;
    end
    
     fh_all_c = figure;
     name=[var1,' All Capacitances'];
     set(fh_all_c,'Name',name);
     
     komenda=[var1,'.draw_all_capacitances(',num2str(val),');'];     
     evalin('base',komenda);     
end




% =====================================================================
%> @brief Search for Reconstructor objects in workspace.
% =====================================================================
function update_listbox(handles)
%http://www.mathworks.com/access/helpdesk/help/techdoc/creating_guis/f6-7673.html
vars = evalin('base','who');
k=1;
any_elements=0;
for i=1:length(vars);
        
    komenda=['isa(',vars{i},',','''Reconstructor_2D''',');'];    
    ret = evalin('base',komenda);    
    if ret==1
        ef_vector(k)=vars(i);
        k=k+1;
        any_elements=1;
    end
end
if any_elements==0
    errordlg('There is''t Reconstructor object in workspace. First run simulation.',...
        'Error');
    error('There is''t Reconstructor object in workspace. First run simulation.');
end

set(handles.listbox1,'String',ef_vector)
