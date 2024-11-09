clear all;

Uno = serialport("/dev/tty.usbserial-1410",115200); % update as required
a = readline(Uno);% set up begin

dt = 1/9615;
n = int16(0.4/dt)+1;
t = 0:dt:0.4;
a = 400;
f = 200;
read = zeros(1,n); % initalize read buffer

%noise=0;
%noise = round(50*cos(2*pi*4000*t)+ 200*sin(2*pi*1900*t));
%noise = round(wgn(1,n,400,'linear'));
noise = 40*sin(2*pi*4000*t)+60*sin(2*pi*7000*t);


y = round(a*sin(2*pi*f*t)+a-1);
%y = 200*ones(1,n);
%y = round(a*square(2*pi*f*t)+a-1);
source = y+noise;

send = string(int32(source));

for i = 1:n
    writeline(Uno,send(i));
    read(i) = readline(Uno);
end

figure;

t = t*1000;

    subplot(1,3,1);
plot(t,y);
axis([0 50 0 1024]);
title("Signal");
xlabel("Time (ms)"); ylabel("Amplitude");

    subplot(1,3,2)
plot(t,int32(source));
axis([0 50 0 1024]);
title("Signal + Noise");
ylabel("Time (ms)");
xlabel("Time (ms)"); ylabel("Amplitude");

    subplot(1,3,3);
plot(t,read);
axis([0 50 0 1024]);
title("Filtered Signal")
ylabel("Time (ms)");
xlabel("Time (ms)"); ylabel("Amplitude");
[readalign,yalign] = alignsignals(read,y);

readalign = readalign(500:1900); % match array count
yalign = yalign(500:1900); % match array count

squareRootDifference = sqrt(immse(readalign,yalign));

delete (Uno);