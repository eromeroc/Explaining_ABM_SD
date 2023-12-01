#################################################
#          DATA PREPROCESSING FUNCTIONS          #
#################################################

# Author: Elena Romero
# Date: Nov 2023
# Description: This script contains the necessary functions for data preprocessing


#' Select events from the Action.State column
#'
#' This function filters rows in the input data table based on the specified
#' events in the Action.State column.
#'
#' @param data A data table containing the original data.
#' @param selected_events A character vector of events to select.
#' @return A data table with filtered rows.
select_events <- function(data, select.events){
  
  # Select events based on a list of event names
  str.select <- paste(select.events, collapse="|")
  data <- data[like(data$Action.State, str.select)]
  
  # Remove extra white spaces in the Action.State column
  data[, ':='(Action.State = gsub('\\s+', '', data$Action.State))]
  
  return(data)
}


#' Select brand
#'
#' This function filters rows in the input data table based on the specified brand.
#'
#' @param data A data table containing the original data.
#' @param brand An integer value representing the brand to select.
#' @return A data table with filtered rows.
select_brand <- function(data, brand){

  data <- data[Brand == paste0("Brand ", brand)]
  data[,':='(Brand=NULL)]    
    
  return(data)
}


#' Discretize Bought column
#'
#' This function discretizes the Bought column (Sales class) based on the frequency of values,
#' while keeping zero values separate.
#'
#' @param data A data table containing the original data.
#' @param ncat.class The number of classes for discretization.
#' @return A list containing the modified data table and category labels.
build_class <- function(data, ncat.class){
  
  if(ncat.class > 0){
    
    y <- data[,.(Sales = Bought, Agent.ID)]
    y[Sales > 0, SalesD := discretize(Sales, method = 'frequency', breaks = ncat.class-1)]
    str.cats <- c("Sales", sort(unique(as.character(y[!is.na(SalesD)]$SalesD))))
    y[Sales > 0, Sales := as.numeric(SalesD)]
    y[, SalesD := NULL]
    
  }else{
    str.cats <- NULL
  }
  
  return(list(y = y, str.cats = str.cats))
}

#' Discretize columns based on median 
#'
#' This function discretizes columns in the input data table based on the median 
#' of values, while keeping 0 values separate.
#'
#' @param table A data table containing the original data.
#' @param table.cats A data table to store category labels.
#' @return A list containing the modified data table and category labels.

discretize_median <- function(table, table.cats){
  
  data <- copy(table) 
  cols <- setdiff(names(data), "Sales")  
  
  for(j in cols){
    jcol <- data[[j]][data[[j]] > 0]
    nvalues <- uniqueN(jcol)
    
    # Discretize based on frequency, separating 0 values
    if(nvalues > 2){
      
      med <- median(jcol) 
      cats <- c(j, paste0("[",min(jcol),",", med,")"), paste0("[",med,",",max(jcol),"]"))
      expr <- paste0("data[",j," > 0,':='(",j," = ifelse(",j," >= med, 2, 1))]")  
      eval(parse(text = expr)) 

    }else{

      cats <- c(j, sort(unique(data[[j]])))
      expr <- paste0("data[",j," > 0,':='(",j," = as.numeric(as.factor(",j,")))]") 
      eval(parse(text = expr)) 
    }
    table.cats <- rbind(table.cats, list.cbind(cats), fill = T)
  }
  return(list(data = data, table.cats = table.cats))  
}


#' Write ARFF files with integer attribute values
#'
#' This function writes data to two ARFF files, one for training and one for testing,
#' with integer attribute values.
#'
#' @param data The original data table
#' @param train The training data subset.
#' @param test The testing data subset.
#' @param fname The base filename for the ARFF files.
write_arff_int <- function(data, train, test, fname){
  
  ftrain <- paste0(fname,"-int-tra.dat")
  ftest <- paste0(fname,"-int-tst.dat")
  
  sink(ftrain)
  cat("@relation stats")
  inputs <- setdiff(names(train), "Sales")
  for(i in inputs){
    cat("\n@attribute", i, paste0("{",paste0(sort(unique(data[[i]])), collapse = ","),"}")) 
  }
  cat("\n@attribute Sales {",paste0(sort(unique(data$Sales)), collapse = ","),"}")
  cat("\n@inputs", paste0(inputs, collapse=","))
  cat("\n@outputs Sales")
  cat("\n@data\n")
  sink()
  
  file.copy(ftrain, ftest, overwrite = T)
  
  write.table(train, file = ftrain, sep = ",", quote = F, row.names = F, col.names = F, append = T)
  write.table(test, file = ftest, sep = ",", quote = F, row.names = F, col.names = F, append = T)
  
  
}

#' Write ARFF files with real attribute values
#'
#' This function writes data to two ARFF files, one for training and one for testing,
#' with real (floating-point) attribute values.
#'
#' @param data The original data table
#' @param train The training data subset.
#' @param test The testing data subset.
#' @param fname The base filename for the ARFF files.
write_arff_real <- function(data, train, test, fname){
  
  ftrain <- paste0(fname,"-real-tra.dat")
  ftest <- paste0(fname,"-real-tst.dat")
  
  sink(ftrain)
  cat("@relation stats")
  inputs <- setdiff(names(train), "Sales")
  for(i in inputs){
    cat("\n@attribute", i, paste0("real [",min(data[,..i]),",",max(data[,..i]),"]")) 
  }
  cat("\n@attribute Sales {",paste0(sort(unique(data$Sales)), collapse = ","),"}")
  cat("\n@inputs", paste0(inputs, collapse=","))
  cat("\n@outputs Sales")
  cat("\n@data\n")
  sink()
  
  file.copy(ftrain, ftest, overwrite = T)
  
  write.table(train, file = ftrain, sep = ",", quote = F, row.names = F, col.names = F, append = T)
  write.table(test, file = ftest, sep = ",", quote = F, row.names = F, col.names = F, append = T)    

  
}

#' Write a readme file with experiment information
#'
#' This function writes information about the experiment to a readme file.
#'
#' @param freadme The filename for the readme file.
#' @param str The information to be written to the readme file.
write_readme <- function(freadme, str){
  sink(freadme, append = T)
  print(paste0(Sys.time(), str))
  sink()  
}



