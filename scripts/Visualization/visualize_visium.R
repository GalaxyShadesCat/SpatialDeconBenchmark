### Visualization of deconvolved cell type proportion estiates ###
library(ggplot2)
setwd("/Users/vanessayu/Downloads/")

# read in original counts and location data
st_counts <- read.csv("/Users/vanessayu/biof3001/dataset/visium/visium_correct/filtered_st_counts.csv", row.names = 1)
st_locations <- read.csv("/Users/vanessayu/biof3001/dataset/visium/visium_correct/filtered_st_locations.csv")


res <- lapply(c("SpatialDecon", "rctd", "tangram"), 
              function(method){
              deconvolved_mtx <- read.csv(paste0("Visium_", method, ".txt"), row.names = 1)
              deconvolved_mtx$method <- method
              out_df <- cbind(st_locations, deconvolved_mtx)
              return(out_df)
            })

res_df <- do.call(rbind, res)

## plot slides for three selected cell types in original benchmark paper ##

# function to plot x, y coordinates of ST spots and coloured by deconvolved cell types estimates
PlotResults <- function(data, celltype){
  p <-  ggplot(data, aes(x = x, y = y, color = .data[[celltype]])) +
      ggtitle(celltype)+
      facet_wrap(~method) +
      geom_point(size = 1.2) +
      scale_color_gradient(name = "Proportion", low = "white", high = "red") + # Gradient color bar
      theme_minimal()+
      theme(
        legend.position = "right",
        axis.ticks = element_blank(),       # Remove both x and y ticks
        axis.text.x = element_blank(),      # Remove x-axis labels
        axis.text.y = element_blank(),      # Remove y-axis labels
        axis.title.x = element_blank(),     # Remove x-axis title
        axis.title.y = element_blank(),     # Remove y-axis title
      )
  print(p)
}

# Plot results 
PlotResults(res_df, "Oligo")
PlotResults(res_df, "Ext_Thal")
PlotResults(res_df, "Ext_ClauPyr")


## Plot markers gene expression for each cell type ##
st_counts <- cbind(log1p(t(st_counts)), st_locations) # transform st counts by lop1p to limit colour scale of expression plot

PlotMarker <- function(counts, markers){
  # Reshape data to long format
  data_long <- counts %>%
    pivot_longer(cols = markers, names_to = "marker", values_to = "value")
  
  # Plot
  p <- ggplot(data_long, aes(x = x, y = y)) +
    geom_point(aes(
      color = ifelse(marker %in% markers, value, NA)
    ), size = 1.2) +
    facet_wrap(~marker) +
    scale_alpha_continuous(name = "Alpha Value Scale", range = c(0.1, 1)) +
    scale_color_gradient(name = "Log1p", low = "white", high = "red") +
    theme_minimal() +
    theme(
      legend.position = "right",
      axis.ticks = element_blank(),       # Remove both x and y ticks
      axis.text.x = element_blank(),      # Remove x-axis labels
      axis.text.y = element_blank(),      # Remove y-axis labels
      axis.title.x = element_blank(),     # Remove x-axis title
      axis.title.y = element_blank()      # Remove y-axis title
    )
  
  print(p)
}

# plot markers
PlotMarker(st_counts_mod, c("Mog", "Plp1"))
PlotMarker(st_counts_mod, c("Synpo2", "Ptpn3", "Slc17a6"))
PlotMarker(st_counts_mod, c("Nr4a2", "Synpr"))


