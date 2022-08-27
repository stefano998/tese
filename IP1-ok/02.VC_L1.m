pkg load statistics
warning ("off");
t0 = clock (); 

rand("state",[0]);randn("state",[0]);
qtd_itr=200000                          ###### preencher ######
alias = "15obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, U, m, n] = get_network(alias);
filename=strcat("Ev_SMC_L1_",alias);
Ev_SMC=importdata(filename);
DPvv=sqrt(diag(Ev_SMC))

aux = random("normal", 0, 1, [m, qtd_itr]);
er = U'*aux;

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
ww=abs(vAll./DPvv);
vetorMax_ww=max(ww);
vetorMax_ww=sort(vetorMax_ww);

VC=[];
for alfa = [0.001, 0.0027, 0.01, 0.025, 0.05, 0.10]
  Posicao_corte=round((qtd_itr)*(1-alfa));
  Valor_corte=vetorMax_ww(Posicao_corte);
  VC=[VC; alfa Valor_corte];
end

VC
filename=strcat("VC_L1_", alias)
save ("-ascii", filename, "VC");
tempo = etime (clock (), t0)

