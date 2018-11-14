clc
clear 
close all
% ��ת���߲���
% ����һ������ɢ��㹹�ɵļ򵥸���Ŀ��
% Ѱ��һ���Ƕȣ�ʹ�ø�Ŀ�������沨ֱ�������»ز����ʼ�С
% ������ЧOAM�źţ����ҳ�һ����ġ�

% �źŲ���LFM�ź�
% ��������

c=3e8;                            % ����
f=10e9;                          % ����Ƶ��
lambda=c/f;                    % ���䲨��
k=2*pi/lambda;               % ��������
w=2*pi*f;                         % ������Ƶ��
% fs=100e9;                      % ����Ƶ�� 
% ts=1/fs;                           % ����ʱ����
% N=1e6;                           % �������


%% λ�ö��� 
% ����ϵ���ѿ�������ϵ�� z��Ϊ���䷽��y �߶ȣ�x ˮƽ
nScatters = 2;
centerPos = [0,1,20].'; % ɢ������������
TargetRel = [0.3,0,0;-0.3,0,0].';   %����ɢ���������������
TargetPos = TargetRel + centerPos; % λ������
RCS = [0.01, 0.01]; % ������ɢ����RCS
% �շ�����
transmitPos = [0;1;0];
receivePos = [0.1;1;0];

%% ����Ŀ������������£��������߻ز�����
% Theta = 0:0.001:pi;
% nTheta = length(Theta);
% AmplTheta = zeros(1,nTheta); % ��ɢ����ϳ��źŵķ�ֵ
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

thetaMin = 0.035; % ͨ������������һ����С��
RotMat = [cos(thetaMin) 0 sin(thetaMin); 
          0          1          0;
         -sin(thetaMin) 0 cos(thetaMin)];
TargetRot = RotMat*TargetRel+centerPos;
%% �����
% ���ֵ���
% ������ֵ
format compact
tp = 1.0e-6; % �̾���
tr = 2*tp; % 
power = 10; % ��λ ��
bandwidth = 200e6; % ����200M
fm = 200e6; % ��Ƶ�ز�Ƶ�㣻
fc = 10e9; % �ز���Ƶ
tst = 1.0e-11; % ��Ƶ����ʵ������Ƶ�� 
tsm = 1e-9; % �źŲ�������ʱ��


% chirp �źŲ���
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
chirpRate = bandwidth/tp; % ��Ƶб��
SignalMod = [cos(pi*chirpRate*Tp.^2+2*pi*fm*Tp) zeros(1,ntr-ntp)]; % ����ƵΪ����Ƶ���chirp�ź�
FSignalMod = fftshift(fft(SignalMod)); % 

%%  ����Ƶ����Ƶ
%  ʱ��任
TAll = 0:tst:tr-tst; % ��Ƶʱ��

SignalMod1 = interp1(Tr,SignalMod,TAll,'spline'); %ͨ����ֵ��������ԭ�ź�������
SignalCarrier = SignalMod1.*cos(2*pi*fc*TAll); % ��Ƶ������ӽ���Ͽ����������һ��������ƣ���������˲������ʱ���Ƶ����������ʲô��
FSignalCarrier = fftshift(fft(SignalCarrier));
% ��ͨ�˲�
load highpass; % ��ȡ��ͨ�˲���  ����Ϊhighpass
SignalTrans = filter(highpass,1,SignalCarrier);
FSignalTrans = fftshift(fft(SignalTrans));
% ���źŽ��и�ͨ�˲�
% SignalCarrier;
% figure 
% subplot(611)
% plot(Tr,SignalMod)
% xlabel('ʱ�䣨s��')
% ylabel('��ֵ')
% 
% subplot(612)
% plot(Fr,FSignalMod)
% xlabel('Ƶ�ʣ�Hz��')
% ylabel('��ֵ')
% 
% 
% subplot(613)
% plot(TAll,SignalCarrier); % ͼ
% xlabel('ʱ�䣨s��')
% ylabel('��ֵ')
% 
% subplot(614)
% plot(Fst,FSignalCarrier)
% xlabel('Ƶ�ʣ�Hz��')
% ylabel('��ֵ')
% 
% subplot(615)
% plot(TAll,SignalTrans); % ͼ
% xlabel('ʱ�䣨s��')
% ylabel('��ֵ')
% 
% subplot(616)
% plot(Fst,FSignalTrans)
% xlabel('Ƶ�ʣ�Hz��')
% ylabel('��ֵ')
% 
% subplot(313)
% plot(TAll,SignalCarrier1); % ͼ
%% �ŵ�


%% ���մ���

