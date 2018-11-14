close all 
clear all
clc
%% ��������
c = 3e8;
kB = 1.38e-23;% J/K
Te = 300; % K
%% �������ߺͽ�������λ�ã� ������ά�ռ�
% ������ �ѿ�������ϵ��x������y�����򣨾��룩��z����ֱ
PosTrans = [0;0;0]; %
PosRecev = [0;0;0]; % 
%% ɢ��㶨��
% ����㣬Ȼ������ӣ�
% ����1 
nScatter1 = 2;
PosScatter1 = zeros(3,nScatter1); % 
Sigma1 = [1 1];%2*rand(1,nScatter1); % RCS 
% ������ɣ���һ�������ھ��ȷֲ� x ~ [-.2,.2] y~[10.1 10.3], z~ [-.1 .1];
% PosScatter1(1,:) = .4*rand(1,nScatter1)-0.2;
% PosScatter1(2,:) = 0.2*rand(1,nScatter1)+10.1;
% PosScatter1(3,:) = 0.2*rand(1,nScatter1)-0.1;
PosScatter1 = [ 0.2 -0.2;...
               10.2 10.2;...
                  0 0];
% ����2 ;
nScatter2 = 2;
PosScatter2 = zeros(3,nScatter2);
Sigma2 = [1 1];%rand(1,nScatter2); % RCS 
% ������ɣ���һ�������ھ��ȷֲ� x ~ [-.2,.2] y~[10.8 11], z~ [-.1 .1];
% PosScatter2(1,:) = 0.4*rand(1,nScatter2)-0.2;
% PosScatter2(2,:) = 0.2*rand(1,nScatter2)+10.5;
% PosScatter2(3,:) = 0.2*rand(1,nScatter2)-0.1;
PosScatter2 = [ 0.2 -0.2;...
               10.8 10.8;...
                  0 0];
% ����
nScatters = nScatter1 + nScatter2;
PosScatters = [PosScatter1,PosScatter2]; 
Sigma = [Sigma1 Sigma2]; 
RangeScatters = sqrt(sum((PosScatters-repmat(PosTrans,[1,nScatters])).^2))...
               +sqrt(sum((PosScatters-repmat(PosRecev,[1,nScatters])).^2)); 
%% ���Ե�Ƶ�ź�
fMax = 100e9; % �����������ʣ�ģ����ʵ�����������ݵ���ʵ���ȣ���������е���Сʱ�䵥Ԫ������ģ��һ����С�������
tMin = 1/fMax; % ʱ����Min��ʾ��Сʱ����
fc = 10e9; % ��ƵƵ��
fs = 2e9; % ���ն���Ƶ������
nMs = floor(fMax/fs); % ģ��-���� ���
ts = 1/fs; % ����ʱ����
bw = 500e6; % ����
tp = .1e-6; % ������
tr = .5e-6; % �����ظ�����
Tr = 0:ts:tr-ts; % �������ڵ�ʱ��
Tp = 0:ts:tp-ts; % �����ڵ�ʱ��
nTp = length(Tp); % 
TpM = 0:tMin:tp-tMin; 
TrM = 0:tMin:tr-tMin;
nTpM = length(TpM);
nTr = length(Tr);
mu = bw/tp; % ��Ƶб��
figure 
subplot(211)
Signal00 = cos(pi*mu*TpM.^2); % �����ź�
plot(TpM,Signal00);
title('�����ź�')
subplot(212)
Signal0 = cos(pi*mu*TpM.^2+2*pi*fc*TpM); % �����ź�
plot(TpM,Signal0);
title('������Ƶ�ź�')
%% �ŵ�
% ����ɢ���ķ���֮����źű�ʾ rect(t-td����)*cos(2*pi*fc*(t-td))
TDelayScatters = RangeScatters/c; % �ز�ʱ��
% 
tRev = .2e-6; % һ�δ���ʱ�䳤��
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

%% ���ն��źŴ���
% ��Ƶ
SignalRevMix = SignalRev0.*cos(2*pi*fc*TRev);
fCF = 5*bw;
SignalFilttered = funLowFillter(SignalRevMix,fCF,fMax);
subplot(311)
plot(TRev,SignalFilttered);% �������մ����ź�
% ����
SignalSampled = SignalFilttered(1:nMs:end);
T = TRev(1:nMs:end);
nT = length(T);
subplot(312)
plot(T,SignalSampled);
% ����
maxAmplitude = max(SignalSampled);
signalPower = maxAmplitude^2/sqrt(2);
snr_dB = 0;
snr = 10^(snr_dB/10);
noisePower = signalPower/snr;
SignalNoised = SignalSampled+sqrt(noisePower)*randn(1,nT); % �����˹����
subplot(313)
plot(T,SignalNoised);
% ƥ���˲�
SignalDual = fliplr([cos(pi*mu*Tp.^2) zeros(1,nT-nTp)]);
SignalMatched = abs(ifft(fft(SignalDual).*fft(SignalNoised)));
figure 
plot(T*c/2,SignalMatched)
xlabel('���루m��')
ylabel('��ֵ')