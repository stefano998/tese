pkg load statistics
warning ("off");
t0 = clock ();

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=10000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 3                           ###preencher
pesos_aux = {'pp'};            
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)        
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    WIDS = 0;

filename=sprintf("VC_IDS_%s_%s_%d", pesos, alias, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WIDS=VCAll(8,2)    
    
rand("state",[54]);randn("state",[54]);

[A, dp, MVC, P, U, m, n] = get_network(alias);
Ev_A=inv(P)-A/(A'*P*A)*A';
#DPvv=(sqrt(diag(Ev_A)))';

[obs_errors, outs_positions] = gera_smc_3outs(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);
#no caso da L2, melhor gerar novamente SMC .. nem usaria vAll
#obviamente, peguei o mesmo estado inicial de simulacao

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);
for i = 1:rows(y_val)
A1=A; P1=P; invP1=invP; m1=m;
y_pred(i,:) = functionIDS(m1,A1,P1,invP1,obs_errors(i,:)',WIDS); end


[acc, y_pred_acertou] = acc_score_3outs(y_pred,y_val);
acc

acc_por_obs = acc_obs_3outs(m,y_pred_acertou,y_val,dp);

filename=sprintf("%s_ypredIDS_%s_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_IDS_%s_%s_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");
filename=sprintf("acc_por_obs_IDS_%s_%s_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc_por_obs");

tempo = etime (clock (), t0)/60

endfor endfor endfor