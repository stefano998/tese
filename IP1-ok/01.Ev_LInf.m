pkg load statistics
warning ("off");
t0 = clock (); 

rand("state",[0]);randn("state",[0]);
qtd_itr=200000                         ###### preencher ######
alias = "15obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, U, m, n] = get_network(alias);

aux = random("normal", 0, 1, [m, qtd_itr]);
er = U'*aux;

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

filename=strcat("Ev_SMC_LInf_", alias)
save ("-ascii", filename, "Ev_SMC");
tempo = etime (clock (), t0)
#vAll
#vAll.*diag(P)
