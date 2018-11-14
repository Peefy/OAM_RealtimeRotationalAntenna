close all 
clear all
clc
%% 常数定义
c = 3e8;
kB = 1.38e-23;% J/K
Te = 300; % K
%% 发射天线和接收天线位置； 采用三维空间
% 坐标轴 笛卡尔坐标系，x：横向；y：纵向（距离）；z：垂直
PosTrans = [0;0;0]; %
PosRecev = [0;0;0]; % 
%% 散射点定义
% 多个点，然后多点叠加；
% 物体1 
nScatter1 = 2;
PosScatter1 = zeros(3,nScatter1); % 
Sigma1 = [1 1];%2*rand(1,nScatter1); % RCS 
% 随机生成，在一个区间内均匀分布 x ~ [-.2,.2] y~[10.1 10.3], z~ [-.1 .1];
% PosScatter1(1,:) = .4*rand(1,nScatter1)-0.2;
% PosScatter1(2,:) = 0.2*rand(1,nScatter1)+10.1;
% PosScatter1(3,:) = 0.2*rand(1,nScatter1)-0.1;
PosScatter1 = [ 0.2 -0.2;...
               10.2 10.2;...
                  0 0];
% 物体2 ;
nScatter2 = 2;
PosScatter2 = zeros(3,nScatter2);
Sigma2 = [1 1];%rand(1,nScatter2); % RCS 
% 随机生成，在一个区间内均匀分布 x ~ [-.2,.2] y~[10.8 11], z~ [-.1 .1];
% PosScatter2(1,:) = 0.4*rand(1,nScatter2)-0.2;
% PosScatter2(2,:) = 0.2*rand(1,nScatter2)+10.5;
% PosScatter2(3,:) = 0.2*rand(1,nScatter2)-0.1;
PosScatter2 = [ 0.2 -0.2;...
               10.8 10.8;...
                  0 0];
% 总体
nScatters = nScatter1 + nScatter2;
PosScatters = [PosScatter1,PosScatter2]; 
Sigma = [Sigma1 Sigma2]; 
RangeScatters = sqrt(sum((PosScatters-repmat(PosTrans,[1,nScatters])).^2))...
               +sqrt(sum((PosScatters-repmat(PosRecev,[1,nScatters])).^2)); 
%% 线性调频信号
fMax = 100e9; % 仿真最大采样率，模拟真实，决定了数据的真实长度，仿真程序当中的最小时间单元，可以模拟一下最小采样间隔
tMin = 1/fMax; % 时间用Min表示最小时间间隔
fc = 10e9; % 射频频率
fs = 2e9; % 接收端中频采样率
nMs = floor(fMax/fs); % 模拟-采样 间隔
ts = 1/fs; % 采样时间间隔
bw = 500e6; % 带宽
tp = .1e-6; % 脉冲宽度
tr = .5e-6; % 脉冲重复周期
Tr = 0:ts:tr-ts; % 脉冲周期的时间
Tp = 0:ts:tp-ts; % 脉冲内的时间
nTp = length(Tp); % 
TpM = 0:tMin:tp-tMin; 
TrM = 0:tMin:tr-tMin;
nTpM = length(TpM);
nTr = length(Tr);
mu = bw/tp; % 调频斜率
figure 
subplot(211)
Signal00 = cos(pi*mu*TpM.^2); % 发射信号
plot(TpM,Signal00);
title('基带信号')
subplot(212)
Signal0 = cos(pi*mu*TpM.^2+2*pi*fc*TpM); % 发射信号
plot(TpM,Signal0);
title('发送射频信号')
%% 信道
% 经过散射点的反射之后的信号表示 rect(t-td量化)*cos(2*pi*fc*(t-td))
TDelayScatters = RangeScatters/c; % 回波时延
% 
tRev = .2e-6; % 一次处理时间长度
TRev = 0:tMin:tRev-tMin;
nTRev = length(TRev);
SignalRev0 = zeros(1,nTRev);
for iS = 1:nScatters
    tDelay = TDelayScatters(iS);
    sigma = Sigma(iS);
    ntDelay = floor(tDelay/tMin);
    SignalTemp = zeros(1,nTRev);
    % SignalTemp(ntDelay+1:ntDelay+nTpM) = sigma*cos(pi*mu*(TRev(ntDelay+1:ntDelay+nTpM)-tDelay).^2+2*pi*fc*(TRev(ntDelay+1:ntDelay+nTpM)-tDelay));
    %SignalTemp(ntDelay+1:ntDelay+nTpM-1) = sigma*cos(pi*mu*(TRev(ntDelay:ntDelay+nTpM-1)-tDelay).^2+2*pi*fc*(TRev(ntDelay:ntDelay+nTpM-1)-tDelay));
    SignalTemp(ntDelay+1:ntDelay+nTpM) = sigma*Signal0;
    SignalRev0 = SignalRev0+SignalTemp;
end 

%% 接收端信号处理
% 混频
SignalRevMix = SignalRev0.*cos(2*pi*fc*TRev);
fCF = 5*bw;
SignalFilttered = funLowFillter(SignalRevMix,fCF,fMax);
subplot(311)
plot(TRev,SignalFilttered);% 画出接收处的信号
% 采样
SignalSampled = SignalFilttered(1:nMs:end);
T = TRev(1:nMs:end);
nT = length(T);
subplot(312)
plot(T,SignalSampled);
% 噪声
maxAmplitude = max(SignalSampled);
signalPower = maxAmplitude^2/sqrt(2);
snr_dB = 0;
snr = 10^(snr_dB/10);
noisePower = signalPower/snr;
SignalNoised = SignalSampled+sqrt(noisePower)*randn(1,nT); % 加入高斯噪声
subplot(313)
plot(T,SignalNoised);
% 匹配滤波
SignalDual = fliplr([cos(pi*mu*Tp.^2) zeros(1,nT-nTp)]);
SignalMatched = abs(ifft(fft(SignalDual).*fft(SignalNoised)));
figure 
plot(T*c/2,SignalMatched)
xlabel('距离（m）')
ylabel('幅值')