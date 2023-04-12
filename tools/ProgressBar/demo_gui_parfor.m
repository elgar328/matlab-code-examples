clear; clc

fprintf('------- Without task name -------\n')          % Without task name
PB = ProgressBar_gui_parfor(300);
parfor ii = 1:300
    pause(0.5*rand)
    count(PB)
end

fprintf('\n-------- With task name ---------\n')        % With task name
PB = ProgressBar_gui_parfor(300, 'Task name');
parfor ii = 1:300
    pause(0.5*rand)
    count(PB)
end

