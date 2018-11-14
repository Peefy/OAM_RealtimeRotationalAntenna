% 理想低通滤波器
% 输入： SignalIn 输入信号
%        fCF 截止频率
%        fs  输入信号采样率
% 输出： SignalFilttered 滤波后信号
function SignalFilttered = funLowFillter(SignalIn,fCF,fs)
ts = 1/fs; % 采样间隔
nS = length(SignalIn); 
% Tr = 0:ts:nS*ts-ts; % 全时间，一次数据处理时间
df =1/nS/ts;
Fs = -floor(nS)/2*df:df:floor(nS)/2*df-df; 
FSignalIn = fftshift(fft(SignalIn));
Index = (-fCF<=Fs)&(Fs<=fCF);
FSignal1Filttered = zeros(1,nS);
FSignal1Filttered(Index) = FSignalIn(Index);
SignalFilttered=ifft(fftshift(FSignal1Filttered)); %低通滤波之后的信号
end