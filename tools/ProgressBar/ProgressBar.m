% ProgressBar - [Class] Terminal progress bar.
%
%     USAGE
%     |   task_name = 'downloading..';
%     |   terminal_width = 50;
%     |   
%     |   PB = ProgressBar;
%     |   % or PB = ProgressBar(task_name);
%     |   % or PB = ProgressBar(task_name, terminal_width);
%     |   for ii = 1:10
%     |       pause(0.1)
%     |       PB.update(ii/10)
%     |   end
%     |
%     |   PB = ProgressBar(task_name);
%     |   for ii = 1:6
%     |       pause(0.1)
%     |       PB.update(ii/10)
%     |   end
%     |   PB.terminate
%     |   
%     |   PB = ProgressBar;
%     |   for ii = 1:5
%     |       pause(1)
%     |       PB.update_task_name(['Task (',num2str(ii),'/5)'])
%     |       PB.update(ii/5)
%     |   end
%
%     COMMAND WINDOW OUTPUT
%     |█████████████████████████████████████████████████████████████████████|100%
%     downloading.. |█████████████████████████████████            TERMINATED| 60%
%     Task (5/5) |██████████████████████████████████████████████████████████|100%
%
%
%     created 2022. 11. 27.
%     updated 2022. 11. 29.
%     author : Cho HyunGwang
%

% Note for custom character set
% downloading.. |██████████████████████████████               | 80%
% downloading.. |██████████████████████████████---------------| 80%
% downloading.. |██████████████████████████████•••••••••••••••| 80%
% downloading.. |==============================•••••••••••••••| 80%
% downloading.. |==============================               | 80%
% downloading.. |******************************               | 80%
% downloading.. |##############################...............| 80%
% 0        1         2         3         4         5         6         7
% 123456789012345678901234567890123456789012345678901234567890123456789012345

classdef ProgressBar < handle
    properties (SetAccess = private)
        task_name
    end
    properties (SetAccess = private, Hidden = true)
        bar = 0;
        int_percent = 0;
        char_set = {' ','█',' ','|'}; % <------------------------ Character set
    end
    properties (SetAccess = immutable, Hidden = true)
        terminal_width
        minimal_terminal_width = 20;
    end
    properties (Dependent)
        bar_max
    end

    methods
        % -------------------------- Constructor --------------------------
        function obj = ProgressBar(task_name, terminal_width)
            arguments
                task_name (1,:) char {mustBeText} = '';
                terminal_width (1,1) {mustBePositive,mustBeFinite, ...
                    mustBeReal,mustBeInteger} = 75
            end

            assert(terminal_width >= obj.minimal_terminal_width, ...
                'Terminal width must be greater than or equal to 20!')
            obj.terminal_width = terminal_width;

            assert(length(task_name) < obj.terminal_width - ...
                obj.minimal_terminal_width, 'task name is too long!')
            obj.task_name = task_name;
            if isempty(task_name)
                obj.char_set{1} = '';
            end

            % obj.bar_max = obj.terminal_width - 7 - length(task_name);
            fprintf(repmat(' ',[1,obj.terminal_width]))
        end
        % ---------------------- Dependent property -----------------------
        function bar_max = get.bar_max(obj)
            bar_max = obj.terminal_width -length(obj.task_name) -4 ...
                -length(obj.char_set{1}) -2*length(obj.char_set{4});
        end
        % ---------------------------- Updater ----------------------------
        function update(obj,ratio)
            arguments
                obj
                ratio (1,1) double {mustBeNonnegative,mustBeFinite,mustBeReal}
            end
            assert(ratio <= 1, 'The input argument, ratio, cannot exceed 1!')
            if obj.bar ~= floor(obj.bar_max*ratio) || ...
                    obj.int_percent ~= floor(ratio*100)
                obj.bar = floor(obj.bar_max*ratio);
                obj.int_percent = floor(ratio*100);
                bar_text = [repmat(obj.char_set{2},[1,obj.bar]), ...
                    repmat(obj.char_set{3},[1,obj.bar_max-obj.bar])];

                fprintf([repmat('\b',[1,obj.terminal_width]),'%s%c%c%s%c%3d%%'], ...
                    obj.task_name, obj.char_set{1}, obj.char_set{4}, bar_text, ...
                    obj.char_set{4},obj.int_percent)
                if ratio == 1
                    fprintf('\n')
                end
            end
        end
        function update_task_name(obj,task_name)
            arguments
                obj
                task_name (1,:) char {mustBeText} = '';
            end
            assert(length(task_name) < obj.terminal_width - ...
                obj.minimal_terminal_width, 'task name is too long!')
            obj.task_name = task_name;
            if isempty(task_name)
                obj.char_set{1} = '';
            else
                obj.char_set{1} = ' ';
            end
        end
        % --------------------------- Terminator --------------------------
        function terminate(obj)
            bar_text = [repmat(obj.char_set{2},[1,obj.bar]), ...
                repmat(obj.char_set{3},[1,obj.bar_max-obj.bar])];
            bar_text(end-9:end) = 'TERMINATED';

            fprintf(repmat('\b',[1,obj.terminal_width]))
            fprintf(2,'%s%c%c%s%c%3d%%\n', ...
                obj.task_name, obj.char_set{1}, obj.char_set{4}, ...
                bar_text, obj.char_set{4},obj.int_percent)
        end
    end
end
