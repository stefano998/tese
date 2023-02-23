pkg load statistics
warning ("off");
t0 = clock ();

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_0out = 200000
qtd_itr=50000                              ###preencher
qtt_outs_min = 1                           ###preencher
qtt_outs_max = 2                           ###preencher
qmax=qtt_outs_max+1;                       ### atencao
pesos_aux = {'pp'};            ###MMQ SOMENTE PP!!!
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)        
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    XSLRTMO = 0;

filename=sprintf("VC_SLRTMO_%s_%s_%d", pesos, alias, qtd_0out);
VCAll=importdata(filename);
alpha=VCAll(8,1)
XSLRTMO=VCAll(8,2)  

rand("state",[14]);randn("state",[14]);

[A, dp, MVC, P, U, m, n] = get_network(alias);
Ev_A=inv(P)-A/(A'*P*A)*A';
DPvv=(sqrt(diag(Ev_A)))';
dp;

[obs_errors, outs_positions] = gera_smc_0outdif(qtd_0out,MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);
#no caso da L2, melhor gerar novamente SMC .. nem usaria vAll
#obviamente, peguei o mesmo estado inicial de simulacao

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);

for i = 1:rows(y_val)
#A1=A; P1=P; invP1=invP; m1=m;
y_pred(i,:) = functionSLRTMO(m,A,P,invP,obs_errors(i,:)',XSLRTMO,qmax);
y_val(i,:); end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

acc_por_obs = acc_obs(m,y_pred_acertou,y_val,dp);

#test=columns(find(sum(y_pred')>2))################################

filename=sprintf("%s_ypredSLRTMO_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtd_0out,qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_SLRTMO_%s_%s_0out%d_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
qtd_0out,qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");
filename=sprintf("acc_por_obs_SLRTMO_%s_%s_0out%d_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
qtd_0out,qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc_por_obs");

tempo = etime (clock (), t0)/60

endfor endfor endfor