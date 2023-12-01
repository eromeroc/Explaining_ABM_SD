#################################################
#   Load libraries (and install if not installed)                  
#################################################


# Load libraries
libraries_to_load <- c("data.table", "caret", "rlist", "arules")


# Install and load each library
for (lib in libraries_to_load) {
  if (!requireNamespace(lib, quietly = TRUE)) {
    install.packages(lib, dependencies = TRUE)
  }
  library(lib, character.only = TRUE, quietly = TRUE)
}
