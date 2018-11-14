function WriteToFile(DatCh0, DatCh1, DatCh2, DatCh3, fileheader, filetail)

channel_name = {'DatCh0', 'DatCh2'};

assignin('base', channel_name{1}, DatCh0);
assignin('base', channel_name{2}, DatCh2);

for j = 1 : length(channel_name)
    filename = [fileheader, '_', channel_name{j}, '_', filetail, '.mat'];
    save(filename, channel_name{j});
    % fprintf('save %s success!\n', filename);
end