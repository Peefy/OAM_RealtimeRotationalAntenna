function [ndatanum, sampleRate]  = getdatanum()
sampleTime = 10e-6;
% 625MHz
sampleRate = 1250e6;
buffercount = sampleTime / (1 / sampleRate);
scale = round(buffercount / 1024);
% ndatanum = buffercount // 1024 * 1024;
ndatanum = 1024 * scale;
