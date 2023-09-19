pkg load statistics
warning ("off");
t0 = clock (); 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp','pi'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr'}; ###### preencher ######
test_stat_aux = {'sig_obs'};    ###preencher
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
    

[A, dp, MVC, P, U, m, n] = get_network(alias);

filename=sprintf("Ev_SMC_LInf_%s_%s_%ditr", pesos, alias, 200000);
Ev_SMC=importdata(filename);
DPvv=(sqrt(diag(Ev_SMC)))';

filename=sprintf("%s_vAll_LInf_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
vAll=importdata(filename);


if test_stat == "sigma_v"
  wAll = abs(vAll./(DPvv.+0.00000000001));
  else wAll = abs(vAll./dp);end


filename=sprintf("%s_wAllELInf_%s_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

tempo = etime (clock (), t0)/60

endfor endfor endfor endfor