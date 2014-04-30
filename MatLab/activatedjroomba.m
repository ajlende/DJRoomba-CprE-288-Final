%% BOT GUI
%Author: Alex 
%Push button function added by: Christofer Sheafe

%Utilizes controlpanel.m to control bot via GUI. See controlpanel for
%operation.

function varargout = activatedjroomba(varargin)
% ACTIVATEDJROOMBA MATLAB code for activatedjroomba.fig
%      ACTIVATEDJROOMBA, by itself, creates a new ACTIVATEDJROOMBA or raises the existing
%      singleton*.
%
%      H = ACTIVATEDJROOMBA returns the handle to a new ACTIVATEDJROOMBA or the handle to
%      the existing singleton*.
%
%      ACTIVATEDJROOMBA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVATEDJROOMBA.M with the given input arguments.
%
%      ACTIVATEDJROOMBA('Property','Value',...) creates a new ACTIVATEDJROOMBA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before activatedjroomba_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to activatedjroomba_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help activatedjroomba

% Last Modified by GUIDE v2.5 29-Apr-2014 22:18:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @activatedjroomba_OpeningFcn, ...
                   'gui_OutputFcn',  @activatedjroomba_OutputFcn, ...
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
end
% --- Executes just before activatedjroomba is made visible.
function activatedjroomba_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to activatedjroomba (see VARARGIN)

% Choose default command line output for activatedjroomba
handles.output = hObject;
handles.port = 0;
handles.number = 0;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes activatedjroomba wait for user response (see UIRESUME)
% uiwait(handles.mainwindow);
end



% --- Outputs from this function are returned to the command line.
function varargout = activatedjroomba_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(hObject,'output');

end


% --- Executes on button press in foreward.
function foreward_Callback(hObject, eventdata, handles)
% hObject    handle to foreward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
movement('forward',handles.number,handles.port)
end

% --- Executes on button press in smallscan.
function smallscan_Callback(hObject, eventdata, handles)
% hObject    handle to smallscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%port = getappdata(hObject,'port');
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
smallscan(handles.port)
end

% --- Executes on button press in bigscan.
function bigscan_Callback(hObject, eventdata, handles)
% hObject    handle to bigscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
bigscan(handles.port)
end



% --- Executes on button press in turnleft.
function turnleft_Callback(hObject, eventdata, handles)
% hObject    handle to turnleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
movement('left',handles.number,handles.port)
end

% --- Executes on button press in turnright.
function turnright_Callback(hObject, eventdata, handles)
% hObject    handle to turnright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
movement('right',handles.number,handles.port)
end

% --------------------------------------------------------------------
function hobject = openbluetooth_Callback(hObject, eventdata, handles)
% hObject    handle to openbluetooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.port = serialinitv2(57600);
guidata(hObject,handles)
end

% --------------------------------------------------------------------
function openserial_Callback(hObject, eventdata, handles)
% hObject    handle to openserial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.port = serialinitv2(38400);
guidata(hObject,handles)
end
% --------------------------------------------------------------------
function closeall_Callback(hObject, eventdata, handles)
% hObject    handle to closeall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end



function messages_Callback(hObject, eventdata, handles)
% hObject    handle to messages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of messages as text
%        str2double(get(hObject,'String')) returns contents of messages as a double
end

% --- Executes during object creation, after setting all properties.
function messages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to messages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number as text
%        str2double(get(hObject,'String')) returns contents of number as a double
handles.number = get(hObject,'String');
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in flush.
function flush_Callback(hObject, eventdata, handles)
% hObject    handle to flush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fwrite(handles.port,'!')
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
else
    print ('Buffer is empty');
end
end


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
movement('back',handles.number,handles.port);
end


% --- Executes on button press in reportdata.
function reportdata_Callback(hObject, eventdata, handles)
% hObject    handle to reportdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
fwrite(port, 'd')
end
