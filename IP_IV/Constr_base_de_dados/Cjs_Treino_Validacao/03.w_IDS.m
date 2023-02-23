pkg load statistics
warning ("off");
t0 = clock (); 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp'};            ###MMQ SOMENTE PP!!!
alias_aux = {'kleincorr',}; ###### preencher ######
for alias_num = 1:length(alias_aux)     
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    

[A, dp, MVC, P, U, m, n] = get_network(alias);

rand("state",[13]);randn("state",[13]);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);
#no caso da L2, gerar SMC e computar vAll eh mais rapido q ler importar vAll
#obviamente, peguei o mesmo estado inicial de simulacao

Ev=inv(P)-A/(A'*P*A)*A';
#DPvv=(sqrt(diag(Ev_A)))';
#dp;

I = eye(m);
R=I-A/(A'*P*A)*A'*P;
vAll= R*obs_errors';
Pv=P*vAll; PEvP=sqrt(diag(P*Ev*P)); wAll=abs(Pv./(PEvP+0.00000000000001));
wAll=wAll';

filename=sprintf("%s_wAllIDS_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

tempo = etime (clock (), t0)/60

endfor endfor endfor 