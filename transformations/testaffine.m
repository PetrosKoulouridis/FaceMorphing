%case 1: identical matrices are mapped through the identity matrix (or its
%approximation)
TrA = [rand([2, 3]);[1 1 1]];
TrB = TrA;
M = computeaffine(TrA, TrB);
Tmapped = applyaffine(M, TrA);
disp(table(M, 'VariableNames',{'M'}));
disp(table(TrA, TrB, Tmapped, 'VariableNames',{'TrA','TrB','M*TrA'}));

%case 2: translation of points is accurately mapped by a translation matrix
TrB = TrA(1:2,:) + [5 ; 4];
TrB = [TrB ; [1 1 1]];
M = computeaffine(TrA, TrB);
Tmapped = applyaffine(M, TrA);
disp(table(M, 'VariableNames',{'M'}));
disp(table(TrA, TrB, Tmapped, 'VariableNames',{'TrA','TrB','M*TrA'}));