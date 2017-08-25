% tis0.05 is in mV not volts

files = dir('*.csv'); % all .csv files in the matlab directory will open
file_list = {files.name}';

cutoff = 0.01; % Cut off 1% of the ends of the signal to remove noise bursts
sweep_time = 4.0; % Duration of single sweep

minleft = intmax;
minright = intmax;
times = {};
voltages = {};
idxs = {};

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
    [val,idx] = max(voltage);
    arr = zeros(size,1);
    arr(idx,1) = val;
    
    times = [times, time];
    voltages = [voltages, voltage];
    idxs = [idxs, idx];
    
    if(idx<minleft)
        minleft = idx-1;
    end
    len = size-idx-1;
    if(len<minright)
        minright = len;
    end
end

for a = 1:length(file_list)
    time_in = times{1,a};
    voltage_in = voltages{1,a};
    idx_in = idxs{1,a};
    
    time = time_in(idx_in-minleft:idx_in+minright,1);
    time = time-time(1,1);
    
    start_time = time(minleft,1)-0.5*(1-cutoff)*sweep_time;
    end_time = time(minleft,1)+0.5*(1-cutoff)*sweep_time;
    
    start_index = 1;
    for i = 1:length(time)
        if(time(i, 1)-start_time>0)
            if(abs(time(i,1)-start_time>abs(time(i-1,1)-start_time)))
                start_index = i-1;
            else
                start_index = i;
            end
            break;
        end
    end
    
    end_index = 1;
    for i = 1:length(time)
        if(time(i, 1)-end_time>0)
            if(abs(time(i,1)-end_time>abs(time(i-1,1)-end_time)))
                end_index = i-1;
            else
                end_index = i;
            end
            break;
        end
    end
    
    voltage = voltage_in(idx_in-minleft:idx_in+minright,1);
    
    % Isolate sweep data
    time = time(start_index:end_index,1);
    voltage = voltage(start_index:end_index,1);
    
    % Make times start from 0s
    time = time-time(1,1);
   
    % voltage_smooth = smooth(time,voltage,0.005,'rloess');
    title('Varying Trc at 50 kHz mod. freq.')
    xlabel('time (s)')
    ylabel('Voltage (mV)')
    hold on;
    plot(time,voltage);
%     plot(time,voltage_smooth);
end
hold off;
legend ('0.02','0.05','0.1')



