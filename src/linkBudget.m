powerWaveGenerator = 1; % W 
powerAmplifier = 10;% W ����
gainAntenna_dB =10;% �������� dbi
gainAntenna = 10^(gainAntenna_dB/10);
lossLNA_dB = 1; % ��������
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
% chirp�ź���ƣ�
% ����ʱ��Ϊtp��������Ϊtr��
% tp��tr��������һ������Ҫ��������⣬������Ҫ���ǵ���
% 1�����ݴ����������������ʵ�ƿ���ܵ�����Щ����-�������ʡ��忨toPC��PC�˴���
% 2���ź����������⣬�������������˲����ĵ�ЧOAMģʽ��

% ���ƴ�������
rateCard2Pc = 1e9; % PCIE-2.0 �ٶ�
fs = 6e9; 
% �����������ٺ���



