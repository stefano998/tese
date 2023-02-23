pkg load statistics
warning ("off");
t0 = clock (); 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_0out = 200000
qtd_itr=50000                              ###preencher
qtt_outs_min = 1                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp', 'pr', 'pi'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
test_stat_aux = {'sig_obs', 'sigma_v'};    ###preencher
for alias_num = 1:length(alias_aux)
 for test_stat_num = 1:length(test_stat_aux)         
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    test_stat = test_stat_aux{test_stat_num}
    min_err
    max_err = min_err + 3                  ###atencao
    WLInf = 0;

filename=sprintf("VC_LInf_%s_%s_%s_%d", pesos, alias, test_stat, qtd_0out);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WLInf=VCAll(8,2)  


[A, dp, MVC, P, U, m, n] = get_network(alias);

filename=sprintf("Ev_SMC_LInf_%s_%s_%ditr", pesos, alias, 200000);
Ev_SMC=importdata(filename);
DPvv=(sqrt(diag(Ev_SMC)))';

filename=sprintf("%s_vAll_LInf_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
vAll=importdata(filename);

if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_0out%d_%d-%douts_%d-%ds_%ditr", alias,... 
qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
y_val=importdata(filename);
else y_val=zeros(qtd_itr,m); endif

if test_stat == "sigma_v"
  y_pred = abs(vAll./DPvv) > WLInf;
  else y_pred = abs(vAll./dp) > WLInf;end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

acc_por_obs = acc_obs(m,y_pred_acertou,y_val,dp);

filename=sprintf("%s_ypredELInf_%s_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, test_stat, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_ELInf_%s_%s_%s_0out%d_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
test_stat, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");
filename=sprintf("acc_por_obs_ELInf_%s_%s_%s_0out%d_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
test_stat, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc_por_obs");

tempo = etime (clock (), t0)/60

endfor endfor endfor endfor