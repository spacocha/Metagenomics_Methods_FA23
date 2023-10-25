load TPMmergedKO.mat
load analyze_genes_2
indenv=[1     2     3     4     5     6     7     8    10    11    12    13    15    16    17    22    23    24    25    26   28    29    30    31    32    33    34    35    36    37    38    39    40    41    42      45    46    47];
kogenes=TPMmergedbyKOfinal{:,1};
TPM_genes_2=TPMmergedbyKOfinal{:,indenv+1};
nonzero=sum(TPM_genes_2'>0)';
kocommon=kogenes(nonzero>30);
kocommon=kocommon(1:end-1);

commongenes=TPM_genes_2(nonzero>30,:); %Pick genes found at at least 80% of sites
commongenes=commongenes(1:end-1,:); %Get rid of unassigned genes
minval=min(commongenes(commongenes(:)>0));
commongenes(commongenes(:)==0)=minval% Fill with a value that is smaller than any of the observed values
lncommongenes=log(commongenes);
lncommongenesanom=lncommongenes-mean(lncommongenes')'; %Demean each set of genes

[uct sct vct]=svd(lncommongenesanom','econ');

ko=[362 363 366 367 368 370 371 372 374 376 380 381 390 392 394 395 ...
    958 1601 1602 2108 2109 2110 2111 2112 2113 2114 2115 2305 2567 2568 ... 
     2586 2588 2591 2634 2635 2636 2637 2638 2639 2640 2641 ...
    2689 2690 2691 2692 2693 2694 2703 2704 2705 2706 2707 2708 2716 3385 3388 3389 3390 ...
    4561 5301  8906 8928 8929 10534 10535 10944 10945 10946 11180 11181 ...
    15864 15876 16257 16259 17222 17223 17224 17225 17226 17227 17229 17230 22622 23995];

konoatp=[362 363 366 367 368 370 371 372 374 376 380 381 390 392 394 395 ...
    958 1601 1602 2305 2567 2568 ... 
     2586 2588 2591 2634 2635 2636 2637 2638 2639 2640 2641 ...
    2689 2690 2691 2692 2693 2694 2703 2704 2705 2706 2707 2708 2716 3385 3388 3389 3390 ...
    4561 5301  8906 8928 8929 10534 10535 10944 10945 10946 11180 11181 ...
    15864 15876 16257 16259 17222 17223 17224 17225 17226 17227 17229 17230 22622 23995];

kohousekeeping=[1870 1872 1874 1876 1881 1887 1889 1890 1892 1937 2528 2601 2863 2864 2867 2871 2874 2876 2881 2886 2890 2906];


for j=1:length(ko)
    metabolicgenes(j,:)=TPM_genes_2(kogenes==ko(j),:);
end
for j=1:length(konoatp)
     metabolicgenesnoatp(j,:)=TPM_genes_2(kogenes==konoatp(j),:);
end
for j=1:length(kohousekeeping)
      housekeepinggenes(j,:)=TPM_genes_2(kogenes==kohousekeeping(j),:);
end
   meanhousekeeping=mean(housekeepinggenes);
    metabolicgenes(metabolicgenes(:)==0)=0.01;
    metabolicgenesnoatp(metabolicgenesnoatp(:)==0)=0.01;

    lnmetabolicgenes=log(metabolicgenes);
    lnmetabolicgenesanom=lnmetabolicgenes-mean(lnmetabolicgenes')';
   

    lnmetabolicgenesnoatp=log(metabolicgenesnoatp);
    lnmetabolicgenesnoatpanom=lnmetabolicgenesnoatp-mean(lnmetabolicgenesnoatp')';
    lnmetabolicgenesnoatpstd=lnmetabolicgenesnoatp-log(meanhousekeeping);
    lnmetabolicgenesnoatpstdanom=lnmetabolicgenesnoatpstd-mean(lnmetabolicgenesnoatpstd')';
    
[umt smt vmt]=svd(lnmetabolicgenesanom','econ');
[uat sa_t vat]=svd(lnmetabolicgenesnoatpanom','econ');
[ustdt sstdt vstdt]=svd(lnmetabolicgenesnoatpstdanom','econ');

[v1t ind1t]=sort(abs(corr(uat(:,1),lnmetabolicgenesnoatp')));
[v2t ind2t]=sort(abs(corr(uat(:,2),lnmetabolicgenesnoatp')));
[v3t ind3t]=sort(abs(corr(uat(:,3),lnmetabolicgenesnoatp')));
[v4t ind4t]=sort(abs(corr(uat(:,4),lnmetabolicgenesnoatp')));

[v1stdt ind1stdt]=sort(abs(corr(ustdt(:,1),lnmetabolicgenesnoatpstd')));
[v2stdt ind2stdt]=sort(abs(corr(ustdt(:,2),lnmetabolicgenesnoatpstd')));
[v3stdt ind3stdt]=sort(abs(corr(ustdt(:,3),lnmetabolicgenesnoatpstd')));
[v4stdt ind4stdt]=sort(abs(corr(ustdt(:,4),lnmetabolicgenesnoatpstd')));



nirBt=lnmetabolicgenes(ko==362,:)';
nirDt=lnmetabolicgenes(ko==363,:)';
nirAt=lnmetabolicgenes(ko==366,:)';
narBt=lnmetabolicgenes(ko==367,:)';
nirKt=lnmetabolicgenes(ko==368,:)';
narGZAt=lnmetabolicgenes(ko==370,:)';
narHYBt=lnmetabolicgenes(ko==371,:)';
nasAt=lnmetabolicgenes(ko==372,:)';
narIVt=lnmetabolicgenes(ko==374,:)';
nosZt=lnmetabolicgenes(ko==376,:)';
cysJt=lnmetabolicgenes(ko==380,:)';
cysIt=lnmetabolicgenes(ko==381,:)';
cysHt=lnmetabolicgenes(ko==390,:)';
sirt=lnmetabolicgenes(ko==392,:)';
aprAt=lnmetabolicgenes(ko==394,:)';
aprBt=lnmetabolicgenes(ko==395,:)';
satt=lnmetabolicgenes(ko==958,:)';
rbcLt=lnmetabolicgenes(ko==1601,:)';
rbcSt=lnmetabolicgenes(ko==1602,:)';
atpBt=lnmetabolicgenes(ko==2108,:)';
atpFt=lnmetabolicgenes(ko==2109,:)';
atpEt=lnmetabolicgenes(ko==2110,:)';
atpAt=lnmetabolicgenes(ko==2111,:)';
atpDt=lnmetabolicgenes(ko==2112,:)';
atpHt=lnmetabolicgenes(ko==2113,:)';
atpCt=lnmetabolicgenes(ko==2114,:)';
atpGt=lnmetabolicgenes(ko==2115,:)';
norCt=lnmetabolicgenes(ko==2305,:)';
napAt=lnmetabolicgenes(ko==2567,:)';
napBt=lnmetabolicgenes(ko==2568,:)';
nifDt=lnmetabolicgenes(ko==2586,:)';
nifHt=lnmetabolicgenes(ko==2588,:)';
nifKt=lnmetabolicgenes(ko==2591,:)';
petAt=lnmetabolicgenes(ko==2634,:)';
petBt=lnmetabolicgenes(ko==2635,:)';
petCt=lnmetabolicgenes(ko==2636,:)';
petDt=lnmetabolicgenes(ko==2637,:)';
petEt=lnmetabolicgenes(ko==2638,:)';
petFt=lnmetabolicgenes(ko==2639,:)';
petGt=lnmetabolicgenes(ko==2640,:)';
petHt=lnmetabolicgenes(ko==2641,:)';
psaAt=lnmetabolicgenes(ko==2689,:)';
psaBt=lnmetabolicgenes(ko==2690,:)';
psaCt=lnmetabolicgenes(ko==2691,:)';
psaDt=lnmetabolicgenes(ko==2692,:)';
psaEt=lnmetabolicgenes(ko==2693,:)';
psaFt=lnmetabolicgenes(ko==2694,:)';
psbAt=lnmetabolicgenes(ko==2703,:)';
psbBt=lnmetabolicgenes(ko==2704,:)';
psbCt=lnmetabolicgenes(ko==2705,:)';
psbDt=lnmetabolicgenes(ko==2706,:)';
psbEt=lnmetabolicgenes(ko==2707,:)';
psbFt=lnmetabolicgenes(ko==2708,:)';
psbOt=lnmetabolicgenes(ko==2716,:)';
nrfAt=lnmetabolicgenes(ko==3385,:)';
hdrA2t=lnmetabolicgenes(ko==3388,:)';
hdrB2t=lnmetabolicgenes(ko==3389,:)';
hdrC2t=lnmetabolicgenes(ko==3390,:)';
norBt=lnmetabolicgenes(ko==4561,:)';
sorAt=lnmetabolicgenes(ko==5301,:)';
petJt=lnmetabolicgenes(ko==8906,:)';
pufLt=lnmetabolicgenes(ko==8928,:)';
pufMt=lnmetabolicgenes(ko==8929,:)';
NRt=lnmetabolicgenes(ko==10534,:)';
HAOt=lnmetabolicgenes(ko==10535,:)';
pmoAamoAt=lnmetabolicgenes(ko==10944,:)';
pmoBamoBt=lnmetabolicgenes(ko==10945,:)';
pmoCamoCt=lnmetabolicgenes(ko==10946,:)';
dsrAt=lnmetabolicgenes(ko==11180,:)';
dsrBt=lnmetabolicgenes(ko==11181,:)';
nirSt=lnmetabolicgenes(ko==15864,:)';
nrfHt=lnmetabolicgenes(ko==15876,:)';
mxaCt=lnmetabolicgenes(ko==16257,:)';
mxaLt=lnmetabolicgenes(ko==16259,:)';
soxAt=lnmetabolicgenes(ko==17222,:)';
soxXt=lnmetabolicgenes(ko==17223,:)';
soxBt=lnmetabolicgenes(ko==17224,:)';
soxCt=lnmetabolicgenes(ko==17225,:)';
soxYt=lnmetabolicgenes(ko==17226,:)';
soxZt=lnmetabolicgenes(ko==17227,:)';
fccBt=lnmetabolicgenes(ko==17229,:)';
fccAt=lnmetabolicgenes(ko==17230,:)';
soxDt=lnmetabolicgenes(ko==22622,:)';
xoxFt=lnmetabolicgenes(ko==23995,:)';

names=['  nirB  '
       '  nirD  '
       '  nirA  '
       '  narB  '
       '  nirK  '
       ' narGZA '
       ' narHYB '
       '  nasA  '
       ' narIV  '
       '  nosZ  '
       '  cysJ  '
       '  cysI  '
       '  cysH  '
       '  sir   '
       '  aprA  '
       '  aprB  '
       '  sat   '
       '  rbcL  '
       '  rbcS  '
  %     '  atpB  '
  %     '  atpF  '
  %     '  atpE  '
  %     '  atpA  '
  %     '  atpD  '
  %     '  atpH  '
  %     '  atpC  '
  %     '  atpG  '
       '  norC  '
       '  napA  '
       '  napB  '
       '  nifD  '
       '  nifH  '
       '  nifK  '
       '  petA  '
       '  petB  '
       '  petC  '
       '  petD  '
       '  petE  '
       '  petF  '
       '  petG  '
       '  petH  '
       '  psaA  '
       '  psaB  '
       '  psaC  '
       '  psaD  '
       '  psaE  '
       '  psaF  '
       '  psbA  '
       '  psbB  '
       '  psbC  '
       '  psbD  '
       '  psbE  '
       '  psbF  '
       '  psbO  '
       '  nrfA  '
       '  hdrA2 '
       '  hdrB2 '
       '  hdrC2 '
       '  norB  '
       '  sorA  '
       '  petJ  '
       '  pufL  '
       '  pufM  '
       '    NR  '
       '   HAO  '
       'pmoAamoA'
       'pmoBamoB'
       'pmoCamoC'
       '  dsrA  '
       '  dsrB  '
       '  nirS  '
       '  nrfH  '
       '  mxaC  '
       '  mxaL  '
       '  soxA  '
       '  soxX  '
       '  soxB  '
       '  soxC  '
       '  soxY  '
       '  soxZ  '
       '  fccB  '
       '  fccA  '
       '  soxD  '
       '  xoxF  '];
   
close all
figure(1)
subplot(221)
