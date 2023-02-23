pkg load statistics
warning ("off");
t0 = clock (); 
experiment = 2       #scenarios of experiment "2" or "3": change this number of the experiment here!  
qtd_itr=50000                              ### (qtd_itr por qtt_out)
qtt_outs_min = 0                         
qtt_outs_max = 1                        
alias_aux = {'6obserip2'};
for alias_num = 1:length(alias_aux)      
   for min_err = [3, 6]                   
   
    mfilename ()
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3               
    
    
[A, dp, MVC, P, U, m, n] = get_network(alias, experiment);

rand("state",[qtt_outs_max]);randn("state",[qtt_outs_max]);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);


if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_experiment%d", alias,... 
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, experiment);
save ("-ascii", filename, "outs_positions");
end
tempo = etime (clock (), t0)/60

endfor endfor 