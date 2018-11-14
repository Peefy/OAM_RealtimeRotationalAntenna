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
LFMDual = fliplr([cos(pi*mu*Tp.^2),zeros(1,nTp)]);
Tr = 0:ts:tr-ts;
dr = c/2*ts;
nTr = 2*nTp;
% plot(LFMDual);
close all;

load A_cd2s20md.mat;

ExpData = AI_Ch0;
SynData = AI_Ch2;
nData = length(AI_Ch0);
nPulse = floor(nData/nTp/2)-1; % 最后一个不想要

SignalMatched = zeros(1,nTr);
SignalMatchedSyn = zeros(1,nTr);
figure 
for iP = 1:1
    DataRange = (iP-1)*nTr+(1:nTr);
    Data1 = ExpData(DataRange);
    Data2 = SynData(DataRange);
    SignalMatched = SignalMatched+ifft(fft(Data1).*fft(LFMDual));
    SignalMatchedSyn = SignalMatchedSyn+ifft(fft(Data2).*fft(LFMDual));
end 

SignalAbs = abs(SignalMatched);
SignalSynAbs = abs(SignalMatchedSyn);
SignalAbsNorm = SignalAbs/max(SignalAbs);
[maxV,maxI]=max(SignalSynAbs);
SignalSynAbsNorm = SignalSynAbs/maxV;

plot(Tr*c/2,SignalAbs);hold on 
plot(Tr*c/2,SignalSynAbsNorm*1000);

rShow = 50; % range displayed in teh axis
nShow = floor(rShow/dr);
if nShow+maxI<=nTr % 
    SignalShow = SignalAbs(maxI:nShow+maxI);
else 
    nRest = nShow-(nTr-maxI);
    SignalShow = [SignalAbs(maxI:end),SignalAbs(1:nRest)];
end 
figure
Xx = (0:nShow)*dr;
plot(Xx,SignalShow);