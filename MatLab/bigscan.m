%% 180 degree Scan
%Author: Benjamin Williams
%Scans a 180 degree arc and stores data in Matlab. Plots the result.

function null = bigscan(port)
%90 x 3 array of zeros used to store input info
data = zeros(90,3);
%Send the small scan serial command to the port object
fwrite(port, 'S');

for j=1:90
%Read in next line of standard input into temp string
sentence = fscanf(port);

%Parse string into our data array, with standard input of int float float
[data(j,1) data(j,2) data(j,3)] = strread(sentence, '%d%f%f', 1,'delimiter','space');

%Debug code.  Displays the degrees that our robot is on.
data(j,1)

%Eliminate numbers greater than 80 so we can focus on accurate, relevant
%information.
if data(j,2) > 80
    data(j,2) = 80;
end

if data(j,3) > 80
    data(j,3) = 80;
end

end

%Scale data - Degrees to Radians
data(:,1) = data(:,1) * 3.14/180;
    

%plot data onto radial graph
polar(data(:,1), data(:,2),'.r'); hold on;
polar(data(:,1), data(:,3),'.');

%Draw graph
drawnow;

%Stop data from persisting past one draw
hold off;
%close all