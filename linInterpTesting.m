% Test the interp function

% Cleanup
clc
clear all
close all

% Variable ranges
R1 = [0:1];
R2 = [0:10];
R3 = [0:12];
R4 = [0:15];

% Filler values
values = NaN(length(R1),length(R2),length(R3),length(R4));
for ia = 1:length(R1)
for ib = 1:length(R2)
for ic = 1:length(R3)
for id = 1:length(R4)
    values(ia,ib,ic,id) = ia+ib+ic+id;
end
end
end
end

% Target point
I = [1 2 6.4 3.2];

% 4 dimensional interpolation
% It is useful to compare single values between linInterp4 and interpn,
% but they cannot be understood well in a plot.
value = linInterp4(I,values,R1,R2,R3,R4)
value = interpn(R1,R2,R3,R4,values,I(1),I(2),I(3),I(4))

%% For Debugging: 2 dimensional interpolation
%value = interpn(R3,R4,squeeze(values(1,1,:,:)),I(3),I(4))
%value = linInterp2(I(3:4),squeeze(values(1,1,:,:)),R3,R4)
%
%% Plot the reduced-order mesh and the interpolated value
%surf(R4,R3,squeeze(values(1,1,:,:)))
%hold on
%plot3(I(4),I(3),value,'-mo','MarkerSize',15)
%hold off

%% For Debugging: 1 dimension interpolation
%%value = interpn(R4,squeeze(values(1,1,1,:)),I(4))
%value = linInterp1(I(4),squeeze(values(1,1,1,:)),R4)
%
%% Plot the reduced-order mesh and the interpolated value
%plot(R4,squeeze(values(1,1,1,:)),'.')
%hold on
%plot(I(4),value,'-mo','MarkerSize',15)
%hold off
