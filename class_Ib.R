dir.create("raw_data")
dir.create("clean_data")
dir.create("scripts")
dir.create("results")  
dir.create("plots")

patient_info <- read.csv(file.choose())
View(patient_info)
str(patient_info)

patient_info$age <- as.numeric(patient_info$age)
str(patient_info)

patient_info$gender_fac <- as.factor(patient_info$gender)
str(patient_info)

patient_info$smoker_fac <- as.factor(patient_info$smoker)
str(patient_info)

patient_info$smoker_binary <- ifelse(patient_info$smoker == "Yes", 1, 0)


write.csv(patient_info, "clean_data/patient_info_clean.csv")

save.image(file = "wareeshakhalid_Class_Ib_Assignment.RData")

load("wareeshakhalid_Class_Ib_Assignment.RData")







