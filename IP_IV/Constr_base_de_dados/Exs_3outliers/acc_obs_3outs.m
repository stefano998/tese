function [acc_por_obs] = acc_obs(m,y_pred_acertou,y_val,dp)
#y_val=[y_val(1:5,:);y_val(50011:50015,:)];

qtt_outs_min = sum(y_val(1,:));
qtt_outs_max = sum(y_val(rows(y_val),:));
acc_por_obs = [];
[val_dp pos_dp]=sort(dp);
"ultima coluna: 1 eh o menor dp, logo maior p";
for qtt_outliers = [qtt_outs_min,qtt_outs_max]

if qtt_outliers == 0
  continue; end
aux_val = (find(sum(y_val')==qtt_outliers))';  #procura em colunas...retorna indices das linhas que atendem condicao
aux_val = y_val(aux_val,:);
aux_acertou = (find(sum(y_pred_acertou')==qtt_outliers))';  #procura em colunas...retorna indices das linhas que atendem condicao
aux_acertou = y_pred_acertou(aux_acertou,:);
count_val = sum(aux_val);
count_acertou = sum(aux_acertou);
accs=[100*(count_acertou./count_val)]';

acc_por_obs = [acc_por_obs; qtt_outliers.*ones(m,1), [1:1:m]', accs, pos_dp'];
end
acc_por_obs;
end