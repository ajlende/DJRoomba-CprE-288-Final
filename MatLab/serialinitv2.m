%% Initialize Serial Comm.
%Author: Benjamin Williams
%Edited by: Christofer Sheafe
% Establishes serial communication with bot.

%baud: baudrate
%port: serial-object-id
%%
function port = serialinitv2(baud)
% out = instrfind;
% try
%     fclose(out);
% catch
% end
% delete(out);
% clear out

if baud == 38400
    port = serial('COM1');
elseif baud == 57600
    port = serial('COM4');
end

set(port, 'BaudRate', baud);
fopen(port);
display('Connected')
