% A = table2array(readtable('20170822-0002(0.7kHz-1.7kHz,tis0.001).csv'));
% B = readtable('20170822-0001(0.7kHz-1.7kHz,tis0.002).csv');
% C = readtable('20170822-0001(0.7kHz-1.7kHz,tis0.05).csv');
% tis0.05 is in mV not volts
% 
% colA1 = A(2:1000005,1);
% colA2 = A(2:1000005,2);
% 
% str2double(colA1)
% colA11 = str2double(colA1);
% colA12 = str2double(colA2);
% 
% plot(colA11, colA12);

files = dir('*.csv'); 
file_list = {files.name}';

for a = 1:length(file_list)
    filename = file_list{a};
    data = table2array(readtable(filename));
    size = length(data);
    time = str2double(data(2:size,1));
    voltage = str2double(data(2:size,2));
    unit = data(1,2);
    
    switch(char(unit))
        case '(V)'
            voltage = voltage*1000;
    end
    plot(time, voltage);
    hold on;
end
hold off;
legend ('first','second','third')