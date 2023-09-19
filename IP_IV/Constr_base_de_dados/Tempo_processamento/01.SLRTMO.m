pkg load statistics
warning ("off");

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=50000                             ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
qmax=qtt_outs_max+1;                       ### atencao
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
    
filename=sprintf("VC_SLRTMO_%s_%s_%d", pesos, alias, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
XSLRTMO=VCAll(8,2) 
    
[A, dp, MVC, P, U, m, n] = get_network(alias);

rand("state",[13]);randn("state",[13]);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);
#no caso da L2, gerar SMC e computar vAll eh mais rapido q ler importar vAll
#obviamente, peguei o mesmo estado inicial de simulacao

I = eye(m);
R=I-A/(A'*P*A)*A'*P;
vAll= (R*obs_errors')';
Ev=inv(P)-A/(A'*P*A)*A';  #o MMQ para calcular T NAO usa [A C].
#vAll = vAll(1:rows(vAll)/(qtt_outs_max-qtt_outs_min+1),:);  ####aqui pego somente ex de 0 out##
T=zeros(size(vAll));

for i = 1:rows(vAll)
  for j = 1:m
C = zeros(m,1);
C(j,1)=1;
v=vAll(i,:)';
T(i,j)=abs(v'*P*C/(C'*P*Ev*P*C)*C'*P*v);
end end

wAll=T;

filename=sprintf("%s_wAllSLRTMO_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");
delete(filename)

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);

for i = 1:rows(y_val)
#A1=A; P1=P; invP1=invP; m1=m;
y_pred(i,:) = functionSLRTMO(m,A,P,invP,obs_errors(i,:)',XSLRTMO,qmax);
y_val(i,:); end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("%s_ypredSLRTMO_%s_%d-%douts_%d-%ds_%ditr_train", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
delete (filename);

endfor endfor
tempo = etime (clock (), t0)/60
filename=sprintf("%s_SLRTMO_tempo", alias);
save ("-ascii", filename, "tempo");
endfor