%Setup
%Delete our previous matlab serial objects
out = instrfind;
%fclose(out);
delete(out);
clear all;
 prompt = 'Bluetooth(1) or Wired(2)?: ';
    command = input(prompt);
if (command == 2)
   serial = serial('COM1');
set(serial, 'BaudRate', 38400);
%Create our own new object
elseif (command == 1)
    serial = serial('COM4');
    set(serial, 'BaudRate', 57600);
else
    display('Error')
end
%Open
fopen(serial);