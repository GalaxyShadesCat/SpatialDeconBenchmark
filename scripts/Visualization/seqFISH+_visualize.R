###  seqFISH+ visualization
setwd('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/evaluation & visualization/')
library(Rmisc)
library(ggplot2)
library(stringr)
source('metrics.R')

# data loading
ground_truth = read.csv('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/seqFISH_10000_Result/cell_ratios.csv',row.names=1)
keep_cells_index = row.names(ground_truth) 
location = read.csv('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/datasets/seqFISH+/Lem_Locations2.csv',header = T,row.names = 4)
location = location[rownames(location) %in% keep_cells_index, ] # only keep rows that appear in both ground truth and location
for(i in 1:nrow(location)){
  location[i, c('X', 'Y')] = c(as.numeric(location[i, 1]), as.numeric(location[i, 2]))
}

setwd('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/evaluation & visualization/data/')
# data folder stores result from different methods (make sure only contains cell ratio csv)

cell_types = c('microglia', 'eNeuron', 'iNeuron', 'endo_mural', 'astrocytes', 'Olig')
for (ct in cell_types) { # create png for each cell type
  cell_type = ct
  ls_method = list.files()
  ls_results = list() # list of all the results from different methods 
  df = data.frame(x1 = location[,'X'], y1=location[,'Y'],
                  x2 = location[,'X']+1,y2 =location[,'Y']+1,Proportion = ground_truth[,cell_type] )
  
  title = cell_type
  if(title == 'endo_mural'){
    title = 'endothelial-mural'
  }else if(title == 'Olig'){
    title = 'Oligodendrocytes'
  }
  title = 'Ground Truth'
  pt = ggplot()+geom_rect(data=df, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2,fill = Proportion),color = 'black',alpha=0.5)+
    ggtitle(title)+
    theme(axis.title=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          plot.title = element_text(hjust = 0.5,size = 22),
          axis.line = element_blank(),
          legend.position = 'none')+scale_fill_gradient(low = 'white',high = '#EE4000', limits = c(0,1))
  
  for(i in 1:length(ls_method)){ # go through all results
    predict = read.csv(ls_method[i],header=T,row.names = 1 )
    predict = predict[rownames(predict) %in% delete_cells_index, ]
    title = gsub('.csv','',ls_method[i])
    if(title == 'SD2'){
      title = expression(SD^2)
    }
    colnames(predict)[which(colnames(predict) == 'endo.mural')] = 'endo_mural'
    df = data.frame(x1 = location[,'X'], y1=location[,'Y'],
                    x2 = location[,'X']+1,y2 =location[,'Y']+1,Proportion = predict[,cell_type] )
    assign(paste('p',i,sep = ''),ggplot()+geom_rect(data=df, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2,fill = Proportion),color = 'black',alpha=0.5)+
             ggtitle(title)+
             theme(axis.title=element_blank(),
                   axis.text=element_blank(),
                   axis.ticks=element_blank(),
                   panel.border = element_blank(),
                   panel.background = element_blank(),
                   plot.title = element_text(hjust = 0.5,size = 22),
                   axis.line = element_blank(),
                   legend.position = 'none')+scale_fill_gradient(low = 'white',high = '#EE4000', limits = c(0,1)))
  }
  # output png
  png(paste('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/seqFISH_10000_Result/seqFISH_10000_',cell_type,'.png',sep = ''),width = 8000, height = 2000, res = 300)
  multiplot(pt,p1,p2, cols = 6) # add p3... depending on number of csv in data folder
  dev.off()
}

