%% Initialize Serial Comm.
%Author: Alex Lende
% Establishes serial communication with bot.

%port: Port Name (ex. 'COM1' or 'COM4')
%port: serial-object-id
%%
function port = serialinitv3(portname,hObject,handles)

% Try to close any open connections
closeall

%Realtime input for user
str = sprintf('Opening connection to %s...',portname);
appendeditbox(str,handles,hObject)

if strcmp('COM1',portname)
    %Initialize object for serial cable
    port = serial('COM1','BaudRate',38400);
elseif strcmp('COM4',portname)
    %Initialize object for bluetooth
    port = serial('COM4','BaudRate',57600);
else
    %Error message to user
    display('Unknown port specified')
    return;
end

%Not implemented.  Data recieved input.
%port.BytesAvailableFcnMode = 'terminator';
%port.BytesAvailableFcn = {@messageReceived,hObject};

%Opens serial object for reading and writing.
fopen(port);

%User information
appendeditbox('Connected',handles,hObject);
