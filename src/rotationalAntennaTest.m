clc
clear 
close all
% 旋转天线测试
% 建立一个两个散射点构成的简单复杂目标
% 寻找一个角度，使得该目标在球面波直接照射下回波功率极小
% 建立等效OAM信号，并找出一个大的。

% 信号采用LFM信号
% 考虑噪声

c=3e8;                            % 光速
f=10e9;                          % 发射频率
lambda=c/f;                    % 发射波长
k=2*pi/lambda;               % 传播常数
w=2*pi*f;                         % 传播角频率
% fs=100e9;                      % 采样频率 
% ts=1/fs;                           % 采样时间间隔
% N=1e6;                           % 仿真点数


%% 位置定义 
% 坐标系：笛卡尔坐标系， z轴为入射方向，y 高度，x 水平
nScatters = 2;
centerPos = [0,1,20].'; % 散射体中心坐标
TargetRel = [0.3,0,0;-0.3,0,0].';   %　子散射体相对中心坐标
TargetPos = TargetRel + centerPos; % 位置坐标
RCS = [0.01, 0.01]; % 两个子散射体RCS
% 收发天线
transmitPos = [0;1;0];
receivePos = [0.1;1;0];

%% 计算目标在现在情况下，接收天线回波功率
% Theta = 0:0.001:pi;
% nTheta = length(Theta);
% AmplTheta = zeros(1,nTheta); % 子散射体合成信号的幅值
% for iTheta = 1:nTheta
%     theta = Theta(iTheta);
%     RotMat = [cos(theta) 0 sin(theta); 
%               0          1          0;
%              -sin(theta) 0 cos(theta)];
%     TargetRot = RotMat*TargetRel+centerPos;
%     Ranges = sqrt(sum((TargetRot-repmat(transmitPos,[1,2])).^2))...
%             +sqrt(sum((TargetRot-repmat(receivePos,[1,2])).^2));
%     AmplTheta(iTheta) = abs(sum(exp(1j*k*Ranges)));
% end 
% plot(Theta,AmplTheta);

thetaMin = 0.035; % 通过上面的算出来一个最小的
RotMat = [cos(thetaMin) 0 sin(thetaMin); 
          0          1          0;
         -sin(thetaMin) 0 cos(thetaMin)];
TargetRot = RotMat*TargetRel+centerPos;
%% 发射端
% 数字调制
% 变量赋值
format compact
tp = 1.0e-6; % 短距离
tr = 2*tp; % 
power = 10; % 单位 Ｗ
bandwidth = 200e6; % 带宽200M
fm = 200e6; % 中频载波频点；
fc = 10e9; % 载波载频
tst = 1.0e-11; % 射频（真实）采样频率 
tsm = 1e-9; % 信号产生采样时间


% chirp 信号产生
ntp = round(tp/tsm);
ntr = round(tr/tsm);
Tp = (0:ntp-1)*tsm;
Tr = (0:ntr-1)*tsm;
fsm = 1/tsm;
deltaf = 1/tr;
Fr = -fsm/2:deltaf:fsm/2-deltaf;
fst = 1/tst;

Fst = -fst/2:deltaf:fst/2-deltaf;

format long
chirpRate = bandwidth/tp; % 调频斜率
SignalMod = [cos(pi*chirpRate*Tp.^2+2*pi*fm*Tp) zeros(1,ntr-ntp)]; % 以中频为中心频点的chirp信号
FSignalMod = fftshift(fft(SignalMod)); % 

%%  上射频，混频
%  时间变换
TAll = 0:tst:tr-tst; % 射频时间

SignalMod1 = interp1(Tr,SignalMod,TAll,'spline'); %通过插值方法，将原信号升采样
SignalCarrier = SignalMod1.*cos(2*pi*fc*TAll); % 混频结果，从结果上看，这个就是一个包络调制，必须进行滤波，这个时候混频器的作用是什么？
FSignalCarrier = fftshift(fft(SignalCarrier));
% 高通滤波
load highpass; % 读取高通滤波器  变量为highpass
SignalTrans = filter(highpass,1,SignalCarrier);
FSignalTrans = fftshift(fft(SignalTrans));
% 对信号进行高通滤波
% SignalCarrier;
% figure 
% subplot(611)
% plot(Tr,SignalMod)
% xlabel('时间（s）')
% ylabel('幅值')
% 
% subplot(612)
% plot(Fr,FSignalMod)
% xlabel('频率（Hz）')
% ylabel('幅值')
% 
% 
% subplot(613)
% plot(TAll,SignalCarrier); % 图
% xlabel('时间（s）')
% ylabel('幅值')
% 
% subplot(614)
% plot(Fst,FSignalCarrier)
% xlabel('频率（Hz）')
% ylabel('幅值')
% 
% subplot(615)
% plot(TAll,SignalTrans); % 图
% xlabel('时间（s）')
% ylabel('幅值')
% 
% subplot(616)
% plot(Fst,FSignalTrans)
% xlabel('频率（Hz）')
% ylabel('幅值')
% 
% subplot(313)
% plot(TAll,SignalCarrier1); % 图
%% 信道


%% 接收处理

