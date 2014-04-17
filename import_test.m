%% Data Import Proof of Concept
%{ 
288 Final Project, Spring 2014
author: Christofer Sheafe

The following code:
    1) Creates mock data
    2) exports the data to a txt file
    3) imports that data back into MATLAB(necessary for recieving real
    data)
    4) plots the data
%}
%% Data is created in two columns(angle,distance)
angle = pi/180*(1:180);
angle = angle(:);%turns into an n-by-1 vector
dist = [35*ones(10,1);180*ones(50,1);25*ones(20,1);140*ones(60,1);33*ones(20,1);155*ones(20,1)];
data = horzcat(angle,dist);
data

%% Data is exported to a .txt file
length = size(data);
length = length(1);% column length
fid = fopen('data.txt','w'); % file-id tag
fprintf(fid,' %f %f\r\n',data);
fid = fopen('data.txt','r');

%% Data is imported into an 1-by-1 cell and plotted
indata = textscan(fid,'%f');
indata = indata{1};
indata = horzcat(indata(1:length),indata(length+1:length*2));
indata
polar(indata(1:length),indata(length+1:2*length))
