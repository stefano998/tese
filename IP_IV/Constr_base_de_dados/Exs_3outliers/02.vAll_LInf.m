pkg load statistics
warning ("off");
t0 = clock (); 

qtd_itr=10000                              ###preencher (qtd_itr por qtt_out)
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 3                           ###preencher
pesos_aux = {'pp', 'pi'};            ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)      
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    
    
rand("state",[54]);randn("state",[54]);

[A, dp, MVC, P, U, m, n] = get_network(alias);

[obs_errors, outs_positions] = gera_smc_3outs(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

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

filename=sprintf("%s_vAll_LInf_%s_%d-%douts_%d-%ds_%ditr", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "vAll");
tempo = etime (clock (), t0)/60

endfor endfor endfor