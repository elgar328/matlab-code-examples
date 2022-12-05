function disp_sudoku(T)
assert(size(T,3) == 1, 'Several solutions exist.')
T = num2str(T);
wall = repmat('|',[9,1]);
T = [T(:,1:8), wall, T(:,9:17), wall, T(:,18:25)];
wall = repmat('-',[1,27]);
T = [T(1:3,:); wall; T(4:6,:); wall; T(7:9,:)];
T(T=='0') = ' ';
T([4,8],[9,19]) = '+';
disp(T)