%% 180 degree Scan
%Author: Benjamin Williams
%Scans a 180 degree arc and stores data in Matlab. Plots the result.

function null = bigscan(port)
data = zeros(90,3);
%Send the small scan seriaL command
fwrite(port, 'S');

i = 0;

for j=1:90
%Read
sentence = fscanf(port);
%sentence

%Tack on new data
[data(j,1) data(j,2) data(j,3)] = strread(sentence, '%d%f%f', 1,'delimiter','space');

data(j,1)

if data(j,2) > 80
    data(j,2) = 80;
end

if data(j,3) > 80
    data(j,3) = 80;
end
%data(j,2)
%data(j,3)
end

%Scale data - Radians
data(:,1) = data(:,1) * 3.14/180;
    

%plot data
polar(data(:,1), data(:,2),'.r'); hold on;
polar(data(:,1), data(:,3),'.');
drawnow;
i = i+1;
%close all