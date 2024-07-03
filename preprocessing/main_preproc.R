#################################################
#   Main Preprocessing Script                   #
#################################################

# Author: Elena Romero
# Date: Nov 2023
# Description: This script performs data preprocessing for adapting agent-based model output 
#              to subgroup discovery algorithms input.
#              It loads data, applies preprocessing steps, and generates output files.
#              This script is an integral part of the data preparation process.



# Load required functions
source("./preprocessing/libraries.R")
source("./preprocessing/function_preproc.R")


# Read parameters from command line
args <- commandArgs(trailingOnly = TRUE)

# Check if parameters were provided
if (length(args) >= 2) {
  
  exp <- args[1]
  ncat.class <- as.numeric(args[2])
  
  if(length(args) == 3){
    include.median <- as.logical(args[3])
  }else{
    include.median <- F
  }
  
  print(paste("Parameter 1:", exp))
  print(paste("Parameter 2:", ncat.class))
  print(paste("Parameter 3:", include.median))
  
} else {
  print("No parameters provided.")
}

# Parameters

#exp <- 1         
#ncat.class <- 2 
#include.median <- T # Indicates whether the median is included in the lowest class
ini.week <- 0
fin.week <- 156
brand <- 0


fraw <- paste0("./data/raw/agents_log")
fpath <- paste0("./data/in/Exp", exp,"/")
freadme <- paste0(fpath,"exp",exp,"_readme.txt")
fname <- paste0(fpath, "b", brand)


# Check if the directory exists, create it if not
if (!dir.exists(fpath)) {
  dir.create(fpath, recursive = TRUE)
  cat("Carpeta creada:", fpath, "\n")
} else {
  cat("La carpeta ya existe:", fpath, "\n")
}

# Read and aggregate data files
dt_parts <- list()

for (i in 1:5) {
  file_name <- paste0(fraw, "_part_", i, ".csv")
  dt_parts[[i]] <- read.csv(file_name)
}

data <- rbindlist(dt_parts)
table.cats <- data.table()  


# Calculate the sum of columns for each row
cols <- paste("W.",ini.week:fin.week, sep = "")
data[, sum := rowSums(.SD), .SDcols = cols]

data.proc <- dcast(data, Agent.ID ~ Action.State, value.var = "sum")  


# DISCRETIZE TARGET VARIABLE

if(ncat.class == 2){
  data.proc[,':='(Sales = ifelse(Bought > 0, 1, 0))]  
  table.cats <- data.table(list.cbind(
                          c("Sales", paste0("[",min(data.proc[Bought>0]$Bought),",",max(data.proc$Bought),"]"))
                          ))
  
} else if(ncat.class == 3 & !include.median){
  
  data.proc[Bought >= 2,':='(Sales = 2)]
  data.proc[Bought > 0 & Bought < 2,':='(Sales = 1)]
  data.proc[Bought == 0,':='(Sales = 0)]
  
  table.cats <- data.table(list.cbind(c("Sales", paste0("[1,2)"), paste0("[2,20]"))))
  
} else if(ncat.class == 3 & include.median){

  data.proc[Bought > 2,':='(Sales = 2)]
  data.proc[Bought > 0 & Bought <= 2,':='(Sales = 1)]
  data.proc[Bought == 0,':='(Sales = 0)] 
  
  table.cats <- data.table(list.cbind(c("Sales", paste0("[1,2]"), paste0("(2,20]"))))
  
  
} else {
  y <- build_class(data.proc, ncat.class)
  data.proc <- data.proc[y$y,, on="Agent.ID"]  
  table.cats <- data.table(list.cbind(y$str.cats))                                                
}

data.proc[,':='(Bought = NULL, Agent.ID = NULL)]

# Remove columns with a single value
selected.cols <- which(lapply(data.proc, function(x) uniqueN(x)) > 1)
data.proc <- data.proc[,..selected.cols]

# DISCRETIZE input variables
data.disc <- discretize_median(data.proc, table.cats)
table.cats <- data.disc$table.cats
data.disc <- data.disc$data

# Split into TRAIN and TEST
set.seed(0)
intrain <- createDataPartition(y=data.proc[,.I], p=0.8, list=FALSE)

# WRITE FILES

# Input variables without discretization
write_arff_real(data.proc, data.proc[intrain,], data.proc[-intrain,], fname)
write.table(data.proc, file = paste0(fname,"-real.csv"), sep = ",",
            quote = F, row.names = F, col.names = T, append = F)


# Input variables with discretization
write_arff_int(data.disc, data.disc[intrain,], data.disc[-intrain,], fname)
write.table(data.disc, file = paste0(fname,"-int.csv"), sep = ",",
            quote = F, row.names = F, col.names = T, append = F)


# Create a readme file
events <- setdiff(names(data.proc), c("Agent.ID", "Sales"))
str.readme <- paste(" Experimento", exp, "- Nclases", ncat.class,
                    "- Semanas",ini.week,"-", fin.week, "- Eventos:",
                    paste0(events,collapse= ","))

write_readme(paste0(fpath,"exp",exp,"_readme.txt"), str.readme)
write.table(table.cats, file = paste0(fname,"-cats.txt"), sep = "\t",
            quote = F, row.names = F, col.names = F, append = F)


