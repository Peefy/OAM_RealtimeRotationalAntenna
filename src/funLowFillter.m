% �����ͨ�˲���
% ���룺 SignalIn �����ź�
%        fCF ��ֹƵ��
%        fs  �����źŲ�����
% ����� SignalFilttered �˲����ź�
function SignalFilttered = funLowFillter(SignalIn,fCF,fs)
ts = 1/fs; % �������
nS = length(SignalIn); 
% Tr = 0:ts:nS*ts-ts; % ȫʱ�䣬һ�����ݴ���ʱ��
df =1/nS/ts;
Fs = -floor(nS)/2*df:df:floor(nS)/2*df-df; 
FSignalIn = fftshift(fft(SignalIn));
Index = (-fCF<=Fs)&(Fs<=fCF);
FSignal1Filttered = zeros(1,nS);
FSignal1Filttered(Index) = FSignalIn(Index);
SignalFilttered=ifft(fftshift(FSignal1Filttered)); %��ͨ�˲�֮����ź�
end