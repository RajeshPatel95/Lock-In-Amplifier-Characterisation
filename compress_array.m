% Divides array into box_size chunks, averages them and returns an
% array of these averages. If the array length is not a perfect multiple
% of box_size, then the remaining (< box_size) elements at the end are averaged over
% and become the last element of the returned array
function arr=compress_array(array, box_size)

% Size of array and number of box_size that fit in it
size = length(array)
num_boxes = floor(size/box_size);

% If the array length is not a perfect multiple of box_size,
% treat the remaining elements at the end as a special case
% and make their average as
if(rem(size, box_size))
    arr=zeros(1,num_boxes+1);
    
    for i=1:num_boxes
        arr(i) = sum(array((1+i*box_size-box_size):(i*box_size)))/box_size;
    end
    arr(num_boxes+1) = sum(array(num_boxes*box_size+1:end))/length(array(num_boxes*box_size+1:end));

% Length of array is evenly divisible by boxcar
else
    arr=zeros(1,num_boxes);
    
    for i=1:num_boxes
        arr(i) = sum(array((1+i*box_size-box_size):(i*box_size)))/box_size;
    end
end
end