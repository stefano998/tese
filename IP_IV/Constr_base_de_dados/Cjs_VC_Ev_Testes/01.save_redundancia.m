pkg load statistics
warning ("off");
t0 = clock (); 

alias_aux = {'gemael147','ghi355gps','nive20obs','gnssrbc21','ghiniv255','kleincorr',}; ###### preencher: ver "get_network.m" ######
for alias_num = 1:length(alias_aux)      
  
    mfilename ()
    alias = alias_aux{alias_num}


[A, dp, MVC, P, U, m, n] = get_network(alias);
I=eye(m);
aux=A/(A'*P*A)*A';
R=I-aux*P;
r=diag(R);

filename=sprintf("%s_diag_da_matriz_redund", alias);
save ("-ascii", filename, "r");

tempo = etime (clock (), t0)/60

endfor  