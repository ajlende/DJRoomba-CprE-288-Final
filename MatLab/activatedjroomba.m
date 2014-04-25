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

% Last Modified by GUIDE v2.5 24-Apr-2014 17:11:44

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


% --- Executes just before activatedjroomba is made visible.
function activatedjroomba_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to activatedjroomba (see VARARGIN)

% Choose default command line output for activatedjroomba
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes activatedjroomba wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = activatedjroomba_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in foreward.
function foreward_Callback(hObject, eventdata, handles)
% hObject    handle to foreward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in smallscan.
function smallscan_Callback(hObject, eventdata, handles)
% hObject    handle to smallscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bigscan.
function bigscan_Callback(hObject, eventdata, handles)
% hObject    handle to bigscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in backward.
function backward_Callback(hObject, eventdata, handles)
% hObject    handle to backward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in turnleft.
function turnleft_Callback(hObject, eventdata, handles)
% hObject    handle to turnleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in turnright.
function turnright_Callback(hObject, eventdata, handles)
% hObject    handle to turnright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over smallscan.
function smallscan_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to smallscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in serialinit.
function serialinit_Callback(hObject, eventdata, handles)
% hObject    handle to serialinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in serialclose.
function serialclose_Callback(hObject, eventdata, handles)
% hObject    handle to serialclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
