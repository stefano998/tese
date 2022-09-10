pkg load statistics
warning ("off");
t0 = clock (); 

rand("state",[1]);randn("state",[1]);
qtd_itr=200000                         ###### preencher ######
alias = "15obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, U, m, n] = get_network(alias);

aux = random("normal", 0, 1, [m, qtd_itr]);
er = U'*aux;

I = eye(m);
vAll = [];

R = I-A*inv(A'*P*A)*A'*P;
vAll= R*er;

Ev_SMC = cov(vAll')
DPvv=sqrt(diag(Ev_SMC))

filename=strcat("Ev_SMC_L2_", alias)
save ("-ascii", filename, "Ev_SMC");

Ev_A=inv(P)-A*inv(A'*P*A)*A'
filename=strcat("Ev_A_L2_", alias);
save ("-ascii", filename, "Ev_A");

tempo = etime (clock (), t0)

