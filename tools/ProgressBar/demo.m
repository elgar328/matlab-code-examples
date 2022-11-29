clear; clc

fprintf('\nWithout task name\n')     % Without task name
PB = ProgressBar;
for ii = 1:30
    pause(0.05)
    PB.update(ii/30)
end

fprintf('\nWith task name\n')        % With task name
PB = ProgressBar('downloading..');
for ii = 1:30
    pause(0.05)
    PB.update(ii/30)
end

fprintf('\nTerminated task\n')       % Terminated task
PB = ProgressBar('uploading..');
for ii = 1:20
    pause(0.05)
    PB.update(ii/30)
end
PB.terminate

fprintf('\nCustom length\n')         % Custom length
PB = ProgressBar('Mini size',30);
for ii = 1:30
    pause(0.05)
    PB.update(ii/30)
end

fprintf('\nTask name update\n')      % Task name update
PB = ProgressBar;
for ii = 1:10
    pause(0.3)
    PB.update_task_name(['Task number (',num2str(ii),'/10)'])
    PB.update(ii/10)
end