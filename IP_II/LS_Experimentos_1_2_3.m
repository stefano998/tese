## Experiment 4
pkg load statistics
pkg load optim

"LS in experiment 1"
rand("state",[1]);randn("state",[1]);

A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];

[m n]=size(A);

qtd_itr = 200000
experiment = 1  

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

xpall=[]; xPobjall=[]; 

mediasL = [10; 0; 0; -10; -10; 0];
aux=(mvnrnd(mediasL,MVC,qtd_itr));
er=aux';  
size(er);

## LS(Pd) ##  
p = 1./diag(MVC);
P = diag(p);
xp = inv(A'*P*A)*A'*P*er;
xpall=[xpall; xp'];

## LS(P) ##  
P = inv(MVC);
xPobj = inv(A'*P*A)*A'*P*er;
xPobjall=[xPobjall; xPobj'];

xPobjm = mean(xPobjall)
xpm = mean(xpall) 

"---------------------------------------------------------------------"
"LS in experiment 2"
rand("state",[1]);randn("state",[1]);

A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];

[m n]=size(A);

qtd_itr = 200000
experiment = 2  

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

xpall=[]; xPobjall=[]; 

mediasL = [10; 0; 0; -10; -10; 0];
aux=(mvnrnd(mediasL,MVC,qtd_itr));
er=aux';  
size(er);

## LS(Pd) ##  
p = 1./diag(MVC);
P = diag(p);
xp = inv(A'*P*A)*A'*P*er;
xpall=[xpall; xp'];

## LS(P) ##  
P = inv(MVC);
xPobj = inv(A'*P*A)*A'*P*er;
xPobjall=[xPobjall; xPobj'];

xPobjm = mean(xPobjall)
xpm = mean(xpall) 

"---------------------------------------------------------------------"
"LS in experiment 3"
rand("state",[1]);randn("state",[1]);

A=[1 0 0;-1 1 0;0 -1 1;0 0 -1; 0 -1 0; -1 0 1];

[m n]=size(A);

qtd_itr = 200000
experiment = 3  

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

xpall=[]; xPobjall=[]; 

mediasL = [10; 0; 0; -10; -10; 0];
aux=(mvnrnd(mediasL,MVC,qtd_itr));
er=aux';  
size(er);

## LS(Pd) ##  
p = 1./diag(MVC);
P = diag(p);
xp = inv(A'*P*A)*A'*P*er;
xpall=[xpall; xp'];

## LS(P) ##  
P = inv(MVC);
xPobj = inv(A'*P*A)*A'*P*er;
xPobjall=[xPobjall; xPobj'];

xPobjm = mean(xPobjall)
xpm = mean(xpall) 

