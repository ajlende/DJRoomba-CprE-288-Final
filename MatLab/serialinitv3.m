%% Initialize Serial Comm.
%Author: Alex Lende
% Establishes serial communication with bot.

%port: Port Name (ex. 'COM1' or 'COM4')
%port: serial-object-id
%%
function port = serialinitv3(portname,hObject,handles)

% Try to close any open connections
closeall

str = sprintf('Opening connection to %s...',portname);
appendeditbox(str,handles,hObject)

if strcmp('COM1',portname)
    port = serial('COM1','BaudRate',38400);
elseif strcmp('COM4',portname)
    port = serial('COM4','BaudRate',57600);
else
    display('Unknown port specified')
    return;
end

%port.BytesAvailableFcnMode = 'terminator';
%port.BytesAvailableFcn = {@messageReceived,hObject};

fopen(port);

appendeditbox('Connected',handles,hObject);
