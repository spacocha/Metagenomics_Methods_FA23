% Need to have run process_tpm and loaded pufAtaxat.txt,pufLtaxat.txt,
% others
% and run command [HAOtxnum HAOtx]=sorttaxa(haotaxa,50,indenv+1)

figure(3)
clf
subplot(321)
scatter(DO,exp(nrfAt)+exp(nrfHt)+exp(nirBt)+exp(nirDt),40,Yearday,'filled');colorbar
xlabel('Dissolved Oxygen (\mu M)')
ylabel('Abundance in tpm')
title('(A)  Observed DNRA NO_2 reductases')
grid on
text(100,60,'Colors: Decimal Day')

subplot(322)
scatter(DO,exp(pufLt)+exp(pufMt),40,Yearday,'filled');colorbar
xlabel('Dissolved Oxygen (\mu M)')
ylabel('Abundance in tpm')
title('(B) Obs. Anoxygenic Photosynthsis genes')
grid on
text(5,50,'Colors: Decimal Day')


subplot(323)
scatter(NH4F,exp(nifDt),40,DO,'filled');colorbar
xlabel('Ammonium (\mu M)')
ylabel('Abundance (tpm)')
title('(C) nifD vs. NH4, DO')
grid on
text(3,8,'Colors:DO')

subplot(324)
scatter(NH4F,exp(nifHt),40,DO,'filled');colorbar
xlabel('Ammonium (\mu M)')
ylabel('Abundance (tpm)')
title('(D) nifH vs. NH4, DO')
grid on
text(3,8,'Colors:DO')

subplot(325)
scatter(NH4F,exp(nifKt),40,DO,'filled');colorbar
xlabel('Ammonium (\mu M)')
ylabel('Abundance (tpm)')
title('(E) nifK vs. NH4, DO')
grid on
text(3,8,'Colors:DO')

subplot(326)
scatter(PO4F,exp(nifKt)+exp(nifHt)+exp(nifDt),40,DO,'filled');colorbar
xlabel('Phosphate (\mu M)')
ylabel('Abundance (tpm)')
title('(F) nifDHK vs. PO4, DO')
grid on
text(0.5,20,'Colors:DO')