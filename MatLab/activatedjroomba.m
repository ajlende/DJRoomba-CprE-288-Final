%% BOT GUI
%Author: Alex
%Also worked on by: Ben, Chris
%Documentation by Ben
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

% Last Modified by GUIDE v2.5 01-May-2014 15:20:24

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
%These are the global variables used in our GUI's
%pushbutton callbacks (functions that trigger whenever
%a button is pushed
handles.output = hObject;
handles.count = 1;
handles.port = 0;
handles.number = 0;
handles.message = 'hi';

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

% --------------------------------------------------------------------
%The callback for our "connect to bluetooth" dropdown option.
%We create a matlab serial object named "port" that we pass into
%our global variables, which can be accessed by other callbacks.
%Matlab serial objects are used for reading and writing to the robot
function hobject = openbluetooth_Callback(hObject, eventdata, handles)
% hObject    handle to openbluetooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    %SerialInitV3 is the 3rd version of our serial initiation script.
    %It returns a serial object that should be whatever is connected to
    %'COM4' (The port for our bluetooth module)
    handles.port = serialinitv3('COM4',hObject,handles);
    
    %Update our global variables.  (Port)
    guidata(hObject,handles)
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --------------------------------------------------------------------
%Same logic as the Bluetooth connection callback.  Simply use a different
%BaudRate (38400) and a different port ('COM1') as we are attempting
%to connect to the serial cable
function openserial_Callback(hObject, eventdata, handles)
% hObject    handle to openserial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.port = serialinitv3('COM1',hObject,handles);
    guidata(hObject,handles)
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --------------------------------------------------------------------
%Closes all serial objects and kills all the connections.
function closeall_Callback(hObject, eventdata, handles)
% hObject    handle to closeall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Matlab script that does the described functionality
closeall
end

% --- Callback for our smallscan command (Scan from 45 deg to 135 deg)
function smallscan_Callback(hObject, eventdata, handles)
% hObject    handle to smallscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
    display('flushed')
end
try
    %Matlab script that writes an 's' character to our robot, and then
    %waits for/ recieves standardized input back from the device
    smallscan(handles.port);
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Callback for our bigscan command (Scan from 0 deg to 180 deg)
function bigscan_Callback(hObject, eventdata, handles)
% hObject    handle to bigscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
end
try
    %Matlab script that writes an 'S' character to our robot, and then
    %waits for/ recieves standardized input back from the device
    bigscan(handles.port)
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Callback for left turn command
function turnleft_Callback(hObject, eventdata, handles)
% hObject    handle to turnleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
end

try
    %Debug code, prints out a global variable
    %display(handles.number);
    
    %Send an 'l', which initiates the turn left command on the robot
    fwrite(handles.port,'l')
    
    %Send a number specified in our "number" textbox.  This is a scalar
    %variable that tells the robot how many degrees to turn
    %Turns number * 10 degrees
    fwrite(handles.port,handles.number)
    start = clock;
    TimeOut = 6;
    
    while(handles.port.BytesAvailable == 0)
       %block until we see data 
       %Wait until 6 seconds have passed, then give up on recieiving
       %Necessary to not hang up matlab when the robot doesn't send back
       %Standard input in time
       if(etime(clock, start) > TimeOut)
           break;
       end
    end
    
    %Once we have receieved a string from the port, display
    %Tells us how many degrees have been turned, and how long it took
    %for us to turn
    display(fgets(handles.port));
    display(etime(clock,start));

catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes on button press in turnright.
function turnright_Callback(hObject, eventdata, handles)
% hObject    handle to turnright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
end

try
    %Send an 'r', which initiates the turn left command on the robot
    fwrite(handles.port,'r')
    
    %Send a number specified in our "number" textbox.  This is a scalar
    %variable that tells the robot how many degrees to turn
    %Turns number * 10 degrees
    fwrite(handles.port,handles.number)
    start = clock;
    TimeOut = 6;
    
    while(handles.port.BytesAvailable == 0)
       %block until we see data or request times out
       if(etime(clock, start) > TimeOut)
           break;
       end
    end
    
    %Once we have receieved a string from the port, display
    %Tells us how many degrees have been turned, and how long it took
    %for us to turn
    display(fgets(handles.port));
    display(etime(clock,start));

catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes on button press in forward.
%Somebody mispelled forward, not enough time to fix
function foreward_Callback(hObject, eventdata, handles)
% hObject    handle to foreward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
end

%Debug code for a previously used command 'Movement.'  Not used in final
%display(handles.port.ReadAsyncMode);
% movement('forward',handles.number,handles.port)
try
    %Update our global variables
    guidata(hObject,handles)
    
    %Initiate move forward command
    fwrite(handles.port,'f')
    
    %Send scalar for how many cm to move (number * 10 cm)
    fwrite(handles.port,handles.number)
    while(handles.port.BytesAvailable == 0)
       %block until we see data 
    end
    %Display how many cm were moved
         display(fgets(handles.port));
    while(handles.port.BytesAvailable == 0)
       %block until we see data 
    end
    %Display if any input stimuli were experienced( line/cliff/bumper)
         display(fgets(handles.port));
    
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Empty the serial port information buffer before asking for new information
%Necessrary to ensure a standardized input from the device
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable);
end

