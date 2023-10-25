%import TPM_merged_by_KO_final.neg.merged.txt
%change first KO to number import

indenv=[1     2     3     4     5     6     7     8    10    11    12    13    15    16    17    22    23    24    25    26   28    29    30    31    32    33    34    35    36    37    38    39    40    41    42      45    46    47];
kogenes=TPM_final_table_KO_neg_merged{:,1};
TPM_genes_2=TPM_final_table_KO_neg_merged{:,indenv+1};
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


writematrix(ko',"kot.txt")
writematrix(lnmetabolicgenes, "lnmetabolicgenes.txt")
writematrix(umt, "umt.txt")



