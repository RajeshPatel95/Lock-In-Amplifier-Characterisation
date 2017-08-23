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
