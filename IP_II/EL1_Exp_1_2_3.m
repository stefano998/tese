pkg load statistics
pkg load optim
rand("state",[1]);randn("state",[1]);
format long;
output_precision(6);

A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];

[m n]=size(A);

qtd_itr = 200000
experiment = 1  ########## change the number of the experiment here! 

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

MVC;
U = chol(MVC); 
P = inv(MVC);

xpall=[]; xPobjall=[]; xrPobjall=[]; xWobjall=[]; xcholall=[];

for i = 1:qtd_itr
mediasL = [10; 0; 0; -10; -10; 0];
aux=(mvnrnd(mediasL,MVC,1));
er=aux;   

## EL1(p) ##  
I=eye(m); 
p = 1./diag(MVC);
A1 = [A -A -I I];
c = cat(2,zeros(1,2*n),p',p');
ctype = repmat("S",1,m);
vartype = repmat("C",1,2*(n+m));
e=er; 
[xopt, fopt, erro, extra] = glpk (c, A1, e', lb=[], ub=[], ctype, vartype);
xp = xopt(1:n) - xopt(n+1:2*n);
xpall=[xpall; xp'];

## ELI(P) ##  
I=eye(m); 
obj = sum(P);  
cPobj = cat(2,zeros(1,2*n),obj, obj);
[xopt, fopt, erro, extra] = glpk (cPobj, A1, e', lb=[], ub=[], ctype, vartype);
xPobj = xopt(1:n) - xopt(n+1:2*n);
xPobjall=[xPobjall; xPobj'];

## EL1(sqrt(p)) ##  
I=eye(m); 
obj = sqrt(p);   
crPobj = cat(2,zeros(1,2*n),obj', obj');
[xopt, fopt, erro, extra] = glpk (crPobj, A1, e', lb=[], ub=[], ctype, vartype);
xrPobj = xopt(1:n) - xopt(n+1:2*n);
xrPobjall=[xrPobjall; xrPobj'];

## EL1(W) ##  
W=chol(P);
obj = sum(W);   
cWobj = cat(2,zeros(1,2*n),obj, obj);
[xopt, fopt, erro, extra] = glpk (cWobj, A1, e', lb=[], ub=[], ctype, vartype);
xWobj = xopt(1:n) - xopt(n+1:2*n);
xWobjall=[xWobjall; xWobj'];

##### decorrelation_LS########
W=chol(P);
Achol=W*A;  
pchol=ones(1,m);  
A1chol = [Achol -Achol -I I]; 
cchol = cat(2,zeros(1,2*n),pchol,pchol);
Lchol = W*e';
[xopt, fopt, erro, extra] = glpk (cchol, A1chol, Lchol, lb=[], ub=[], ctype, vartype);  
xchol = xopt(1:n) - xopt(n+1:2*n);
xcholall=[xcholall; xchol'];
endfor

xpm = mean(xpall);
xPobjm = mean(xPobjall);
xrPobj = mean(xrPobjall);
xWobj = mean(xWobjall);
xchol = mean(xcholall);

results = [xpm; xPobjm; xrPobj; xWobj; xchol]
