pkg load statistics
warning ("off");
t0 = clock (); 

qtd_itr=200000                          ###### preencher ######
pesos_aux = {'pp', 'pr', 'pi'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######

for alias_num = 1:length(alias_aux)
  for pesos_num = 1:length(pesos_aux)

mfilename ()
rand("state",[52]);randn("state",[52]); 
pesos = pesos_aux{pesos_num}
alias = alias_aux{alias_num}

[A, dp, MVC, P, U, m, n] = get_network(alias);

P = diag(1./diag(MVC));     ####### para nao considerar covariancias
if pesos == "pr"
  P = chol(P); end
if pesos == "pi"
  P = eye(m); end
  
aux = (mvnrnd(zeros(m,1),MVC,qtd_itr));
er = aux';

I = eye(m);
O = zeros(m,2*n);
A1 = [A -A -I I zeros(m,1)];
A2 = [O P -P (-1)*ones(m,1)];
A3 = [O -P P (-1)*ones(m,1)];
A = cat(1,A1, A2, A3);
c=zeros(1,2*(n+m)+1);c(1,2*(n+m)+1)=1;
ctype1 = repmat("S",1,m);
ctype2 = repmat("U",1,2*m);
ctype = cat(2,ctype1,ctype2);
vartype = repmat("C",1,2*(n+m)+1);

vAll = [];

for q=1:qtd_itr
e=cat(1,er(:,q),zeros(2*m,1));
[xopt, fopt, erro, extra] = glpk (c, A, e, lb=[], ub=[], ctype, vartype);
v = xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m);
vAll=[vAll v];
end

Ev_SMC = cov(vAll')
DPvv=sqrt(diag(Ev_SMC))

filename=sprintf("Ev_SMC_LInf_%s_%s_%ditr", pesos, alias, qtd_itr);
save ("-ascii", filename, "Ev_SMC");
tempo = etime (clock (), t0)/60
#vAll
#vAll.*diag(P)
endfor endfor