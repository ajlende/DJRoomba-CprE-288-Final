%%Control Panel

function dummy = controlpanel(command) 

%serialinit
display(command)
fopen(serial);
w = 119;
a = 97;%ASCII 'a'
s = 115;
d = 100;
q = 113;
e = 101;

%while(1)
   % prompt = 'Enter a command: ';
   % command = input(prompt);
    
    if command == w
        forward
    
    elseif command == a
        left
        
    elseif command == s
        back
        
    elseif command == d
        right 
    
    elseif command == q
        smallscan
            
    elseif command == e
        bigscan
    end
end