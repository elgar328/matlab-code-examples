% ProgressBar_gui_parfor - Handy waitbar for parfor
%
%     USAGE
%     |   task_name = 'Task name';
%     |   
%     |   PB = ProgressBar_gui_parfor;
%     |   % or PB = ProgressBar_gui_parfor(task_name);
%     |   for ii = 1:10
%     |       pause(0.5)
%     |       PB.update(ii/10)
%     |   end
%
%     created 2023. 04. 13.
%     author  Cho HyunGwang
% 
%     https://github.com/elgar328/matlab-code-examples/tree/main/tools/ProgressBar

classdef ProgressBar_gui_parfor < handle
    % ---------------------------- properties -----------------------------
    properties (SetAccess = immutable, GetAccess = private)
        Queue
        N
    end
    properties (Access = private, Transient)
        counter = 0
    end
    properties (SetAccess = immutable, GetAccess = private, Transient)
        Listener = []
    end

    properties (SetAccess = private, Transient)
        task_name
        start_time = []
        end_time
    end
    properties (SetAccess = private, Hidden = true, Transient)
        time_info = "";
        ratio = 0;
        int_percent = 0;
    end
    properties (SetAccess = immutable, Hidden = true, Transient)
        fig_handle
        ratio_resol = 0.001;
    end

    methods
        % -------------------------- Constructor --------------------------
        function obj = ProgressBar_gui_parfor(N, task_name)
            arguments
                N (1,1) double {mustBePositive,mustBeFinite, ...
                                mustBeReal,mustBeInteger}
                task_name (1,:) char {mustBeText} = '';
            end
            obj.N = N;
            obj.Queue = parallel.pool.DataQueue;
            obj.Listener = afterEach(obj.Queue, @(~) localIncrement(obj));
            obj.task_name = task_name;
            obj.fig_handle = waitbar(0, '', 'Name', ...
                sprintf('%d%%  %s',obj.int_percent, obj.task_name));
            obj.fig_handle.Children.Title.FontSize = 13;
        end

        % ---------------------------- Counter ----------------------------
        function count(obj)
            send(obj.Queue, true);
        end
        
        % -------------------------- Destructor ---------------------------
        function delete(obj)
            delete(obj.fig_handle);
            delete(obj.Queue);
        end
    end

    methods (Access = private)
        % ------------------------- localIncrement ------------------------
        function localIncrement(obj)
            if isempty(obj.start_time)
                obj.start_time = datetime();
            end

            obj.counter = 1 + obj.counter;
            ratio_new = obj.counter/obj.N;

            if obj.int_percent ~= floor(ratio_new*100)
                obj.int_percent = floor(ratio_new*100);
                obj.fig_handle.Name = ...
                    sprintf('%d%%  %s',obj.int_percent, obj.task_name);
            end
            if obj.ratio + obj.ratio_resol <= ratio_new
                obj.ratio = ratio_new;
                waitbar(obj.ratio, obj.fig_handle)
            end
            new_time_info = get_time_info_string_gui(obj);
            if ~strcmp(obj.time_info, new_time_info)
                obj.time_info = new_time_info;
                waitbar(obj.ratio, obj.fig_handle, obj.time_info)
            end

            if obj.counter == obj.N
                obj.end_time = datetime();
                elapsed = obj.end_time - obj.start_time;
                if isempty(obj.task_name)
                    fprintf('Elapsed time: %s\n', ...
                        duration2string(elapsed))
                else
                    fprintf('%s, elapsed time: %s\n', ...
                        obj.task_name, duration2string(elapsed))
                end
                obj.delete
            end
        end
    end
end

% ---------------------------- Local functions ----------------------------
function string_out = duration2string(dur)
if isinf(dur)
    string_out = "Inf";
    return
end
if dur >= days(1)
    string_out = sprintf('%d day, %d hour', ...
        floor(dur/days(1)), ...
        ceil(hours(mod(dur,days(1)))));
elseif dur >= hours(1)
    string_out = sprintf('%d hour, %d min', ...
        floor(dur/hours(1)), ...
        ceil(minutes(mod(dur,hours(1)))));
elseif dur >= minutes(1)
    string_out = sprintf('%d min, %d sec', ...
        floor(dur/minutes(1)), ...
        ceil(seconds(mod(dur,minutes(1)))));
else
    string_out = sprintf('%d sec', ...
        ceil(dur/seconds(1)));
end
string_out = string(string_out);
end

function time_info = get_time_info_string_gui(obj)
elapsed = datetime() - obj.start_time;
remain = elapsed/obj.ratio - elapsed;
time_info = "Elapsed time: " + duration2string(elapsed) + ...
    newline() + "Time remaining: " + duration2string(remain);
end