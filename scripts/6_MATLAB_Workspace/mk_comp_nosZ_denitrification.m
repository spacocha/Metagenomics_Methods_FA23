% Need to have run process_tpm and loaded haotaxat.txt
% and run command [HAOtxnum HAOtx]=sorttaxa(haotaxa,50,indenv+1)

snp_hydro
clf
subplot(321)
scatter(snp_DO,log(snp_dno2),40,log(snp_no2),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('Denitrification rate \mu M/day')
title('(A) Modeled Denitrification Rate')
grid on

subplot(322)
scatter(DO,nosZt,40,log(NO2F),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('log TPM nosZ')
title('(B) Observed nosZ gene abundance')
grid on

subplot(323)
scatter(DO,log(exp(norBt)+exp(norCt)),40,log(NO2F),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('log TPM norB')
title('(C) Observed norB gene abundance')
grid on

subplot(324)
scatter(DO,log(NOSZtxnum(:,end)),40,log(NO2F),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('log TPM nosZ')
title('(D) Observed nosZ-Gammaproteobacteria (39%)')
grid on

subplot(325)
scatter(DO,log(NOSZtxnum(:,end-1)),40,log(NO2F),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('log TPM nosZ')
title('(D) Observed nosZ-Bacteroidetes (37%)')
grid on


subplot(326)
scatter(DO,log(NORBtxnum(:,end-5)),40,log(NO2F),'filled');caxis([-4.5 3])
xlabel('Oxygen (\mu M)')
ylabel('log TPM norB')
title('(F) Observed norB-Bacteroidetes (4.5%)')
grid on
colorbar('Location','south')