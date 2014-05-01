%% 90 degree scan
%Author: Benjamin Williams
%Scans from 45 degrees to 135 degrees
function smallscan(port)
data = zeros(45,3);

%Send the small scan seriaL command
fwrite(port, 's');

% i = 0;

for j=1:45
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
hold off;
drawnow;
% i = i +1;