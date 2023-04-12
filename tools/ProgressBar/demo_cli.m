clear; clc

fprintf('------- Without task name -------\n')          % Without task name
PB = ProgressBar_cli;
for ii = 1:300
    pause(0.01)
    PB.update(ii/300)
end

fprintf('\n-------- With task name ---------\n')        % With task name
PB = ProgressBar_cli('Task 1');
for ii = 1:300
    pause(0.01)
    PB.update(ii/300)
end

fprintf('\n-------- Terminated task --------\n')        % Terminated task
PB = ProgressBar_cli('Task 2');
for ii = 1:20
    pause(0.1)
    PB.update(ii/30)
end
PB.terminate

fprintf('\n--------- Custom length ---------\n')        % Custom length
PB = ProgressBar_cli('Mini size',40);
for ii = 1:30
    pause(0.1)
    PB.update(ii/30)
end

fprintf('\n------- Task name update --------\n')        % Task name update
PB = ProgressBar_cli;
for ii = 1:5
    pause(1)
    PB.update_task_name("Task number "+ii+" of 1000")
    PB.update(ii/5)
end