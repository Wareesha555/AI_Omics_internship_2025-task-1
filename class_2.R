classify_gene <- function(logFC, padj) {
  if (logFC > 1 & padj < 0.05) {
    return("Upregulated")
  } else if (logFC < -1 & padj < 0.05) {
    return("Downregulated")
  } else {
    return("Not_Significant")
  }
}

install.packages("downloader")
library(downloader)

raw_url <- "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_1.csv"
file_name <- "DEG_Data_1.csv"

download(url = raw_url, destfile = file_name)
data <- read.csv("DEG_Data_1.csv")

raw_DEG_Data_2 <- "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_2.csv"
file_name <- "DEG_Data_2.csv"

download(url = raw_DEG_Data_2, destfile = file_name)
data_1 <- read.csv("DEG_Data_2.csv")

if(!dir.exists("Raw_Data")){
  dir.create("Raw_Data")
  cat("Raw_Data folder created.\n")
}

file.copy("DEG_Data_1.csv", "Raw_Data/DEG_Data_1.csv", overwrite = TRUE)
file.copy("DEG_Data_2.csv", "Raw_Data/DEG_Data_2.csv", overwrite = TRUE)

cat("Files have been copied into Raw_Data folder.\n")

list.files("Raw_Data")

input_dir <- "Raw_Data"    
output_dir <- "Results"

if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

files_to_process <- c("DEG_Data_1.csv", "DEG_Data_2.csv")

results_list <- list()

for (file_name in files_to_process) {
  cat("\nProcessing:", file_name, "\n")
  
  
  data <- read.csv(file.path(input_dir, file_name), header = TRUE)
  cat("File imported successfully.\n")
  
  missing_count <- sum(is.na(data$padj))
  cat("Missing values in padj:", missing_count, "\n")
  data$padj[is.na(data$padj)] <- 1
  
  status_vector <- c()
  for (i in 1:nrow(data)) {
    gene_status <- classify_gene(data$logFC[i], data$padj[i])
    status_vector <- c(status_vector, gene_status)
  }
  
  data$status <- status_vector
  cat("Classification done. Column 'status' added.\n")
  
  output_file <- file.path(output_dir, paste0("Processed_", file_name))
  write.csv(data, output_file, row.names = FALSE)
  cat("Results saved to:", output_file, "\n")
  
  results_list[[file_name]] <- data
  
  cat("\nSummary for", file_name, ":\n")
  print(table(data$status))
}

results_1 <- results_list[["DEGs_Data_1.csv"]]
results_2 <- results_list[["DEGs_Data_2.csv"]]






















