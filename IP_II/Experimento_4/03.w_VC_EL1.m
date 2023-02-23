pkg load statistics
warning ("off");
t0 = clock ();
experiment = 2       #scenarios of experiment "2" or "3": change this number of the experiment here!  
qtd_itr=50000                          ### (qtd_itr por qtt_out)
qtt_outs_min = 0                          
qtt_outs_max = 1                          
pesos_aux = {'ppind', 'prind','ppcor', 'prcor', 'decLS'};       
alias_aux = {'6obserip2'}; 
test_stat_aux = {'sig_obs'};   
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


[A, dp, MVC, P, U, m, n] = get_network(alias, experiment);


filename=sprintf("%s_vAll_L1_%s_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, experiment);
vAll=importdata(filename);


if test_stat == "sigma_v"
  wAll = abs(vAll./(DPvv.+0.00000000001));
  else wAll = abs(vAll./dp);end


filename=sprintf("%s_wAllEL1_%s_%s_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr,experiment);
save ("-ascii", filename, "wAll");

ww=abs(wAll(1:qtd_itr,:));
vetorMax_ww=max(ww');
vetorMax_ww=sort(vetorMax_ww);

VC=[];
alpha = 0.05;
for alfa = [0.001, 0.0027,0.005, 0.01, 0.025, 0.05, 0.10, alpha]
  Posicao_corte=round((qtd_itr)*(1-alfa));
  Valor_corte=vetorMax_ww(Posicao_corte);
  VC=[VC; alfa Valor_corte];
end

VC
filename=sprintf("VC_L1_%s_%s_%s_%d_experiment%d", pesos, alias, test_stat, qtd_itr, experiment);
save ("-ascii", filename, "VC");

tempo = etime (clock (), t0)/60



endfor endfor endfor endfor
