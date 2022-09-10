pkg load statistics
warning ("off");
t0 = clock ();
experiment = 3       #scenarios of experiment "2" or "3": change this number of the experiment here! 
qtd_itr=50000                             ### (qtd_itr por qtt_out)
qtt_outs_min = 0                          
qtt_outs_max = 1                          
pesos_aux = {'ppind','ppcor'};      
alias_aux = {'6obserip2'};
test_stat_aux = {'sig_obs'};  
for alias_num = 1:length(alias_aux)
 for test_stat_num = 1:length(test_stat_aux)         
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                   
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    test_stat = test_stat_aux{test_stat_num}
    min_err
    max_err = min_err + 3               
    WL1 = 0;

filename=sprintf("VC_LInf_%s_%s_%s_%d_experiment%d", pesos, alias, test_stat, qtd_itr,experiment);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WLInf=VCAll(8,2)  


[A, dp, MVC, P, U, m, n] = get_network(alias, experiment);


filename=sprintf("%s_vAll_LInf_%s_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, experiment);
vAll=importdata(filename);

if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, experiment);
y_val=importdata(filename);
else y_val=zeros(qtd_itr,m); endif

if test_stat == "sigma_v"
  y_pred = abs(vAll./DPvv) > WLInf;
  else y_pred = abs(vAll./dp) > WLInf;end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("acc_ELInf_%s_%s_%s_%d-%douts_%d-%ds_%d_alpha%d_experiment%d", pesos, alias,...
test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100, experiment);
save ("-ascii", filename, "acc");

tempo = etime (clock (), t0)/60



endfor endfor endfor endfor
