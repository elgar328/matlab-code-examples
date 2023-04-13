% ProgressBar_cli - Text based progress bar
%
%     USAGE
%     |   task_name = 'Task name';
%     |   terminal_width = 50;
%     |   
%     |   PB = ProgressBar_cli;
%     |   % or PB = ProgressBar(task_name);
%     |   % or PB = ProgressBar(task_name, terminal_width);
%     |   for ii = 1:10
%     |       pause(0.1)
%     |       PB.update(ii/10)
%     |   end
%     |   
%     |   PB = ProgressBar_cli(task_name);
%     |   for ii = 1:6
%     |       pause(0.1)
%     |       PB.update(ii/10)
%     |   end
%     |   PB.terminate
%     |   
%     |   PB = ProgressBar_cli;
%     |   for ii = 1:5
%     |       pause(1)
%     |       PB.update_task_name(['Task (',num2str(ii),'/5)'])
%     |       PB.update(ii/5)
%     |   end
%
%     COMMAND WINDOW OUTPUT
%     |███████████████████████████████ 2 sec ███████████████████████████████|100%
%     Task name | 1 sec ████████████████████████████              TERMINATED| 60%
%     Task (5/5) |█████████████████████████ 6 sec ██████████████████████████|100%
%
%
%     created 2022. 11. 27.
%     updated 2023. 04. 13.
%     author : Cho HyunGwang

% Note for custom character set
%   char_set{1}↓↓char_set{4}    ↓char_set{2}    ↓char_set{3}  ↓char_set{4}
% downloading.. |██████████████████████████████               | 80%
% downloading.. |██████████████████████████████---------------| 80%
% downloading.. |██████████████████████████████•••••••••••••••| 80%
% downloading.. |==============================•••••••••••••••| 80%
% downloading.. |==============================               | 80%
% downloading.. |******************************               | 80%
% downloading.. |##############################...............| 80%
% 0        1         2         3         4         5         6         7
% 123456789012345678901234567890123456789012345678901234567890123456789012345

classdef ProgressBar_cli < handle
    % ---------------------------- properties -----------------------------
    properties (SetAccess = private)
        task_name
        start_time
        end_time
    end
    properties (SetAccess = private, Hidden = true)
        time_info = "";
        is_terminated = false;
        ratio = 0;
        bar_n = 0;
        int_percent = 0;
        char_set = {' ','█',' ','|'}; % <-------------------- Character set
    end
    properties (SetAccess = immutable, Hidden = true)
        terminal_width
        minimal_terminal_width = 20;
    end

    methods
        % -------------------------- Constructor --------------------------
        function obj = ProgressBar_cli(task_name, terminal_width)
            arguments
                task_name (1,:) char {mustBeText} = '';
                terminal_width (1,1) {mustBePositive,mustBeFinite, ...
                                      mustBeReal,mustBeInteger} = 75
            end

            assert(terminal_width >= obj.minimal_terminal_width, ...
                'Terminal width must be greater than or equal to 20!')
            obj.terminal_width = terminal_width;

            obj.task_name = validate_task_name(obj, task_name);
            obj.start_time = datetime();
            
            update_cli("", true, true);
            print_progressbar(obj);
        end
        
        % ---------------------------- Updater ----------------------------
        function update(obj,ratio)
            arguments
                obj
                ratio (1,1) double {mustBeNonnegative,mustBeFinite,mustBeReal}
            end
            assert(ratio <= 1, 'The input argument, ratio, cannot exceed 1!')
            assert(~obj.is_terminated, 'This task has already been terminated!')
            assert(obj.int_percent ~= 100, 'This task has already been finished!')

            obj.ratio = ratio;
            outdated = false;
            if obj.bar_n ~= floor(get_bar_max(obj)*ratio)
                obj.bar_n = floor(get_bar_max(obj)*ratio);
                outdated = true;
            end
            if obj.int_percent ~= floor(ratio*100)
                obj.int_percent = floor(ratio*100);
                outdated = true;
                if obj.int_percent == 100
                    obj.end_time = datetime();
                end
            end
            new_time_info = get_time_info_string_cli(obj);
            if ~strcmp(obj.time_info, new_time_info)
                obj.time_info = new_time_info;
                outdated = true;
            end

            if outdated
                print_progressbar(obj);
            end
        end

        function update_task_name(obj, task_name)
            arguments
                obj
                task_name (1,:) char {mustBeText} = '';
            end

            obj.task_name = validate_task_name(obj, task_name);
            print_progressbar(obj);
        end

        % --------------------------- Terminator --------------------------
        function terminate(obj)
            assert(~obj.is_terminated, 'This task has already been terminated!')
            assert(obj.int_percent ~= 100, 'This task has already been finished!')
            
            obj.end_time = datetime();
            obj.is_terminated = true;
            obj.time_info = get_time_info_string_cli(obj);
            print_progressbar(obj)
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

