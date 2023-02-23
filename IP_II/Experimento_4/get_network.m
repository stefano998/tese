function [A, dp, MVC, P, U, m, n] = get_network(alias, experiment)

if alias == "6obserip2"
pkg load statistics
pkg load optim
rand("state",[1]);randn("state",[1]);

A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];

[m n]=size(A);

aux = rand(m,m);
if experiment == 3
MVC =  5-10*aux;endif 
  
if experiment == 2
MVC =  1-2*aux;endif


for i=2:m
  for j=1:(i-1)
  MVC(j,i)=MVC(i,j); end end 
  
  
for i=1:m
  MVC(i,i)=5+2.5*i; 
end 

if experiment == 1 
MVC =  zeros(m,m); 
for i=1:m
  MVC(i,i)=5+2.5*i;end 
endif
endif



#############################################################################
dp=sqrt(diag(MVC))';
[m n]=size(A);
P = inv(MVC);
U = chol(P);
endfunction