%import new_umt_test_X and new_umt_test_Y

dataX = table2array(new_umt_test_X(:,2:end));
dataY = table2array(new_umt_test_Y(:,2:end));
[pval, corr_obs, crit_corr, est_alpha, seed_state]=mult_comp_perm_corr(dataX',dataY');

