close all
clear
clc

am = 4;
ka = 0.1;
ac = 1/ka;
fm = 20;
fc = 100;
fs = 1000;
t = 0:1/fs:2;
f = linspace(-fs/2, fs/2, length(t));

mt = am.*cos(2*pi*fm*t);
ct = ac.*cos(2*pi*fc*t);
st = ct.*(1 + ka*mt);

mf = fftshift(fft(mt))/length(t);
cf = fftshift(fft(ct))/length(t);
sf = fftshift(fft(st))/length(t);

env1 = ac*(1+ka*mt);
env2 = -env1;

rt = st.*ct;
rf = fftshift(fft(rt))/length(t);
G = 2/ac;
lpf = G*rectpuls(f, 2.5*fm);

vf = lpf.*rf;
vt = ifft(ifftshift(vf))*length(t);
vt = vt - mean(vt);

figure(1)
subplot(2,2,1)
plot(t, mt)
title('Modulating Signal in Time Domian')
grid minor
axis([0 0.4 -inf inf])

subplot(2,2,2)
plot(f, abs(mf), 'linewidth', 3);
title('Modulating Signal in Frequency Domian')
grid minor
axis([-fm-fc fm+fc -inf inf])

subplot(2,2,3)
plot(t, ct)
title('Carrier in Time Domian')
grid minor
axis([0 0.4 -inf inf])

subplot(2,2,4)
plot(f, abs(cf), 'linewidth', 3)
title('Carrier in Frequency Domian')
grid minor
axis([-2*fc 2*fc -inf inf])

figure(2)
subplot(2,1,1)
plot(t, st)
hold on
plot(t, env1, 'r--')
hold on
plot(t, env2, 'g--')
title('Modulated Signal in Time Domain')
grid minor
hold off
axis([0 1.2 -inf inf])

subplot(2,1,2)
plot(f, abs(sf),'linewidth', 3)
title('Modulated Signal in Frequency Domain')
grid minor

figure(3)
subplot(4,1,1)
plot(t, rt)
title('Received Signal in Time Domain')
grid minor

subplot(4,1,2)
plot(f, lpf, f, abs(rf))
legend('Lowpass Filter', 'RF Signal')
grid minor

subplot(4,1,3)
plot(f, abs(vf), 'linewidth', 3)
title('Filtered Signal in Frequency Domain')
grid minor

subplot(4,1,4)
plot(t, vt, t, mt, 'r--')
title('Filtered Signal in Time Domain')
legend('Received Signal', 'Sent Signal')
grid minor