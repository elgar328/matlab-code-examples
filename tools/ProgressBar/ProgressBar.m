% ProgressBar - [Class] Terminal progress bar.
%
%     USAGE
%     |   process_name = 'downloading..'
%     |
%     |   PB = ProgressBar;    
%     |   % or PB = ProgressBar(process_name);
%     |   
%     |   for ii = 1:10
%     |       pause(1); 
%     |
%     |       PB.update(ii/10);
%     |   end
%
%     COMMAND WINDOW OUTPUT
%     downloading.. |██████████████████████████████                 | 80%
%
%
%     created 2022. 11. 27.
%     author : Cho HyunGwang
%

% Note for character set customize
% downloading.. |██████████████████████████████                   | 80%
% downloading.. |██████████████████████████████-------------------| 80%
% downloading.. |██████████████████████████████•••••••••••••••••••| 80%
% downloading.. |==============================•••••••••••••••••••| 80%
% 1234567890123456789012345678901234567890123456789012345678901234567890

classdef ProgressBar < handle
    properties
        process_name
    end
    properties (SetAccess = private)
        bar_max
        bar = 0;
        int_percent = 0;
    end
    properties (SetAccess = immutable, Hidden = true)
        terminal_width
        char_set = '█•|';
    end
    
    methods

        function obj = ProgressBar(process_name, terminal_width)
            arguments
                process_name (1,:) char {mustBeText} = '';
                terminal_width (1,1) {mustBePositive,mustBeFinite, ...
                                      mustBeReal,mustBeInteger} = 75
            end
            obj.terminal_width = terminal_width;
            assert(length(process_name) < obj.terminal_width - 12, ...
                'Process name is too long!')
            obj.process_name = process_name;
            obj.bar_max = obj.terminal_width - 7 - length(process_name);
        end
        
        function update(obj,ratio)
            arguments
                obj
                ratio (1,1) double {mustBeNonnegative,mustBeFinite,mustBeReal}
            end
            assert(ratio <= 1, 'ratio must be between 0 and 1!')
            if obj.bar ~= floor(obj.bar_max*ratio) || ...
                    obj.int_percent ~= floor(ratio*100)
                obj.bar = floor(obj.bar_max*ratio);
                obj.int_percent = floor(ratio*100);
                fprintf([repmat('\b',[1,obj.terminal_width]),'%s %c%s%s%c%3d%%'], ...
                    obj.process_name, obj.char_set(3), ...
                    repmat(obj.char_set(1),[1,obj.bar]), ...
                    repmat(obj.char_set(2),[1,obj.bar_max-obj.bar]), ...
                    obj.char_set(3),obj.int_percent)
                if ratio == 1
                    fprintf('\n')
                end
            end
        end

    end
end
