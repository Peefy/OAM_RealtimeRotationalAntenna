c = 3e8;
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
LFMDual = cos(pi*mu*Tp.^2);
figure 
plot(LFMDual)
Tr = 0:ts:tr-ts;
dr = c/2*ts;
nTr = 2*nTp;
% plot(LFMDual);

load cd10m.mat;

ExpData = AI_Ch0;
nData = length(AI_Ch0);
nPulse = floor(nData/nTp/2)-1; % 最后一个不想要
SignalMatched = [];
figure 
% for iP = 1:nPulse
%     DataRange = (iP-1)*nTr+(1:nTr);
%     Data1 = ExpData(DataRange);
%     SignalMatched = [SignalMatched,ifft(fft(Data1).*fft(LFMDual))];
% end 

result = xcorr(LFMDual,ExpData);
nl = length(result);
tr = (1:nl)*dr;
% plot(Tr*dr,abs(SignalMatched));
plot(tr,abs(result))