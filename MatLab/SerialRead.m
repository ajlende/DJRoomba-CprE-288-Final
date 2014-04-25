%Setup
%Delete our previous matlab serial objects
out = instrfind;
delete(out);
clear all;

%Create our own new object
serial = serial('COM1');
set(serial, 'BaudRate', 38400);

data = zeros(90,3);

%Open
fopen(serial);

%Wait until sweep is complete
%pause(20);

i = 0;

while i<100
i
for j=1:90
%Read
sentence = fscanf(serial);
%sentence

%Tack on new data
[data(j,1) data(j,2) data(j,3)] = strread(sentence, '%d%f%f', 1,'delimiter','space');

data(j,1)
%data(j,2)
%data(j,3)
end
%Scale data - Radians
data(:,1) = data(:,1) * 3.14/180;

%plot data
polar(data(:,1), data(:,2),'.');
drawnow;
i = i +1;
end

%Close
fclose(serial);

%Delete
delete(serial);

