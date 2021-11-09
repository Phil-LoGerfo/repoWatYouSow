##########################################
# Program to read from a directory individual CSV files, containing values of area units, 
# and corresponding PNG files from a directory and write new CSV files back to the 
# directory with values that have been converted to volume units. 
# 
# The program calculates void volumes, measured in microliters, by standardizing
# the void area sizes, measured in pixel counts, to the size of the image of the filter
# paper, and then applying the formula to convert area size to volume size. 
# The void area sizes are contained in CSV files and the images of the filters are in 
# PNG files. 
#   
#########################################
 # Load the packages required for the program
library(png)
library(tidyverse)
 
 # !!Make sure to check the name of the directory path!!
 #pngPathName <- "~/Test_set_Lg/Test_Set_Lg"

 trunk <- "~/150 Weeks"

 # Make a list of the PNG file names with the paths included
 pngPaths <- dir(path =trunk, pattern = "*.png", full.names = TRUE, recursive = TRUE)
 
 # Make a list of the PNG file names without the paths
 #pngNames <- dir(path =trunk, pattern = "*.png", full.names = FALSE, recursive = TRUE)

# !!Make sure to check the name of the directory path!!
# csvPathName <-	"~/Test_set_Lg/Test_Set_Lg"
 
 # Make a list of the CSV file names with the paths included
 csvPaths <- dir(path =trunk, pattern = "*areas.csv", full.names = TRUE, recursive = TRUE)
 
 # Make a list of the CSV file names without the paths
 #csvNames <- dir(path =trunk, pattern = "*areas.csv", full.names = FALSE, recursive = TRUE)

########
########


pixelCount <- NULL
stdArea <- NULL
voidVol <- NULL

for (i in 1:length(csvPaths)) {


  
  # Read in the PNG file that corresponds with the CSV file
  pp <- readPNG(pngPaths[i])
  # estimate the pixel area of the cage floor
  temppixelCount <- length(which(pp > .05))
  pixelCount <- c(pixelCount, temppixelCount)
  #convert pixels to area
  stdArea <- temppixelCount/(265*111)
  
  # Read in the CSV file 
  pf <- read.delim(csvPaths[i], sep = ",", header = TRUE, row.names = 1)
  
  # make sure there are pee events
  if (length(pf[,1]) > 0) {
    #calculate volume 
    voidVol <- (pf[1]/stdArea)*0.283		
    # Here would be a good place to retain the stdArea values, by binding them to the voidVol data frame. 
    voidVol <- data.frame(ID = rownames(pf), Volume = voidVol)
	  colnames(voidVol) <- c("ID", "Volume")
    newFileName <-  paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(voidVol, newFileName , sep = ',', row.names = FALSE)
  } 
  else {
    newFileName <- paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(pf, newFileName , sep = ',')
  }
  voidVol <- NULL
  if (i %% 5 == 0)
  print(paste(i, " of ", length(csvPaths), sep = ""))
}





