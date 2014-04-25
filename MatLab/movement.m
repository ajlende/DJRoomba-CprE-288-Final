%% Movement
%Authors: Nick, Other Nick
%Edited by: Christofer Sheafe
%Moves the robot either forward or turns either left or right.

function null = movement(input,port)

if strcmp(input,'forward')
        fwrite(port, 'f')
        message = fscanf(port)

elseif strcmp(input,'left')
        fwrite(port, 'l')
        
elseif strcmp(input,'right')
        fwrite(port,'r')  
end