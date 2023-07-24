#--------------------------------------------------------------
# Packages 
#--------------------------------------------------------------

# List of packages
packages <- c("tidyverse",    #Data cleaning and plotting 
              "glmnet",       #Lasso, ridge
              "rpart",        #Fitting a tree
              "rpart.plot",   #Plotting a tree 
              "gbm",          #Boosting
              "pROC"          #ROC and model evaluation
) 


# Function to install and load packages
install_and_load_packages <- function(packages) {
  for(package in packages) {
    # Check if the package is installed
    if (!require(package, character.only = TRUE)) {
      # Install the package if it's not already installed
      install.packages(package, repos = "http://cran.us.r-project.org")
      # Load the package
      library(package, character.only = TRUE)
    }
  }
}

# Use the function to install and load packages
install_and_load_packages(packages)