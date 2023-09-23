
%% Slow loop

n = 0;
while loopControl
    
    n = n+1;
    fprintf('n: %d\n',n)
    pause(5)
end
disp('Escaped the loop.')

%% Fast loop

n = 0;
while loopControl
    
    n = n+1;
    fprintf('n: %d\n',n)
end
disp('Escaped the loop.')
