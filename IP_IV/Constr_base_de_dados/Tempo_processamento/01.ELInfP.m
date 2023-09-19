pkg load statistics
warning ("off"); 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                             ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
test_stat_aux = {'sig_obs'};    ###preencher
for alias_num = 1:length(alias_aux)
  t0 = clock ();
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

rand("state",[13]);randn("state",[13]);
[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

P = diag(1./diag(MVC));
if pesos == "pr"
  P = chol(P); end
if pesos == "pi"
  P = eye(m); end

I = eye(m);
O = zeros(m,2*n);
A1 = [A -A -I I zeros(m,1)];
A2 = [O P -P (-1)*ones(m,1)];
A3 = [O -P P (-1)*ones(m,1)];
A = cat(1,A1, A2, A3);
c=zeros(1,2*(n+m)+1);c(1,2*(n+m)+1)=1;
ctype1 = repmat("S",1,m);
ctype2 = repmat("U",1,2*m);
ctype = cat(2,ctype1,ctype2);
vartype = repmat("C",1,2*(n+m)+1);

vAll = [];

for q=1:rows(obs_errors)
e=cat(1,obs_errors(q,:)',zeros(2*m,1));
[xopt, fopt, erro, extra] = glpk (c, A, e, lb=[], ub=[], ctype, vartype);
v = xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m);
vAll=[vAll; v'];
end


if test_stat == "sigma_v"
  wAll = abs(vAll./(DPvv.+0.00000000001));
  else wAll = abs(vAll./dp);end


filename=sprintf("%s_wAllELInf_%s_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");
delete (filename);

filename=sprintf("VC_LInf_%s_%s_%s_%d", pesos, alias, test_stat, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WLInf=VCAll(8,2)

y_val=outs_positions;

if test_stat == "sigma_v"
  y_pred = abs(vAll./DPvv) > WLInf;
  else y_pred = abs(vAll./dp) > WLInf;end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("%s_ypredELInf_%s_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
delete (filename);

endfor endfor endfor 
tempo = etime (clock (), t0)/60
filename=sprintf("%s_ELInfP_tempo", alias);
save ("-ascii", filename, "tempo");
endfor