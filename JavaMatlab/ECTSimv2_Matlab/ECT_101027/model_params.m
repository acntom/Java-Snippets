function varargout = model_params(varargin)
% MODEL_PARAMS M-file for model_params.fig
%      MODEL_PARAMS, by itself, creates a new MODEL_PARAMS or raises the existing
%      singleton*.
%
%      H = MODEL_PARAMS returns the handle to a new MODEL_PARAMS or the handle to
%      the existing singleton*.
%
%      MODEL_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_PARAMS.M with the given input arguments.
%
%      MODEL_PARAMS('Property','Value',...) creates a new MODEL_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_params

% Last Modified by GUIDE v2.5 21-Aug-2010 23:31:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_params_OpeningFcn, ...
                   'gui_OutputFcn',  @model_params_OutputFcn, ...
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


% --- Executes just before model_params is made visible.
function model_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_params (see VARARGIN)

% Choose default command line output for model_params
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_params wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function rod_Callback(hObject, eventdata, handles)
% hObject    handle to rod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rod as text
%        str2double(get(hObject,'String')) returns contents of rod as a double


% --- Executes during object creation, after setting all properties.
function rod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hgrid_Callback(hObject, eventdata, handles)
% hObject    handle to hgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hgrid as text
%        str2double(get(hObject,'String')) returns contents of hgrid as a double


% --- Executes during object creation, after setting all properties.
function hgrid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phaperm_Callback(hObject, eventdata, handles)
% hObject    handle to phaperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phaperm as text
%        str2double(get(hObject,'String')) returns contents of phaperm as a double


% --- Executes during object creation, after setting all properties.
function phaperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phaperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minperm_Callback(hObject, eventdata, handles)
% hObject    handle to minperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minperm as text
%        str2double(get(hObject,'String')) returns contents of minperm as a double


% --- Executes during object creation, after setting all properties.
function minperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elenum_Callback(hObject, eventdata, handles)
% hObject    handle to elenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elenum as text
%        str2double(get(hObject,'String')) returns contents of elenum as a double


% --- Executes during object creation, after setting all properties.
function elenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratio as text
%        str2double(get(hObject,'String')) returns contents of ratio as a double


% --- Executes during object creation, after setting all properties.
function ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function insstartang_Callback(hObject, eventdata, handles)
% hObject    handle to insstartang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of insstartang as text
%        str2double(get(hObject,'String')) returns contents of insstartang as a double


% --- Executes during object creation, after setting all properties.
function insstartang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to insstartang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rekonstrsize_Callback(hObject, eventdata, handles)
% hObject    handle to rekonstrsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rekonstrsize as text
%        str2double(get(hObject,'String')) returns contents of rekonstrsize as a double


% --- Executes during object creation, after setting all properties.
function rekonstrsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rekonstrsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of method as text
%        str2double(get(hObject,'String')) returns contents of method as a double


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numiter_Callback(hObject, eventdata, handles)
% hObject    handle to numiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numiter as text
%        str2double(get(hObject,'String')) returns contents of numiter as a double


% --- Executes during object creation, after setting all properties.
function numiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function updatemeth_Callback(hObject, eventdata, handles)
% hObject    handle to updatemeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of updatemeth as text
%        str2double(get(hObject,'String')) returns contents of updatemeth as a double


% --- Executes during object creation, after setting all properties.
function updatemeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updatemeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itermod_Callback(hObject, eventdata, handles)
% hObject    handle to itermod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itermod as text
%        str2double(get(hObject,'String')) returns contents of itermod as a double


% --- Executes during object creation, after setting all properties.
function itermod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itermod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function updatedelta_Callback(hObject, eventdata, handles)
% hObject    handle to updatedelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of updatedelta as text
%        str2double(get(hObject,'String')) returns contents of updatedelta as a double


% --- Executes during object creation, after setting all properties.
function updatedelta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updatedelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noadapt_Callback(hObject, eventdata, handles)
% hObject    handle to noadapt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noadapt as text
%        str2double(get(hObject,'String')) returns contents of noadapt as a double


% --- Executes during object creation, after setting all properties.
function noadapt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noadapt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function regular_Callback(hObject, eventdata, handles)
% hObject    handle to regular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regular as text
%        str2double(get(hObject,'String')) returns contents of regular as a double


