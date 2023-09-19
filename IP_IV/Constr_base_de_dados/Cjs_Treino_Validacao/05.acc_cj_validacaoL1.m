pkg load statistics
warning ("off");
t0 = clock ();
method_aux = {'L1'}; 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pi'};            ###MMQ SOMENTE PP!!!
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr'}; ###### preencher ######
test_stat_aux = {'sigma_v'};    ###preencher
for method_num = 1:length(method_aux) 
 for alias_num = 1:length(alias_aux)
  for test_stat_num = 1:length(test_stat_aux) 
   for pesos_num = 1:length(pesos_aux)
    for min_err = [3, 6]                    ###preencher
    mfilename ()
    method = method_aux{method_num}
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    test_stat = test_stat_aux{test_stat_num}
    min_err
    max_err = min_err + 3                  ###atencao

filename=sprintf("VC_%s_%s_%s_%s_%d", method, pesos, alias,test_stat, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)

filename=sprintf("%s_ypredE%s_%s_%s_%d-%douts_%d-%ds_%ditr_train", alias,method,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
y_pred=importdata(filename);
y_pred = [y_pred(25001:50000,:);y_pred(75001:100000,:);y_pred(125001:150000,:)];
#size(y_pred)

filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_train", alias,... 
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
y_val=importdata(filename);
y_val = [y_val(25001:50000,:);y_val(75001:100000,:);y_val(125001:150000,:)];
#size(y_val)

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("acc_VAL_%s_%s_%s_%s_%d-%douts_%d-%ds_%d_alpha%d_train", method, pesos, alias,...
test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");
save ("-ascii", filename, "acc");

tempo = etime (clock (), t0)/60

endfor endfor endfor endfor endfor