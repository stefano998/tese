pkg load statistics
warning ("off");
t0 = clock (); 

qtd_0out = 200000
qtd_itr=50000                              ###preencher (qtd_itr por qtt_out)
qtt_outs_min = 1                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp', 'pr', 'pi'};            ###preencher
alias_aux = {'kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)      
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    
    
rand("state",[14]);randn("state",[14]);

[A, dp, MVC, P, U, m, n] = get_network(alias);

[obs_errors, outs_positions] = gera_smc_0outdif(qtd_0out,MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

P = diag(1./diag(MVC));
if pesos == "pr"
  P = chol(P); end
if pesos == "pi"
  P = eye(m); end

Pini=P;
pini=diag(P);

vAll = [];

for q=1:rows(obs_errors)
x=inv(A'*Pini*A)*A'*Pini*obs_errors(q,:)';
v=A*x-obs_errors(q,:)';

for k = 1:1000
      vant=v;
      P=diag(pini./((vant.**2)+1e-12));  #sugestao do amiri new (ao quad para convergir rapido)
      x=inv(A'*P*A)*A'*P*obs_errors(q,:)';
      v=A*x-obs_errors(q,:)';
      if (sum(abs(v-vant))<1e-8), break; end; %stop if necessary    
end;

vAll=[vAll; v'];
end

filename=sprintf("%s_vAll_L1repon_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "vAll");
tempo = etime (clock (), t0)/60

endfor endfor endfor