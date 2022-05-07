% WaitBar - [Class] Handy waitbar with time remaining.
% 
%     USAGE
%     |   final_value = 5;
%     |   display_name = 'Progress ................'
%     |
%     |   WB = WaitBar(final_value);    
%     |   % or WB = WaitBar(final_value, display_name);
%     |   
%     |   for ii=1:final_value
%     |       pause(1); 
%     |
%     |       WB.insideLoop(ii);
%     |   end
%     |   clear WB;
% 
%     created 2020. 07. 01.
%     author : Cho HyunGwang
% 
classdef WaitBar < handle
    properties (SetAccess = immutable, Hidden = true)
        finalValue
        figHandle
    end
    
    properties (SetAccess = private, Hidden = true)
        dispProgress = 0;
        dispProgressResol = 0.01;
    end
    
    methods
        % -------------------- Constructor --------------------
        function this = WaitBar(finalValue, varargin)
            validateattributes(finalValue,{'numeric'},{'scalar',...
                'positive','integer','finite','nonnan'},'WaitBar','finalValue',1);
            this.finalValue = finalValue;
            
            if (~isempty(varargin)) && ischar(varargin{1})
                this.figHandle = waitbar(0,'','Name',varargin{1});
            else
                this.figHandle = waitbar(0,'','Name','Progress');
            end
            tic;
        end
        
        % ----------------- Public Functions -----------------
        function insideLoop(this,countingNumber)
            if this.dispProgress < countingNumber/this.finalValue
                this.dispProgress = this.dispProgress + this.dispProgressResol;
                waitbar_str = sprintf('%s\n%s',['Time Elapsed: ',datestr(toc/86400,'HH:MM:SS')],...
                    ['Time Remaining: ',datestr((toc*(this.finalValue-countingNumber)/countingNumber)/86400,'HH:MM:SS')]);
                waitbar(countingNumber/this.finalValue,this.figHandle,waitbar_str)
            end
        end
        
        % -------------------- Destructor --------------------
        function delete(this)
            disp(['Elapsed time : ', datestr(toc/86400,'HH:MM:SS.FFF')])
            close(this.figHandle);
            drawnow;
        end
    end
end