pkg load statistics
warning ("off");
t0 = clock ();

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pi'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr'}; ###### preencher ######
test_stat_aux = {'sigma_v'};    ###preencher
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
    WL1 = 0;

filename=sprintf("VC_L1_%s_%s_%s_%d", pesos, alias, test_stat, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WL1=VCAll(8,2)  


[A, dp, MVC, P, U, m, n] = get_network(alias);

filename=sprintf("Ev_SMC_L1_%s_%s_%ditr", pesos, alias, 200000);
Ev_SMC=importdata(filename);
DPvv=(sqrt(diag(Ev_SMC)))';

filename=sprintf("%s_vAll_L1_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
vAll=importdata(filename);

if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_train", alias,... 
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
y_val=importdata(filename);
else y_val=zeros(qtd_itr,m); endif

if test_stat == "sigma_v"
  y_pred = abs(vAll./DPvv) > WL1;
  else y_pred = abs(vAll./dp) > WL1;end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

acc_por_obs = acc_obs(m,y_pred_acertou,y_val,dp);

filename=sprintf("%s_ypredEL1_%s_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_EL1_%s_%s_%s_%d-%douts_%d-%ds_%d_alpha%d_train", pesos, alias,...
test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");
filename=sprintf("acc_por_obs_EL1_%s_%s_%s_%d-%douts_%d-%ds_%d_alpha%d_train", pesos, alias,...
test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc_por_obs");

tempo = etime (clock (), t0)/60



endfor endfor endfor endfor
