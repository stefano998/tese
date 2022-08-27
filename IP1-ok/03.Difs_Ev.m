output_precision(5)
alias = "06obs-IP1"                 ###### preencher: ver "get_network.m" ######

[A, dp, MVC, P, m, n] = get_network(alias);
filename=strcat("Ev_SMC_L1_",alias);
Ev_L1=importdata(filename);
filename=strcat("Ev_SMC_L1_iter_",alias);
Ev_L1_iter=importdata(filename);
filename=strcat("Ev_SMC_LInf_",alias);
Ev_LInf=importdata(filename);
filename=strcat("Ev_A_L2_",alias);
Ev_L2_A=importdata(filename);
filename=strcat("Ev_SMC_L2_",alias);
Ev_L2_SMC=importdata(filename);

"difs entre Ev_L2_A e Ev_L2_SMC"
DifsA=abs(abs(Ev_L2_A)-abs(Ev_L2_SMC));
DifsAvar=diag(DifsA);
DifsAcov=[];
for i=1:m
  for j=1:m
    if i!=j
      DifsAcov=[DifsAcov; DifsA(i,j)];
    end
  end
end
maxAvar=max(DifsAvar)
maxAcov=max(DifsAcov)
minAvar=min(DifsAvar)
minAcov=min(DifsAcov)
meanAvar=mean(DifsAvar)
meanAcov=mean(DifsAcov)

"difs entre Ev_L1 e Ev_L2_SMC"
DifsSMC=abs(abs(Ev_L2_SMC)-abs(Ev_L1));
DifsSMCvar=diag(DifsSMC);
DifsSMCcov=[];
for i=1:m
  for j=1:m
    if i!=j
      DifsSMCcov=[DifsSMCcov; DifsSMC(i,j)];
    end
  end
end
maxSMCvar=max(DifsSMCvar)
maxSMCcov=max(DifsSMCcov)
minSMCvar=min(DifsSMCvar)
minSMCcov=min(DifsSMCcov)
meanSMCvar=mean(DifsSMCvar)
meanSMCcov=mean(DifsSMCcov)


"difs entre Ev_LInf e Ev_L2_SMC"
DifsSMC=abs(abs(Ev_L2_SMC)-abs(Ev_LInf));
DifsSMCvar=diag(DifsSMC);
DifsSMCcov=[];
for i=1:m
  for j=1:m
    if i!=j
      DifsSMCcov=[DifsSMCcov; DifsSMC(i,j)];
    end
  end
end
maxSMCvar=max(DifsSMCvar)
maxSMCcov=max(DifsSMCcov)
minSMCvar=min(DifsSMCvar)
minSMCcov=min(DifsSMCcov)
meanSMCvar=mean(DifsSMCvar)
meanSMCcov=mean(DifsSMCcov)


"difs entre Ev_L1 e Ev_LInf"
DifsSMC=abs(abs(Ev_LInf)-abs(Ev_L1));
DifsSMCvar=diag(DifsSMC);
DifsSMCcov=[];
for i=1:m
  for j=1:m
    if i!=j
      DifsSMCcov=[DifsSMCcov; DifsSMC(i,j)];
    end
  end
end
maxSMCvar=max(DifsSMCvar)
maxSMCcov=max(DifsSMCcov)
minSMCvar=min(DifsSMCvar)
minSMCcov=min(DifsSMCcov)
meanSMCvar=mean(DifsSMCvar)
meanSMCcov=mean(DifsSMCcov)



"difs entre Ev_L1 e Ev_L1_iter"
DifsSMC=abs(abs(Ev_L1_iter)-abs(Ev_L1));
DifsSMCvar=diag(DifsSMC);
DifsSMCcov=[];
for i=1:m
  for j=1:m
    if i!=j
      DifsSMCcov=[DifsSMCcov; DifsSMC(i,j)];
    end
  end
end
maxSMCvar=max(DifsSMCvar)
maxSMCcov=max(DifsSMCcov)
minSMCvar=min(DifsSMCvar)
minSMCcov=min(DifsSMCcov)
meanSMCvar=mean(DifsSMCvar)
meanSMCcov=mean(DifsSMCcov)