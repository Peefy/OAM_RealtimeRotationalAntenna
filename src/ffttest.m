
fs1 = 625e6;
ts1 = 1/fs1;

fs = 1.25e9;
ts = 1/fs;
bw = 200e6;
tp = ts1*1024;
tr = ts1*2048;
mu = bw/tp;

Tp = 0:ts:tp-ts;
nTp = length(Tp);

signalTp = cos(pi*mu*Tp.^2);
signalTp1 = zeros(1,2*nTp);
signalTp1(2048:2048+nTp-1) = signalTp;
LFMDual = fliplr(cos(pi*mu*Tp.^2));

s1 = ifft(fft(signalTp1(1:nTp)).*fft(LFMDual));
s2 = ifft(fft(signalTp1(nTp+1:2*nTp)).*fft(LFMDual));

plot([s1 s2]);