% matlab ��ͨ�˲�����

b = fir1(5,0.5)
freqz(b,1,512); % ������ͼ���˲����ķ������� ,��Ȼfir�˲�����aϵ��ֻ��һ��1

% ����ͨ��ƥ���˲���

load chirp
fs = 1e9;

t = (0:length(y)-1)/fs; 
outy = filter(b,1,y);
figure 
subplot(211)
plot(t,y);
subplot(212)
plot(t,outy)