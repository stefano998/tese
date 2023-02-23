pkg load statistics
warning ("off");
t0 = clock (); 
experiment = 2    #scenarios of experiment "2" or "3": change this number of the experiment here! 
qtd_itr=50000                             ###(qtd_itr por qtt_out)
qtt_outs_min = 0                          
qtt_outs_max = 1                           
pesos_aux = {'ppind', 'prind','ppcor', 'prcor', 'decLS'};            ###preencher
alias_aux = {'6obserip2'}; ###### preencher ######
for alias_num = 1:length(alias_aux)      
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    
    
[A, dp, MVC, P, U, m, n] = get_network(alias, experiment);

rand("state",[qtt_outs_max]);randn("state",[qtt_outs_max]);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

if pesos == "ppind"
  P = diag(1./diag(MVC)); end
if pesos == "prind"
  P = chol(diag(1./diag(MVC))); end
if pesos == "ppcor"
  P = P; end
if pesos == "prcor"
  P = chol(P); end

I = eye(m); p = (sum(P))';#p = diag(P); p = (sum(P))';
A1 = [A -A -I I];
c = cat(2,zeros(1,2*n),p',p');
ctype = repmat("S",1,m);
vartype = repmat("C",1,2*(n+m));

if pesos == "decLS"
  W=chol(P);
  Achol=W*A;   
  pchol=ones(1,m); 
  I=eye(m); 
  A1 = [Achol -Achol -I I]; 
  c = cat(2,zeros(1,2*n),pchol,pchol);
  obs_errors = (W*obs_errors')';end

vAll = [];

for q=1:rows(obs_errors)
[xopt, fopt, erro, extra] = glpk (c, A1, e=obs_errors(q,:), lb=[], ub=[], ctype, vartype);
v = xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m);
if pesos == "decLS"
  v = inv(W)*(xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m));
  end
vAll=[vAll; v'];
end

filename=sprintf("%s_vAll_L1_%s_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, experiment);
save ("-ascii", filename, "vAll");
tempo = etime (clock (), t0)/60

endfor endfor endfor