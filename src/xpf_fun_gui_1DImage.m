% 用于读取相应数据，并且进行一维距离成像
% 在信号坐标轴以高速率刷新，在距离像坐标轴以低速率刷新
% 输入参数：
%   handles: 窗体句柄
%       主要使用 handles.axes_signal: 用来显示信号
%                handles.axes_image: 用来显示一维距离像
%   dataSetName : 需要读取的数据集
% 

function [TShow,ExpDataShow,RShow,ImageShow] = xpf_fun_gui_1DImage(handles,AI_Ch0, AI_Ch2)
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
% close all;

% load A_cd2s5ma.mat;

% load A_cd2s10m.mat; % 10 m, a+b
% load A_cd2s10mb.mat; % 10 m, b
% load A_cd2s10mc.mat; % 10 m, 无目标
% load A_cd2s10ma.mat; % 只有a目标 ,10m，但是放回去后第一个幅值小了很多
%  load cd2s25m.mat; %  20m以上  OAM
% load A_cd2s20ma.mat; % 20m以上 无OAM 
%  load cd2s5ma.mat; % 10 m, b
ExpData = AI_Ch0 * 32768;
SynData = AI_Ch2 * 32768;
nData = length(AI_Ch0);
nPulse = floor(nData/nTp/2)-1; % 最后一个不想要

% 先显示信号
nShow = 3000; % 一次信号的长度
ExpDataShow = ExpData(1:nShow);
TShow = (1:nShow)*ts; % 显示时长
% axes(handles.axes_signal); % 获得信号显示axes
% plot(TShow,ExpDataShow); 

SignalMatched = zeros(1,nTr);
SignalMatchedSyn = zeros(1,nTr);
% figure 
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
% 
% plot(Tr*c/2,SignalAbs);hold on 
% plot(Tr*c/2,SignalSynAbsNorm*1000);

rShow = 50; % range displayed in the axis
nShow = floor(rShow/dr);
if nShow+maxI<=nTr % 
    SignalShow = SignalAbs(maxI:nShow+maxI);
else 
    nRest = nShow-(nTr-maxI);
    SignalShow = [SignalAbs(maxI:end),SignalAbs(1:nRest)];
end 
% axes(handles.axes_image);
Xx = (0:nShow)*dr;
RShow = Xx;
ImageShow = SignalShow;
% figure 
% plot(Xx,SignalShow);



end 