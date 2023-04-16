% ProgressBar_gui - Handy waitbar with time information
%
%     USAGE
%     |   task_name = 'Task name';
%     |   
%     |   PB = ProgressBar_gui;
%     |   % or PB = ProgressBar_gui(task_name);
%     |   for ii = 1:10
%     |       pause(0.5)
%     |       PB.update(ii/10)
%     |   end
%     |   
%     |   PB = ProgressBar_gui;
%     |   for ii = 1:5
%     |       pause(1)
%     |       PB.update_task_name(['Task (',num2str(ii),'/5)'])
%     |       PB.update(ii/5)
%     |   end
%
%     created 2023. 04. 13.
%     author  Cho HyunGwang
% 
%     https://github.com/elgar328/matlab-code-examples/tree/main/tools/ProgressBar

classdef ProgressBar_gui < handle
    % ---------------------------- properties -----------------------------
    properties (SetAccess = private)
        task_name
        start_time
        end_time
    end
    properties (SetAccess = private, Hidden = true)
        time_info = "";
        ratio = 0;
        int_percent = 0;
    end
    properties (SetAccess = immutable, Hidden = true)
        fig_handle
        ratio_resol = 0.001;
    end

    methods
        % -------------------------- Constructor --------------------------
        function obj = ProgressBar_gui(task_name)
            arguments
                task_name (1,:) char {mustBeText} = '';
            end
            obj.start_time = datetime();
            obj.task_name = task_name;
            obj.fig_handle = waitbar(0, '', 'Name', ...
                sprintf('%d%%  %s',obj.int_percent, obj.task_name));
            obj.fig_handle.Children.Title.FontSize = 13;
            waitbar(0, obj.fig_handle, get_time_info_string_gui(obj));
        end

        % ---------------------------- Updater ----------------------------
        function update(obj,ratio)
            arguments
                obj
                ratio (1,1) double {mustBeNonnegative,mustBeFinite,mustBeReal}
            end
            assert(ratio <= 1, 'The input argument, ratio, cannot exceed 1!')

            if obj.int_percent ~= floor(ratio*100)
                obj.int_percent = floor(ratio*100);
                obj.fig_handle.Name = ...
                    sprintf('%d%%  %s',obj.int_percent, obj.task_name);
            end
            if obj.ratio + obj.ratio_resol <= ratio
                obj.ratio = ratio;
                waitbar(obj.ratio, obj.fig_handle)
            end
            new_time_info = get_time_info_string_gui(obj);
            if ~strcmp(obj.time_info, new_time_info)
                obj.time_info = new_time_info;
                waitbar(obj.ratio, obj.fig_handle, obj.time_info)
            end

            if obj.ratio == 1
                obj.delete
            end
        end

        function update_task_name(obj, task_name)
            arguments
                obj
                task_name (1,:) char {mustBeText} = '';
            end
            obj.task_name = task_name;
            obj.fig_handle.Name = ...
                sprintf('%d%%  %s',obj.int_percent, obj.task_name);
        end
        
        % -------------------------- Destructor ---------------------------
        function delete(obj)
            elapsed = datetime() - obj.start_time;
            if isempty(obj.task_name)
                fprintf('Elapsed time: %s\n', ...
                    duration2string(elapsed))
            else
                fprintf('%s, elapsed time: %s\n', ...
                    obj.task_name, duration2string(elapsed))
            end
            delete(obj.fig_handle);
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