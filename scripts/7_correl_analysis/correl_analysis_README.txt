#Use a combination of MATLAB and perl to look at how the genes are correlated with each other or with measured or modeled environmental factors
#after running the process_TPM_neg_chesapeake.m in MATLAB, export the genes as lnmetabolicgenes.txt, and EOFs as umt.txt
#In matlab, run the commands in this with manual import of the data
process_TPM_neg_chesapeake_part1.m

#Once that is done, run this perl command
perl make_dataXY_correl_matlab_umt.pl umt.txt lnmetabolicgenes.txt kot.txt new_umt_test

#Use the output of the perl script as input to the second part of the matlab code, with manual data import
correlation_analysis_TPM_neg.m

#additionally, mix up all of the values within each library to make sure there isn't a correlation because of the library structure
sbatch randmat2.sh

#This runs the following command, but use the bigmem cluster (you have to load a large data matrix into memoray for this
#perl make_rand_mat.pl TPM_final_table.KO.neg.merged.txt > TPM_final_table.KO.neg.merged.rand.txt

#Follow the same steps in matlab, with manual import
process_TPM_neg_rand_chesapeake_part1.m

#run this perl script
perl make_dataXY_correl_matlab_umt.pl umt.txt lnmetabolicgenes_rand.txt kot_rand.txt new_umt_rand_test

#run the correlation analysis in matlab to see if any significant correlations remain
correlation_analysis_TPM_neg_rand.m


