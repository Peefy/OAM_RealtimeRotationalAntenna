powerWaveGenerator = 1; % W 
powerAmplifier = 10;% W 功放
gainAntenna_dB =10;% 天线增益 dbi
gainAntenna = 10^(gainAntenna_dB/10);
lossLNA_dB = 1; % 低噪放损耗
rcs = .01; % m^2 rcs
rcs_dB = 10*log10(rcs); % rcs in db
range = 100; % m
kB = 1.38e-23;% J/K
b = 1000e6; % Hz
Te = 300; % K
powerReceiver =10*log10(powerAmplifier*gainAntenna^2*rcs/(4*pi)^3/range^4)+30% dBm
snr = powerReceiver - 10*log10(kB*Te*b)-11-30;
mV = 9;  %
ohm = 50;%
mW = 1000*(mV/1000)^2/ohm;  %
dBW = 10*log10(mW)         %
% dBW
% chirp信号设计，
% 脉冲时间为tp，脉冲间隔为tr；
% tp，tr的问题是一个最重要的设计问题，这里需要考虑的是
% 1、数据传输能力：传输速率的瓶颈受到了哪些限制-采样速率、板卡toPC、PC端处理
% 2、信号能量的问题，脉冲数量决定了产生的等效OAM模式数

% 估计传输速率
rateCard2Pc = 1e9; % PCIE-2.0 速度
fs = 6e9; 
% 脉冲数量多少合适



