function T = sudoku_generator(clue_num)
arguments
    clue_num (1,1) double {mustBeInteger,mustBeInRange(clue_num,20,81)}
end

rndblk = @() reshape(randperm(9),3,3);
while true
    % random solved sudoku
    while true
        T = blkdiag(rndblk(),rndblk(),rndblk());
        rndele = @(in) in(randi(length(in)));
        T(1,end) = rndele(setdiff(1:9,[T(1,:),T(:,end)']));
        T(2,end) = rndele(setdiff(1:9,[T(2,:),T(:,end)']));
        T(3,end) = rndele(setdiff(1:9,[T(3,:),T(:,end)']));
        sol = sudoku_solver(T,100);
        if ~isempty(sol)
            break
        end
    end
    sol = sol(:,:,randi(size(sol,3)));

    lim30 = tic;
    while true
        T = sol;
        T(randperm(9^2,81-clue_num)) = 0;
        sol_tmp = sudoku_solver(T,2);
        if size(sol_tmp,3)==1 && ~isempty(sol_tmp)
            unique_sol = true;
            break
        end
        if toc(lim30) > 30
            unique_sol = false;
            break
        end
    end
    if unique_sol
        break
    end
end