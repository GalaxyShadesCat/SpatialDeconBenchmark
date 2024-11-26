### calculation of JSD and RMSE for seqFISH+
setwd('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/evaluation & visualization/')
library(stringr)
source('metrics.R')

### seqFISH+

ground_truth = read.csv('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/seqFISH_10000_Result/cell_ratios.csv',row.names=1)
ground_truth = as.matrix(ground_truth)
setwd('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/evaluation & visualization/data/')
ls_method = list.files()
Results = data.frame(matrix(ncol = ncol(ground_truth) +2, nrow = length(ls_method)))
for(i in 1:length(ls_method)){
  method = read.csv(ls_method[i],row.names = 1)
  method = as.matrix(method)
  res = benchmark_performance(method,ground_truth)
  Results[i,1] = res$JSD
  Results[i,2] = res$Sum_RMSE
  Results[i,3:ncol(Results)] = res$RMSE
}
colnames(Results) = c('JSD','total_RMSE',colnames(ground_truth))
rownames(Results) = gsub('.csv','',ls_method)

write.csv(Results,'C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/seqFISH_10000_Result/seqFISH_10000_JSD_RMSE.csv')
