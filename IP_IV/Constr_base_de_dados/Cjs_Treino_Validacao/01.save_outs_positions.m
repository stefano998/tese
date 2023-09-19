pkg load statistics
warning ("off");
t0 = clock (); 

qtd_itr=50000                              ###preencher (qtd_itr por qtt_out)
qtt_outs_min = 0                           ###preencher
qtt_outs_max = 2                           ###preencher
alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr'}; ###### preencher ######
for alias_num = 1:length(alias_aux)      
   for min_err = [3, 6]                    ###preencher
   
    mfilename ()
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3                  ###atencao
    
    
rand("state",[13]);randn("state",[13]);

[A, dp, MVC, P, U, m, n] = get_network(alias);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);


if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_train", alias,... 
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "outs_positions");
end
tempo = etime (clock (), t0)/60

endfor endfor 