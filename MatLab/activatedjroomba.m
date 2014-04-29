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

% Last Modified by GUIDE v2.5 28-Apr-2014 20:19:23

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
movement('forward',handles.port)
end

% --- Executes on button press in smallscan.
function smallscan_Callback(hObject, eventdata, handles)
% hObject    handle to smallscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%port = getappdata(hObject,'port');
smallscan(handles.port)
end

% --- Executes on button press in bigscan.
function bigscan_Callback(hObject, eventdata, handles)
% hObject    handle to bigscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bigscan(handles.port)
end



% --- Executes on button press in turnleft.
function turnleft_Callback(hObject, eventdata, handles)
% hObject    handle to turnleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movement('left',handles.port)
end

% --- Executes on button press in turnright.
function turnright_Callback(hObject, eventdata, handles)
% hObject    handle to turnright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movement('right',handles.port)
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
