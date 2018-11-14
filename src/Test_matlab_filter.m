% matlab 低通滤波测试

b = fir1(5,0.5)
freqz(b,1,512); % 用来画图看滤波器的幅相特性 ,显然fir滤波器的a系数只有一个1

% 数据通过匹配滤波后

load chirp
fs = 1e9;

t = (0:length(y)-1)/fs; 
outy = filter(b,1,y);
figure 
subplot(211)
plot(t,y);
subplot(212)
plot(t,outy)