function [A, dp, MVC, P, U, m, n] = get_network(alias)

if alias == "06obs-IP1"
A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];
d=[42 38 27 22 23 33]';
endif

if alias == "10obs-IP1"
A=[1 0 0 0
1 -1 0 0
0 1 -1 0
0 0 1 -1
0 0 0 1
0 1 0 0
0 0 1 0
1 0 0 -1
1 0 -1 0
0 1 0 -1];
d=[37 28 33 26 40 32 39 29 34 41]';
endif

if alias == "15obs-IP1"
A=[1 0 0 0 0
-1 1 0 0 0
0 -1 1 0 0
0 0 -1 1 0
0 0 0 -1 1
0 0 0 0 -1
0 1 0 0 0
0 0 1 0 0
0 0 0 1 0
0 1 0 0 -1
0 0 1 0 -1
1 0 0 0 -1
1 0 0 -1 0
1 0 -1 0 0
0 1 0 -1 0];
d=[30 34 25 37 28 38 29 35 31 26 33 36 27 32 24]';
endif


[m n]=size(A);
dp=1.0.*sqrt(d);
var = dp.^2; 
MVC = diag(var);
P = inv(MVC);
U = chol(MVC);
endfunction