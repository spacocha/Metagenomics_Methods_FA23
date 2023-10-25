% Need to have run process_tpm and loaded haotaxat.txt
% and run command [HAOtxnum HAOtx]=sorttaxa(haotaxa,50,indenv+1)

snp_hydro
clf
subplot(321)
scatter(Yearday,-Depth,40,dsrAt,'filled');colorbar
xlabel('Time in 2017 Decimal Day')
ylabel('Depth in m')
title('(A)  Observed log dsrA (tpm)')
grid on

subplot(322)
scatter(Yearday,-Depth,40,dsrBt,'filled');colorbar
xlabel('Time in 2017 Decimal Day')
ylabel('Depth in m')
title('(B) Observed log dsrB (tpm)')
grid on

subplot(323)
scatter(log(snp_h2s),log(snp_srra),40,DO,'filled');colorbar
xlabel('log H_2S (\mu M)')
ylabel('log SO_4 reduction (\mu M S/day)')
title('(C) Modeled sulfate reduction')
grid on
text(-5,-9,'Colors:DO')

subplot(324)
scatter(log(snp_h2s),log(snp_sox_O+snp_sox_no3+snp_sox_no2),40,DO,'filled');colorbar
xlabel('log H_2S (\mu M)')
ylabel('log H_2S oxidation (\mu M S/day)')
title('(D) Modeled sulfide oxidation')
grid on
text(-5,-9,'Colors:DO')

subplot(325)
scatter(log(snp_srra),log(exp(dsrAt)+exp(dsrBt)),40,DO,'filled'); colorbar
xlabel('log Mod. SO_4 Reduction (\mu M S/day)')
ylabel('log TPM dsrA+dsrB')
title('(E) Modelled Sulfate reduction vs. dsrAB')
grid on
text(-5,-1,'Colors:DO')

subplot(326)
scatter(log(snp_sox_O+snp_sox_no2+snp_sox_no3),log(exp(dsrAt)+exp(dsrBt)),40,DO,'filled'); colorbar
xlabel('log Mod. H_2S Oxidation (\mu M S/day)')
ylabel('log TPM dsrA+dsrB')
title('(F) Modelled Sulfide oxidation vs. dsrAB')
grid on
text(-5,-1,'Colors:DO')