% Need to have run process_tpm and loaded haotaxat.txt
% and run command [HAOtxnum HAOtx]=sorttaxa(haotaxa,50,indenv+1)

snp_hydro
clf
subplot(321)
scatter(log(snp_nh4),log(snp_nitri1),40,snp_DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('Nitrification rate \mu M/day')
title('(A) Modeled Nitrification Rate')
grid on

subplot(322)
scatter(log(NH4F),HAOt,40,snp_DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('log TPM HAO')
title('(B) Observed HAO gene abundance')
grid on

subplot(323)
scatter(log(NH4F),log(HAOtxnum(:,end)+0.01),40,DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('log TPM HAO')
title('(C) Observed HAO-Gammaproteobacteria (45%)')
grid on

subplot(324)
scatter(log(NH4F),log(HAOtxnum(:,end-1)+0.01),40,DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('log TPM HAO')
title('(D) Observed HAO-Deltaproteobacteria (33%)')
grid on

subplot(325)
scatter(log(NH4F),log(HAOtxnum(:,end-2)+0.01),40,DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('log TPM HAO')
title('(E) Observed HAO-Deltaproteobacteria 6.0%)')
grid on

subplot(326)
scatter(log(NH4F),log(HAOtxnum(:,end-3)+0.01),40,DO,'filled')
xlabel('Ammonia (\mu M)')
ylabel('log TPM HAO')
title('(F) Observed HAO-Unclassified (4.2%)')
grid on
colorbar('Location','south')