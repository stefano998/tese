"obs: tempo do simplex um pco menor que L1_iter"
"mais ou menos 6/7 do tempo"
pkg load statistics
warning ("off");
t0 = clock (); 

rand("state",[1]);randn("state",[1]);
qtd_itr=200000                         ###### preencher ######
alias = "15obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, U, m, n] = get_network(alias);
Pini=P;
pini=diag(P);

aux = random("normal", 0, 1, [m, qtd_itr]);
er = U'*aux;

vAll = [];

for q=1:qtd_itr
x=inv(A'*Pini*A)*A'*Pini*er(:,q);
v=A*x-er(:,q);

for k = 1:1000
      vant=v;
      P=diag(pini./((vant.**2)+1e-12)); 
      x=inv(A'*P*A)*A'*P*er(:,q);
      v=A*x-er(:,q);
      if (sum(abs(v-vant))<1e-8), break; end; 
end;
k;
vAll=[vAll v];
end

Ev_SMC = cov(vAll')
DPvv=sqrt(diag(Ev_SMC))

filename=strcat("Ev_SMC_L1_iter_", alias)
save ("-ascii", filename, "Ev_SMC");
tempo = etime (clock (), t0)

