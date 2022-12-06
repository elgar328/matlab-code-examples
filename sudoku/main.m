%% sudoku solver

clear; clc;
cd(fileparts(matlab.desktop.editor.getActiveFilename));

% Sudoku with 17 numbers
T = [0 0 7 5 0 0 2 0 0;
     0 4 1 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0;
     5 0 0 0 0 1 0 0 0;
     3 0 0 0 0 0 8 0 0;
     0 0 0 4 7 0 0 0 0;
     0 0 0 6 8 0 0 0 3;
     0 3 0 0 0 0 0 1 0;
     0 0 0 2 0 0 0 0 0];

fprintf('Sudoku with 17 numbers\n')
disp_sudoku(T)

sol = sudoku_solver(T,2);
fprintf('\nSolution\n')
disp_sudoku(sol)

%% Solve 1465 hardest sudokus

clear; clc;
cd(fileparts(matlab.desktop.editor.getActiveFilename));

tic

% Magic tour, 1465 hardest sudokus sorted by rating
% http://magictour.free.fr/sudoku.htm
f_quiz = fopen('top1465.txt');
f_sol = fopen('solution.txt','w');

num = 0;
while ~feof(f_quiz)
    num = num + 1;

    % quiz string to matrix
    quiz = fgetl(f_quiz);
    quiz(quiz=='.') = '0';
    quiz = reshape(str2num(quiz')',[9,9]);
    
    % solve, display
    sol = sudoku_solver(quiz);
    fprintf('\nQuiz %d\n',num)
    disp_sudoku(sol)

    % file output
    sol = num2str(reshape(sol',[],1))';
    fprintf(f_sol,'%s\n',sol);
end

fclose(f_quiz);
fclose(f_sol);

toc

%% sudoku generator

clear; clc;
cd(fileparts(matlab.desktop.editor.getActiveFilename));

clue_num = 26;

tic
T = sudoku_generator(clue_num);

fprintf('clues  : %d\nblanks : %d\n',clue_num,81-clue_num)
disp_sudoku(T)
toc