% This function isolates sweep data from a dataset
% It accepts the following parameters:
% sweep_time - number; duration of a single sweep
% start_freq - the start range of the frequency
% end_freq - the end value of the frequency range
% cutoff - number; fraction of sweep to cut off of each end to remove noise bursts
% or other unwanted end effects
% dir - string; directory of files
% file_type - string; file extension
% smooth_param - parameter used to smooth out noisy data
function isolate_sweep(sweep_time, start_freq, end_freq, cutoff, loc, file_type,smooth_param)

files = dir(strcat(loc, '.', file_type)); % Open data files
file_list = {files.name}';

minleft = intmax;
minright = intmax;
times = {};
frequency = {};
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
    
    % Centre the peak around exactly half the the sweep time
    time = time+(cutoff*sweep_time)*0.5-time(1,1);
    range = (end_freq-start_freq)*(1-2*cutoff);
    frequency = time/time(end,1)*range+start_freq;
    
   
%     voltage_smooth = smooth(frequency,voltage,smooth_param,'rloess');
    title('Varying Trc at 50 kHz mod. freq.')
    xlabel('Frequency (kHz)')
    ylabel('Voltage (mV)')
    hold on;
    plot(frequency,voltage);
%     plot(frequency,voltage_smooth);
end
hold off;

legend_strings = {};
for a = 1:length(file_list)
    legend_strings{end+1} = file_list{a};
end
legend(legend_strings{:});

end

