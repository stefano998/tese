pkg load statistics
warning ("off");

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                             ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp'};            ###MMQ SOMENTE PP!!!
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr'}; ###### preencher ######
for alias_num = 1:length(alias_aux) 
   t0 = clock (); 
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    

filename=sprintf("VC_IDS_%s_%s_%d", pesos, alias, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WIDS=VCAll(8,2)  

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
delete (filename);

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);
for i = 1:rows(y_val)
A1=A; P1=P; invP1=invP; m1=m;
y_pred(i,:) = functionIDS(m1,A1,P1,invP1,obs_errors(i,:)',WIDS); end


[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("%s_ypredIDS_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
delete (filename);

endfor endfor
tempo = etime (clock (), t0)/60
filename=sprintf("%s_IDS_tempo", alias);
save ("-ascii", filename, "tempo");
endfor