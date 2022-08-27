pkg load statistics
warning ("off");
t0 = clock (); 

rand("state",[1]);randn("state",[1]);
qtd_itr=200000                         ###### preencher ######
alias = "10obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, U, m, n] = get_network(alias);

aux = random("normal", 0, 1, [m, qtd_itr]);
er = U'*aux

I = eye(m); p = diag(P);
A1 = [A -A -I I];
c = cat(2,zeros(1,2*n),p',p');
ctype = repmat("S",1,m);
vartype = repmat("C",1,2*(n+m));

vAll = [];

for q=1:qtd_itr
[xopt, fopt, erro, extra] = glpk (c, A1, e=er(:,q), lb=[], ub=[], ctype, vartype);
v = xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m);
vAll=[vAll v];
end

Ev_SMC = cov(vAll')
DPvv=sqrt(diag(Ev_SMC))

filename=strcat("Ev_SMC_L1_", alias)
save ("-ascii", filename, "Ev_SMC");
tempo = etime (clock (), t0)

