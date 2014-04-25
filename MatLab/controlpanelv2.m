%% Control Panel
%CPRE 288 FINAL PROJECT Spring 2014
%author: Christofer Sheafe
%Transmits command through serial to bot.

%baud: baud setting for serial comm.
%mode: 0 = move, 1 = scan
%commands: 'forward','left','right','smallscan','bigscan'
%%
function null = controlpanelv2(baud,mode,command) 
port = serialinitv2(baud);%serial-object-id
display(command)

if mode
    if strcmp(command,'bigscan')
        bigscan(port)
    elseif strcmp(command,'smallscan')
        smallscan(port)
    end 
else
    movement(command,port)
end