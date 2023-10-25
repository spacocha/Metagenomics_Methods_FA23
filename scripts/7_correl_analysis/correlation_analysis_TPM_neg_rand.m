%perl make_dataXY_correl_matlab_umt.pl umt.txt lnmetabolicgenes_rand.txt kot_rand.txt new_umt_rand_test
%import new_umt__rand_test_X and new_umt__rand_test_Y

randdataX = table2array(new_umt_rand_test_X(:,2:end));
randdataY = table2array(new_umt_rand_test_Y(:,2:end));
[pval, corr_obs, crit_corr, est_alpha, seed_state]=mult_comp_perm_corr(randdataX',randdataY');


writematrix(pval',"pval_rand.txt");
writematrix(corr_obs', "corr_obs_rand.txt");

%export and save results as new_umt__rand_test.xlsx
