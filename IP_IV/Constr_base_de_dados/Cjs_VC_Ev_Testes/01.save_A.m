pkg load statistics
warning ("off");
t0 = clock (); 

alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######

for alias_num = 1:length(alias_aux)
  
mfilename ()
alias = alias_aux{alias_num}
[A, dp, MVC, P, U, m, n] = get_network(alias);

filename=sprintf("%s_A", alias);
save ("-ascii", filename, "A");



endfor