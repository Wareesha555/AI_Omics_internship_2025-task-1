# using if to check cholestrol level
cholesterol <- 230

if (cholesterol > 240) {
  print("High Cholesterol")
}

# using if else to check blood pressure
Systolic_bp <- 130

if (Systolic_bp < 120) {
  print("Blood Pressure is normal")
} else {
  print("Blood Pressure is high")
}

patient_info <- read.csv(file.choose())
metadata <- read.csv(file.choose())

patient_copy <- patient_info
metadata_copy <- metadata

factor_cols_patient <- c("gender", "diagnosis","smoker")
factor_cols_metadata <- c("gender","height")

# conversion into factors through for loop
for (col in factor_cols_patient) {
  patient_copy[[col]] <- as.factor(patient_copy[[col]])
}


for (col in factor_cols_metadata) {
  metadata_copy[[col]] <- as.factor(metadata_copy[[col]])
}

# Converting factos to numeric codes
binary_cols <- c("smoker")   

for (col in binary_cols) {
  patient_copy[[col]] <- ifelse(patient_copy[[col]] == "Yes", 1, 0)
}

str(patient_info)    
str(patient_copy)







































