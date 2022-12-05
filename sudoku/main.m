
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