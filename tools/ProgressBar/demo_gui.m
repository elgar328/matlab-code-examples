clear; clc

fprintf('------- Without task name -------\n')          % Without task name
PB = ProgressBar_gui;
for ii = 1:300
    pause(0.01)
    PB.update(ii/300)
end

fprintf('\n-------- With task name ---------\n')        % With task name
PB = ProgressBar_gui('Task 1');
for ii = 1:300
    pause(0.01)
    PB.update(ii/300)
end

fprintf('\n------- Task name update --------\n')        % Task name update
PB = ProgressBar_gui;
for ii = 1:5
    pause(1)
    PB.update_task_name("Task number "+ii+" of 100")
    PB.update(ii/5)
end
