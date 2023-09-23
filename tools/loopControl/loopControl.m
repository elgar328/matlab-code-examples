% loopControl
%
%     Creates a dialog box that allows you to pause or break 
%     from an infinite while loop.
%
%     USAGE
%     |   n = 0;
%     |   while loopControl
%     |   
%     |       n = n+1
%     |       pause(5)
%     |   end
%     |   disp('Escaped the loop.')
%
%
%     created 2023. 09. 23.
%     edited  2023. 09. 23.
%     author  Cho HyunGwang

function out = loopControl()

persistent dlg pause_btn dlg_text stoped paused start_time paused_dur updater

if isempty(dlg)
    pause_btn = [];
    dlg_text = [];
    dlg = make_dialog();
    drawnow();
    stoped = false;
    paused = false;
    start_time = datetime();
    paused_dur = duration([0 0 0]);
    updater = timer('TimerFcn',@update_elapsed_time, ...
        'StartDelay',0.5,'Period',0.5,'ExecutionMode','fixedRate');
    updater.start();
end

pause_loop();

if stoped
    out = false;
    delete(dlg)
    clear dlg pause_btn dlg_text stoped paused start_time paused_dur updater
else
    out = true;
end

% ---------------------------- Nested function ----------------------------
    function dlg = make_dialog()
        dlg = dialog ('Name', 'Loop control', 'WindowStyle', 'normal');
        dlg.Units = 'characters';
        dlg.Position (3:4) = [50, 7];
        dlg.CloseRequestFcn = @break_callback;

        ah = axes('Parent',dlg, ...
            'Units','normalized', ...
            'Position',[0,0.45,1,0.55], ...
            'Visible','off');
        dlg_text = text('Parent',ah, ...
            'Position',[0.5,0.5,0], ...
            'FontSize', 14, ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'String',"Elapsed: 0 sec");
        uicontrol('Parent',dlg, ...
            'Units','normalized', ...
            'Position',[0.12 0.1 0.32 0.35], ...
            'String','Break', ...
            'FontSize',14, ...
            'Callback',@break_callback);
        pause_btn = uicontrol('Parent',dlg, ...
            'Units','normalized', ...
            'Position',[0.56 0.1 0.32 0.35], ...
            'String','Pause', ...
            'FontSize',14, ...
            'Callback',@pause_callback);
    end

    function break_callback(~,~)
        stoped = true;
        updater.stop();
        dlg_text.String = 'Escaping the loop';
    end

    function pause_callback(~,~)
        if paused
            paused = false;
            pause_btn.String = 'Pause';
        else
            paused = true;
            pause_btn.String = 'Restart';
            dlg_text.String = 'Waiting for pause';
        end
    end

    function update_elapsed_time(~,~)
        if paused
            return
        end
        dlg_text.String = "Elapsed: " + ...
            duration2string((datetime() - start_time) - paused_dur);
        drawnow()
    end

    function pause_loop()
        entered_pause = false;
        pause_tic = datetime();
        while paused && ~stoped
            entered_pause = true;
            dlg_text.String = 'Paused';
            pause(0.2)
        end
        if entered_pause
            paused_dur = paused_dur + (datetime() - pause_tic);
        end
    end
end

% ---------------------------- Local function -----------------------------
function string_out = duration2string(dur)
if isinf(dur)
    string_out = "Inf";
    return
end
if dur >= days(1)
    string_out = sprintf('%d day, %d hour', ...
        floor(dur/days(1)), floor(hours(mod(dur,days(1)))));
elseif dur >= hours(1)
    string_out = sprintf('%d hour, %d min', ...
        floor(dur/hours(1)), floor(minutes(mod(dur,hours(1)))));
elseif dur >= minutes(1)
    string_out = sprintf('%d min, %d sec', ...
        floor(dur/minutes(1)), floor(seconds(mod(dur,minutes(1)))));
else
    string_out = sprintf('%d sec', floor(dur/seconds(1)));
end
string_out = string(string_out);
end