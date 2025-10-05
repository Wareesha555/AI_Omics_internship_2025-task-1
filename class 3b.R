if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

BiocManager::install(c("GEOquery","affy","arrayQualityMetrics"),FORCE=TRUE)

install.packages("dplyr")

library(GEOquery)             # Download GEO datasets (series matrix, raw CEL files)
library(affy)                 # Pre-processing of Affymetrix microarray data (RMA normalization)
library(arrayQualityMetrics)  # QC reports for microarray data
library(dplyr)                # Data manipulation


gse_data <- getGEO("GSE79973", GSEMatrix = TRUE)

eset <- gse_data[[1]]

expression_data <- exprs(eset)
feature_data <- fData(eset)
phenotype_data <- pData(eset)

sum(is.na(phenotype_data$source_name_ch1))

getGEOSuppFiles("GSE79973", baseDir = "Raw_Data", makeDirectory = TRUE)

untar("Raw_Data/GSE79973/GSE79973_RAW.tar", exdir = "Raw_Data/CEL_Files")

raw_data <- ReadAffy(celfile.path = "Raw_Data/CEL_Files")
raw_data

arrayQualityMetrics(
  expressionset = raw_data,
  outdir = file.path(results_dir, "QC_Raw_Data"),
  force = TRUE,
  do.logtransform = TRUE
)


normalized_data <- rma(raw_data)

arrayQualityMetrics(
  expressionset = normalized_data,
  outdir = file.path(results_dir, "QC_Normalized_Data"),
  force = TRUE
)

processed_data <- as.data.frame(exprs(normalized_data))

dim(processed_data)  

png(file.path(results_dir, "Plots", "Boxplot_Normalized.png"), width = 900, height = 600)
boxplot(
  eset_norm,
  main = "Boxplot After Normalization",
  xlab = "Samples",
  ylab = "Expression Values",
  col = "lightblue",
  las = 2
)
dev.off()

pca <- prcomp(t(eset_norm), scale. = TRUE)
pca_data <- data.frame(
  PC1 = pca$x[,1],
  PC2 = pca$x[,2],
  Group = phenotype_data$source_name_ch1
)

png(file.path(results_dir, "Plots", "PCA_Normalized.png"), width = 800, height = 600)
ggplot(pca_data, aes(PC1, PC2, color = Group)) +
  geom_point(size = 4, alpha = 0.7) +
  labs(title = "PCA Plot (After Normalization)",
       x = "PC1", y = "PC2") +
  theme_minimal()
dev.off()

png(file.path(results_dir, "Plots", "PCA_Normalized.png"), width = 800, height = 600)
ggplot(pca_data, aes(PC1, PC2, color = Group)) +
  geom_point(size = 4, alpha = 0.7) +
  labs(title = "PCA Plot (After Normalization)",
       x = "PC1", y = "PC2") +
  theme_minimal()
dev.off()

row_median <- rowMedians(as.matrix(processed_data))

hist(row_median,
     breaks = 100,
     freq = FALSE,
     main = "Median Intensity Distribution")

threshold <- 3.5 
abline(v = threshold, col = "black", lwd = 2) 

indx <- row_median > threshold 
filtered_data <- processed_data[indx, ] 

colnames(filtered_data) <- rownames(phenotype_data)

processed_data <- filtered_data 


class(phenotype_data$source_name_ch1) 

groups <- factor(phenotype_data$source_name_ch1,
                 levels = c("gastric mucosa", "gastric adenocarcinoma"),
                 label = c("normal", "cancer"))

class(groups)
levels(groups)
