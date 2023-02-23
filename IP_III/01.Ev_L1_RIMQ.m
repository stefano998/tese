pkg load statistics
warning ("off");
t0 = clock (); 

qtd_itr=200000                          ###### preencher ######
pesos_aux = {'pp', 'pr', 'pi'};            ###preencher
alias_aux = {'kleincorr',}; ###### preencher: ver "get_network.m" ######

for alias_num = 1:length(alias_aux)
  for pesos_num = 1:length(pesos_aux)

mfilename ()
rand("state",[51]);randn("state",[51]);    
pesos = pesos_aux{pesos_num}
alias = alias_aux{alias_num}

[A, dp, MVC, P, U, m, n] = get_network(alias);

P = diag(1./diag(MVC));
if pesos == "pr"
  P = chol(P); end
if pesos == "pi"
  P = eye(m); end

aux = (mvnrnd(zeros(m,1),MVC,qtd_itr));  #size: qtd_itr x m
er = aux'; 
size(er);

Pini=P;
pini=diag(P);

vAll = [];

for q=1:qtd_itr
x=inv(A'*Pini*A)*A'*Pini*er(:,q);
v=A*x-er(:,q);

for k = 1:1000
      vant=v;
      P=diag(pini./((vant.**2)+1e-12));  #sugestao do amiri new (ao quad para convergir rapido)
      x=inv(A'*P*A)*A'*P*er(:,q);
      v=A*x-er(:,q);
      if (sum(abs(v-vant))<1e-8), break; end; %stop if necessary    
end;

vAll=[vAll v];
end

Ev_SMC = cov(vAll');
DPvv=sqrt(diag(Ev_SMC))

filename=sprintf("Ev_SMC_L1repon_%s_%s_%ditr", pesos, alias, qtd_itr);
save ("-ascii", filename, "Ev_SMC");
tempo = etime (clock (), t0)/60

endfor endfor