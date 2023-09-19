function [y_pred_i] = SLRTMO(m,A,P,invP,e,XSLRTMO,qmax)

y_pred_i = zeros(1,m);
I=eye(m); 

for q = 1:qmax
  q;
if columns(find(y_pred_i)) != q-1
  break end
combs = combnk (1:m, q);
T = [combs zeros(rows(combs),1)];
aux=A/(A'*P*A)*A';
R=I-aux*P;
v=R*e;
Ev=invP-aux;  #o MMQ para calcular T NAO usa [A C].
  for i = 1:rows(T)
    C = zeros(m,q);
    for j = 1:q
      C(T(i,j),j)=1; endfor
    T(i,q+1)=abs(v'*P*C/(C'*P*Ev*P*C)*C'*P*v);
    endfor
    [valor, posicao]=max(T(:,q+1));
    C = zeros(m,q);
    y_pred_aux = zeros(1,m);
    for j = 1:q
     C(T(posicao,j),j)=1;
     y_pred_aux(1,T(posicao,j))=1; endfor
     A1 = [A C];
     R=I-A1/(A1'*P*A1)*A1'*P; #o MMQ para calcular vTPv USA [A C].
     v=R*e;
     vTPv_aux = v'*P*v;
     
     if q == 1
       if max(T(:,q+1)) > XSLRTMO
       y_pred_i = y_pred_aux;
       vTPv = vTPv_aux; endif
     
     elseif vTPv - vTPv_aux > XSLRTMO  
       idx_ypredi = find(y_pred_i);
       idx_ypredaux = find(y_pred_aux);
       count = 0;
       for i=1:columns(idx_ypredi)
         for j=1:columns(idx_ypredaux)
           if idx_ypredi(1,i)==idx_ypredaux(1,j)
             count = count+1;endif endfor endfor
       if count == columns(idx_ypredi)
         y_pred_i = y_pred_aux;
         vTPv = vTPv_aux;
         endif 
       endif  

endfor 
endfunction
