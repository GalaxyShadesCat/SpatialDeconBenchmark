### calculation of JSD and RMSE for seqFISH+
current_working_directory <- getwd()
setwd(file.path(current_working_directory, 'scripts', 'Visualization'))
library(stringr)
source('metrics.R')
setwd(file.path(current_working_directory, 'scripts'))

### seqFISH+
ground_truth = read.csv('../data/seqFISH/ground_truth.csv',row.names=1)
ground_truth = as.matrix(ground_truth)
setwd('../results/seqFISH/')
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

write.csv(Results,'../results/seqFISH_JSD_RMSE.csv')
setwd(current_working_directory)
