clear all
close all
clc

% % Test cosineFun
% s = linspace(0,pi/2,100);
% ds = gradient(s);
% y = zeros(size(s));
% dy = zeros(size(s));
% 
% for n = 1:length(s)
%     a = cosineFun(0,pi/2,0,pi/2,s(n),ds(n));
%     y(n) = a.y;
%     dy(n) = a.dy;
% end
% 
% plot(y)
% 
% figure
% plot(dy)

% Generate a sine wave
freq = 0.5;
amp = 2;
t = 0:0.001:10;
y = amp*sin(t*pi*2*freq);
dy = 2*pi*amp*freq*cos(t*pi*2*freq);

plot(t,y)
hold on
plot(t,dy)