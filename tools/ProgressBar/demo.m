%% gui progress bar

N = 100;
PB = ProgressBar(N);

for n = 1:N
    pause(0.2)      % Loop body

    PB.count
end

%% gui progress bar, task name, no log

N = 100;
PB = ProgressBar(N, taskname='For loop', no_log=true);

for n = 1:N
    pause(0.2)      % Loop body

    PB.count
end

%% gui progress bar, parfor

N = 600;
PB = ProgressBar(N, taskname='Parfor loop');

parfor n = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end

%% cli progress bar

N = 100;
PB = ProgressBar(N,taskname='For loop', ui='cli');

for n = 1:N
    pause(0.2)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, no log

N = 100;
PB = ProgressBar(N, ui='cli', no_log=true);

for n = 1:N
    pause(0.2)      % Loop body

    PB.count        % or count(PB)
end

%% cli progress bar, parfor

N = 600;
PB = ProgressBar(N, taskname='Parfor loop', ui='cli');

parfor n = 1:N
    pause(0.5*rand)  % Loop body

    count(PB)        % It is recommended to use count(PB)
                     % instead of PB.count in parfor loop.
end

%% ProgressBar vs. waitbar (MATLAB builtin)

clear; clc; close all;
N = 100000;

% -------------- waitbar (MATLAB builtin)
fprintf('waitbar (MATLAB builtin)\n')
tic
WB = waitbar(0,'waitbar');
for n = 1:N, waitbar(n/N,WB); end
close(WB)
toc

% -------------- ProgressBar gui
fprintf('\n')
tic
PB = ProgressBar(N, taskname='ProgressBar gui');
for n = 1:N, PB.count; end
toc

% -------------- ProgressBar cli
fprintf('\n')
tic
PB = ProgressBar(N, taskname='ProgressBar cli', ui='cli');
for n = 1:N, PB.count; end
toc
