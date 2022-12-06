% SUDOKU_SOLVER
%
%     Sudoku puzzles are treated as an Exact Cover Problem, and
%     Knuth's Algorithm X is used to solve it.
%
%     USAGE
%     |   T = [0 9 6 0 4 0 0 3 0;
%     |        0 5 7 8 2 0 0 0 0;
%     |        1 0 0 9 0 0 5 0 0;
%     |        0 0 9 0 1 0 0 0 8;
%     |        5 0 0 0 0 0 0 0 2;
%     |        4 0 0 0 9 0 6 0 0;
%     |        0 0 4 0 0 3 0 0 1;
%     |        0 0 0 0 7 9 2 6 0;
%     |        0 2 0 0 5 0 9 8 0];
%     |
%     |   sol = SUDOKU_SOLVER(T);
%     |
%     |   % sol (9x9 matrix)   : Unique solution
%     |   % sol (9x9xN matrix) : N solutions
%     |   % sol (empty matrix) : No solution
%
%     created 2022. 12. 05.
%     author : Cho HyunGwang
%

function sol = sudoku_solver(T, max_sol_num)
arguments
    T (9,9) double {mustBeInteger,mustBeInRange(T,0,9)}
    max_sol_num (1,1) double {mustBeInteger,mustBePositive} = 100
end
assert(validate_table(T),'Invalid sudoku board!')

sudoku = exactCoverMatrix(T);
sudoku.max_sol_num = max_sol_num;

sol = algorithmX(sudoku);

if ~isempty(sol)
    for n = 1:size(sol,3)
        assert(validate_table(sol(:,:,n)),'Invalid solution!')
    end
end
end

function out = validate_table(T)
vec = @(in) in(:);
non_zero = @(in) in(vec(in)~=0);
check = @(in) length(non_zero(in)) == length(unique(non_zero(in)));
b_ind = {1:3, 4:6, 7:9};
for ii = 1:3
    for jj = 1:3
        if false == check(T(b_ind{ii},b_ind{jj}))
            out = false;
            return
        end
    end
end
for row = 1:9
    if false == check(T(row,:))
        out = false;
        return
    end
end
for col = 1:9
    if false == check(T(:,col))
        out = false;
        return
    end
end
out = true;
end

% Exact cover matrix for sudoku
% https://www.stolaf.edu/people/hansonr/sudoku/exactcovermatrix.htm
function sudoku = exactCoverMatrix(T)
rowColNum = [reshape(repmat(1:9,[9^2,1]),[],1), ...     % row
    repmat(reshape(repmat(1:9,[9,1]),[],1),[9,1]), ...  % column
    repmat((1:9)',[9^2,1])];                            % number
% memory preallocation
ecMatrix = zeros(9^3,4*9^2);
% cell constraints (only one of value in each of 81 cells)
for n = 1:9^2
    ecMatrix(9*(n-1)+(1:9),n) = ones(9,1);
end
% row constraints (only one of 1-9 in each of 9 rows)
for n = 1:9^2
    ecMatrix(9*(n-1)+(1:9), 9^2+floor((n-1)/9)*9+(1:9)) = eye(9);
end
% column constraints (only one of 1-9 in each of 9 columns)
for n = 1:9
    ecMatrix((n-1)*9^2+(1:9^2), 2*9^2+(1:9^2)) = eye(9^2);
end
% block constraints (only one of 1-9 in each of 9 blocks)
tmp_a = repmat(eye(9),[3,1]);
tmp_b = repmat(blkdiag(tmp_a,tmp_a,tmp_a),[3,1]);
ecMatrix(:,3*9^2+1:end) = blkdiag(tmp_b,tmp_b,tmp_b);

sudoku.ecMatrix = logical(ecMatrix);
sudoku.rowColNum = rowColNum;
sudoku.sol = T;

[row,col] = find(sudoku.sol ~= 0);
for n = 1:length(row)
    sudoku = reduceMatrix(sudoku,row(n),col(n),T(row(n),col(n)));
end
end

% Knuth's Algorithm X
% https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X
function sol = algorithmX(sudoku)
% STEP-1
if isempty(sudoku.ecMatrix)
    if any(sudoku.sol==0,'all')   % Failure
        sol = [];
        return
    else                          % Solution
        sol = sudoku.sol;
        return
    end
end
% STEP-2
col_sum = sum(sudoku.ecMatrix,1);
col = find(col_sum == min(col_sum(col_sum>0)),1);
% STEP-3
row_candidates = find(sudoku.ecMatrix(:,col));

sol = [];
for n = 1:length(row_candidates)
    % STEP-4
    row = sudoku.rowColNum(row_candidates(n),1);
    col = sudoku.rowColNum(row_candidates(n),2);
    num = sudoku.rowColNum(row_candidates(n),3);
    sudoku_branch = sudoku;
    sudoku_branch.sol(row,col) = num;
    % STEP-5
    sudoku_branch = reduceMatrix(sudoku_branch,row,col,num);
    sol_branch = algorithmX(sudoku_branch);
    if ~isempty(sol_branch)
        sol = cat(3,sol, sol_branch);
    end
    if size(sol,3) >= sudoku.max_sol_num
        break
    end
end
end

function sudoku = reduceMatrix(sudoku,row,col,num)
rowInd = find(sudoku.rowColNum(:,1)==row & ...
               sudoku.rowColNum(:,2)==col & ...
               sudoku.rowColNum(:,3)==num);
col_ind = find(sudoku.ecMatrix(rowInd,:));
for n = 1:length(col_ind)
    rows_to_remove = sudoku.ecMatrix(:,col_ind(n));
    sudoku.ecMatrix(rows_to_remove,:) = [];
    sudoku.rowColNum(rows_to_remove,:) = [];
end
sudoku.ecMatrix(:,col_ind) = [];
end