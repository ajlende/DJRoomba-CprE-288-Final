%% Movement
%Authors: Nick, Other Nick
%Edited by: Christofer Sheafe
%Moves the robot either forward or turns either left or right.

function null = movement(input,number,port)

if strcmp(input,'forward')
        fwrite(port, 'f')
        fwrite(port, number)
        message = fscanf(port)

elseif strcmp(input,'left')
        fwrite(port, 'l')
        fwrite(port, number)
        
elseif strcmp(input,'right')
        fwrite(port,'r')
        fwrite(port,number)
        
elseif strcmp(input,'back')
        fwrite(port, 'b')
end