function bar_max = get_bar_max(obj)
bar_max = obj.terminal_width -4 -2*length(obj.char_set{4});
if ~isempty(obj.task_name)
    bar_max = bar_max -length(obj.char_set{1}) ...
        -length(obj.task_name);
end
end

function time_info = get_time_info_string_cli(obj)
if obj.is_terminated || obj.int_percent == 100
    time_info = "Elapsed time: " ...
        + duration2string(datetime() - obj.start_time);
else
    elapsed = datetime() - obj.start_time;
    remain = elapsed/obj.ratio - elapsed;
    time_info = "Time remaining: " ...
        + duration2string(remain);
end
end

function print_progressbar(obj)

if isempty(obj.task_name)
    name_string = "";
else
    name_string = string([obj.task_name, obj.char_set{1}]);
end
bar_bound_string = string(obj.char_set{4});
percent_string = string(sprintf('%3d%%', obj.int_percent));
% Bar text
bar_string = [repmat(obj.char_set{2},[1,obj.bar_n]), ...
    repmat(obj.char_set{3},[1,get_bar_max(obj)-obj.bar_n])];
if obj.int_percent == 100 || obj.is_terminated
    % finished
    end_flag = true;
    time_info_char = [' ', ...
        convertStringsToChars(...
        extractAfter(obj.time_info,"Elapsed time: ")), ' '];
    time_info_len = length(time_info_char);

    if obj.int_percent == 100 ...
            && time_info_len + 2 <= length(bar_string)
        head_ind = floor((length(bar_string)-time_info_len)/2)+1;
        tail_ind = head_ind + time_info_len -1;
        bar_string(head_ind:tail_ind) = time_info_char;
        second_line = "";
    elseif obj.int_percent == 100
        second_line = obj.time_info + newline;
    elseif obj.is_terminated ...
            && time_info_len + 12 <= length(bar_string)
        bar_string(1:time_info_len) = time_info_char;
        bar_string(end-9:end) = 'TERMINATED';
        second_line = "";
    elseif obj.is_terminated
        bar_string(end-9:end) = 'TERMINATED';
        second_line = obj.time_info + newline;
    end
else
    % on progress
    end_flag = false;
    second_line = obj.time_info + newline;
end
bar_string = string(bar_string);

first_line = ...
    name_string ...
    + bar_bound_string ...
    + bar_string ...
    + bar_bound_string ...
    + percent_string ...
    + newline;

if obj.is_terminated                     % red
    formatted_string = ...
        ["", first_line, second_line];
else                                     % black
    formatted_string = ...
        first_line + second_line;
end

% print out
update_cli(formatted_string, end_flag);
end

function update_cli(string_vec, lock_msg, lock_prev_msg)
% string_vec(1) -> std out    (black)
% string_vec(2) -> std error  (red)
% string_vec(3) -> std out    (black)
% string_vec(4) -> std error  (red)
% ...
% Not escaping at \, ', % 

arguments
    string_vec (1,:) string {mustBeText}
    lock_msg (1,1) logical = false
    lock_prev_msg (1,1) logical = false
end

persistent previous_msg_length
if isempty(previous_msg_length)
    previous_msg_length = 0;
end

if lock_prev_msg
    previous_msg_length = 0;
end

backspace_chain = string(repmat(sprintf('\b'),[1,previous_msg_length]));
previous_msg_length = sum(strlength(string_vec));

string_vec(1) = backspace_chain + string_vec(1);

fileid = 1;
for n=1:length(string_vec)
    msg = string_vec(n);
    msg = strrep(msg, '%', '%%');
    msg = strrep(msg, '\', '\\');
    msg = strrep(msg, "'", "''");

    fprintf(fileid, msg);

    if fileid == 1
        fileid = 2;
    else
        fileid = 1;
    end
end

if lock_msg
    previous_msg_length = 0;
end
end

function task_name = validate_task_name(obj, task_name)
assert(length(task_name) < obj.terminal_width - obj.minimal_terminal_width, ...
    sprintf(['Length of the task name must be less than %d!\n', ...
    'Otherwise, use a larger terminal width.'], ...
    obj.terminal_width - obj.minimal_terminal_width))
end