% --- Executes during object creation, after setting all properties.
function regular_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function paramu_Callback(hObject, eventdata, handles)
% hObject    handle to paramu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of paramu as text
%        str2double(get(hObject,'String')) returns contents of paramu as a double


% --- Executes during object creation, after setting all properties.
function paramu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paramu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dggs_Callback(hObject, eventdata, handles)
% hObject    handle to dggs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dggs as text
%        str2double(get(hObject,'String')) returns contents of dggs as a double


% --- Executes during object creation, after setting all properties.
function dggs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dggs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dgms_Callback(hObject, eventdata, handles)
% hObject    handle to dgms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dgms as text
%        str2double(get(hObject,'String')) returns contents of dgms as a double


% --- Executes during object creation, after setting all properties.
function dgms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dgms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonstart.
function pushbuttonstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %grid
% matrix_size=get(handles.dgms,'String');
% evalin('base',['matrix_size=',num2str(matrix_size),';']);

grid_size=get(handles.dggs,'String');
if str2double(grid_size)>1
    errordlg('Grid size must be equal or less than one. Default value will be use.',...
			'Incorrect value','modal')    
end

evalin('base',['grid_size=',num2str(grid_size)]);

%sensor
number_of_electrodes=get(handles.elenum,'String');
evalin('base',['number_of_electrodes=',num2str(number_of_electrodes)]);

ratio_electrode_to_insulator=get(handles.ratio,'String');
evalin('base',['ratio_electrode_to_insulator=',num2str(ratio_electrode_to_insulator)]);

start_ins2_angle=get(handles.insstartang,'String');
evalin('base',['start_ins2_angle=',num2str(start_ins2_angle)]);

% phantoms
D_mm=get(handles.hgrid,'String');
evalin('base',['D_mm=',num2str(D_mm)]);

d_mm=get(handles.rod,'String');
evalin('base',['d_mm=',num2str(d_mm)]);

pha_perm=get(handles.phaperm,'String');
evalin('base',['pha_perm=',num2str(pha_perm)]);

pha_min_perm=get(handles.minperm,'String');
evalin('base',['pha_min_perm=',num2str(pha_min_perm)]);

pha_max_perm=get(handles.edit12,'String');
evalin('base',['pha_max_perm=',num2str(pha_max_perm)]);

pha_avg_perm=get(handles.edit11,'String');
evalin('base',['pha_avg_perm=',num2str(pha_avg_perm)]);

% rekonstructor
rekonstruction_mtx_pix_size=get(handles.rekonstrsize,'String');
evalin('base',['rekonstruction_mtx_pix_size=',num2str(rekonstruction_mtx_pix_size)]);

alg_params.method=get(handles.method,'String');
evalin('base',['alg_params.method=','''',alg_params.method,'''',';']);

alg_params.numiter=get(handles.numiter,'String');
evalin('base',['alg_params.numiter=',num2str(alg_params.numiter),';']);

alg_params.stop_delta=get(handles.edit15,'String');
evalin('base',['alg_params.stop_delta=',num2str(alg_params.stop_delta),';']);

alg_params.update_method=get(handles.updatemeth,'String');
evalin('base',['alg_params.update_method=','''',alg_params.update_method,'''',';']);

alg_params.iter_mod=get(handles.itermod,'String');
evalin('base',['alg_params.iter_mod=',num2str(alg_params.iter_mod),';']);

alg_params.update_delta=get(handles.updatedelta,'String');
evalin('base',['alg_params.update_delta=',num2str(alg_params.update_delta),';']);

alg_params.alpha=get(handles.alpha,'String');
evalin('base',['alg_params.alpha=',num2str(alg_params.alpha),';']);

alg_params.alphalimit=get(handles.noadapt,'String');
evalin('base',['alg_params.alphalimit=','''',alg_params.alphalimit,'''',';']);

alg_params.regular=get(handles.regular,'String');
evalin('base',['alg_params.regular=','''',alg_params.regular,'''',';']);

alg_params.u=get(handles.paramu,'String');
evalin('base',['alg_params.u=',num2str(alg_params.u)]);

selection = questdlg('Start ?',...
                     'Start Model',...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1);
