function [y_pred_i] = functionIDS(m,A,P,invP,e,WIDS)

e=[e [1:1:m]'];    #insere coluna com index
y_pred_i = zeros(1,m);

do 
  I=eye(m);
  aux=A/(A'*P*A)*A';
  R=I-aux*P;
  v=R*e(:,1);
  Ev=invP-aux;
  Pv=P*v; PEvP=sqrt(diag(P*Ev*P)); ww=abs(Pv./(PEvP+0.0000000000000000001));
  #ww=abs(v./sqrt(diag(Ev.+0.000000001)));
  if (max(ww)>WIDS)
    [valor, posicao]=max(ww);
    m=m-1;
    y_pred_i(1,e(posicao,2)) = 1;
    A(posicao,:)=[];e(posicao,:)=[];
    P(posicao,:)=[];P(:,posicao)=[];invP(posicao,:)=[];invP(:,posicao)=[];
    ww1=ww; ww1(posicao,:)=[];
    
    if (valor-max(ww1))<0.0000000000000000001
      #y_pred_i(1,1) = 99;, break endif
      y_pred_i(1,e(posicao,2)) = 0; break endif
  endif
  
until max(ww)<=WIDS 

end