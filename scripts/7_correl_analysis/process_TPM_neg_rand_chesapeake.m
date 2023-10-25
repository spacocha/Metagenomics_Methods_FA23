%import TPM_final_table.KO.neg.merged.rand.txt
%change first KO to number import

indenv=[1     2     3     4     5     6     7     8    10    11    12    13    15    16    17    22    23    24    25    26   28    29    30    31    32    33    34    35    36    37    38    39    40    41    42      45    46    47];
kogenes=TPM_final_table_KO_neg_merged_rand{:,1};
TPM_genes_2=TPM_final_table_KO_neg_merged_rand{:,indenv+1};
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

%some of the OTUs have been removed
%just pick 84 random index values instead of specific kegg ids
koind = randperm(11466,84);
for j=1:length(koind)
    ko(1,j)=kogenes(koind(j));
end

%just pick 76 random index values instead of specific kegg ids
konoatpind = randperm(11466,76);
for j=1:length(konoatpind)
    konoatp(1,j)=kogenes(konoatpind(j));
end

%just pick 22 random index values instead of specific kegg ids
hkind = randperm(11466,22);
for j=1:length(hkind)
    kohousekeeping(1,j)=kogenes(hkind(j));
end

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
 
writematrix(lnmetabolicgenes,"lnmetabolicgenes_rand.txt")
writematrix(ko',"kot_rand.txt")

%stop here for rand   
%use umt from the real sample

%perl make_dataXY_correl_matlab_umt.pl umt.txt lnmetabolicgenes_rand.txt kot_rand.txt new_umt_rand_test
%import new_umt__rand_test_X and new_umt__rand_test_Y

randdataX = table2array(new_umt_rand_test_X(:,2:end));
randdataY = table2array(new_umt_rand_test_Y(:,2:end));
[pval, corr_obs, crit_corr, est_alpha, seed_state]=mult_comp_perm_corr(randdataX',randdataY');


writematrix(pval',"pval_rand.txt");
writematrix(corr_obs', "corr_obs_rand.txt");

%export and save results as new_umt__rand_test.xlsx
