clear; clc

fprintf('------- Without task name -------\n')          % Without task name
PB = ProgressBar_cli_parfor(300);
parfor ii = 1:300
    pause(0.5*rand)
    count(PB)
end

fprintf('\n-------- With task name ---------\n')        % With task name
PB = ProgressBar_cli_parfor(300, 'Task 1');
parfor ii = 1:300
    pause(0.5*rand)
    count(PB)
end

fprintf('\n-------- Terminated task --------\n')        % Terminated task
PB = ProgressBar_cli_parfor(300, 'Task 2');
parfor ii = 1:200
    pause(0.5*rand)
    count(PB)
end
PB.terminate

fprintf('\n--------- Custom length ---------\n')        % Custom length
PB = ProgressBar_cli_parfor(300, 'Mini size', 40);
parfor ii = 1:300
    pause(0.5*rand)
    count(PB)
end
