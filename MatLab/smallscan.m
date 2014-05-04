%% 90 degree scan
%Author: Benjamin Williams
%Scans from 45 degrees to 135 degrees
function smallscan(port)
%Create 45 x 3 blank array to store data in
data = zeros(45,3);
%Send the small scan serial command
fwrite(port, 's');

for j=1:45
%Read input into temp string
sentence = fscanf(port);

%Parse string into our data array, using standard input int float float
[data(j,1), data(j,2), data(j,3)] = strread(sentence, '%d%f%f', 1,'delimiter','space');

%Debug, displays current degree
data(j,1)

%Ignore all data greater than 80 degrees.  Eliminates some noise and
%irrelevant/innacurate data from display.
if data(j,2) > 80
    data(j,2) = 80;
end

if data(j,3) > 80
    data(j,3) = 80;
end
end

%Scale data - Degrees to Radians
data(:,1) = data(:,1) * 3.14/180;
    

%plot data
polar(data(:,1), data(:,2),'.r'); hold on;
polar(data(:,1), data(:,3),'.');

%Draw Radial plot of distance over degrees
drawnow;

%Only hold info for one draw, keeps data current.
hold off;
end