try
    %Write a 'b' which moves our bot back 5 cm
    fwrite(handles.port,'b')
    
    while(handles.port.BytesAvailable == 0)
       %block until we see data 
    end
    %Display how many cm were moved backwards by the robot from the
    %distance sensors
         display(fgets(handles.port));
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes on button press in flush.
function flush_Callback(hObject, eventdata, handles)
% hObject    handle to flush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    %Look at our input port buffer, and if there is information in it
    %clear it all by reading.
    if (handles.port.BytesAvailable ~= 0)
        %There is info, read it
        fread(handles.port, handles.port.BytesAvailable);
    else
        %There is no info, display 'Buffer is empty'
        appendeditbox('Buffer is empty.',handles,hObject);
    end
catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes on button press in reportdata.
function reportdata_Callback(hObject, eventdata, handles)
% hObject    handle to reportdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Flush input info
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
try
    %Sends a 'd' which calls for an update on our current sensor data
    fwrite(handles.port, 'd');
    start = clock;
    TimeOut = 6;
    
    while(handles.port.BytesAvailable == 0)
       %block until we see data or time out in 6 seconds
        if(etime(clock, start) > TimeOut)
           break;
       end
    end
    
    %Display the string containing our requested information
    display(fgets(handles.port));
    
    %Display how long it took to recieve the info
    display(etime(clock, start));

catch err
    %If there is an error, send it to our message box in the GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

% --- Executes when number value is updated.
function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Sets the number value to whatever number is entered in the
%number textbox
handles.number = get(hObject,'String');

%Finalizes the update of the global handles variable
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Edit controls usually have a white background on Windows.
% Set aesthetic properties
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editmsg_Callback(hObject, eventdata, handles)
% hObject    handle to editmsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Not implemented.  Used to test out callbacks.
display('messages_Callback called')
end

% --- Executes during object creation, after setting all properties.
function editmsg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editmsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Used for editmsg aesthetics, not implemented.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in testmsg.
function testmsg_Callback(hObject, eventdata, handles)
% hObject    handle to testmsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = 'testmsg_Callback called';

%Not implemented.  Used to test out callbacks.
appendeditbox(str,handles,hObject);
end

% --------------------------------------------------------------------
function clrmsg_Callback(hObject, eventdata, handles)
% hObject    handle to clrmsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Not implemented.  Used for testing handles variables
handles.message = 'cleared';
handles.count = 1;
guidata(hObject,handles)
set(handles.editmsg,'String','')
end


% --- Executes on button press in Song.
function Song_Callback(hObject, eventdata, handles)
% hObject    handle to Song (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Flush input buffer data
if (handles.port.BytesAvailable ~= 0)
    fread(handles.port, handles.port.BytesAvailable)
end
try
    %Send a 'Q' character over serial.  Robot will play 'Take on Me'
    fwrite(handles.port, 'Q')
catch err
    %Display error in GUI
    appendeditbox(getReport(err,'extended','hyperlinks','off'),handles,hObject);
end
end

