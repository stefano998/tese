pkg load statistics
warning ("off");
t0 = clock (); 

#inserir info do arquivo a ser importado.. aqui uso todas as qtt de out###
qtd_itr=10000                              ###preencher
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
pesos_aux = {'pp'};           
alias_aux = alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)     
  for pesos_num = 1:length(pesos_aux)
   for min_err = [9]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 6                  ###atencao
    

[A, dp, MVC, P, U, m, n] = get_network(alias);

rand("state",[44]);randn("state",[44]);

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

filename=sprintf("%s_wAllSLRTMO_%s_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

tempo = etime (clock (), t0)/60

endfor endfor endfor 