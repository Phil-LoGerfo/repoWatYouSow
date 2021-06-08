 
##########################################
# Program to summarize data from a directory containing individual CSV files and 
# corresponding PNG files into one data file. 
# The program calculates void volumes, measured in microliters, by standardizing
# the void area sizes, measured in pixel counts, to the size of the image of the filter
# paper, and then applying the formula to convert area size to volume size. 
# The void area sizes are contained in CSV files and the images of the filters are in 
# PNG files. 
# For each CSV file and its corresponding PNG file, the following values are returned: 
# Total Volume, Number of Micro Voids, Number of Primary Voids, Mean Total Void Volume 
# Mean Micro Void Volume, Mean Primary Void Volume. These values are added to a data frame,
# and the corresponding CSV file names are used as the rownames for the data frame.   
#########################################
 
 # Load the packages required for the program
library(png)
 
 # !!Make sure the folderName is the main folder for the data!!
	folderName <- "~/Test_set_Lg/Test_Set_Lg"

 # Make a list of the PNG file names with the paths included
 pngPaths <- dir(path =folderName, pattern = "*.png", full.names = TRUE, recursive = FALSE)

  
 # Make a list of the CSV file names with the paths included
 csvPaths <- dir(path =folderName, pattern = "*areas.csv", full.names = TRUE, recursive = FALSE)
 csvNames <- dir(path =folderName, pattern = "*areas.csv", full.names = FALSE, recursive = FALSE)
 
 
########
########

## !! Make sure to check the threshold is correct !! ##
threshold <- 22

# Variables that will be used later in the program


imageNum <- NULL
pixelCount <- NULL
totalVol <- NULL
microVoid <- NULL
primeVoid <- NULL
totalVoids <- NULL
primeAvg <- NULL
microAvg <- NULL
totalAvg <- NULL


for (i in 1:length(csvPaths)) {

  
  # Read in the PNG file that corresponds with the CSV file
  pp <- readPNG(pngPaths[i])
  # estimate the pixel area of the cage floor
  temppixelCount <- length(which(pp > .05))
  pixelCount <- c(pixelCount, temppixelCount)
  
  # Read in the CSV file 
  pf <- read.delim(csvPaths[i], sep = ",", header = TRUE, row.names = 1)
  
  # make sure there are pee events
  if (length(pf[,1]) > 0) {
    
    #convert pixels to area
    stdArea <- temppixelCount/(265*111)
    
    #calculate volume 
    pvol <- (pf[1]/stdArea)*0.283
    
    # filter out very small volumes
    filter <- which(pvol > 2)
    
    # make a list of voids for file i
    fpf <- pvol[filter,1]
    
    # check again for pee events after filtering
    if (length(fpf) > 0) {
      
      # count the number of total voids
      tempEvent <- length(fpf)
      #add the total void count from that file to list totalVoids
      totalVoids <- c(totalVoids, tempEvent)
      
      # count microvoids
      tempMicro <- which(fpf < threshold)
      if (length(tempMicro > 0)) {
        # add the total micro void count to list microv
        microVoid <- c(microVoid, length(tempMicro))
        # makes a list of micro voids only
        mfpf <- fpf[tempMicro]
        # calculate the mean of micro voids
        tempMicro <- mean(mfpf)
        # add the mean of micro voids to list microAvg
        microAvg <- c(microAvg, tempMicro)
      }
      else {
        # if there are no micro voids
        microVoid <- c(microVoid, 0)
        microAvg = c(microAvg, 0)
      }
      
      # count primaryvoids
      tempPrime <- which(fpf >= threshold)
      if (length(tempPrime > 0)) {
        # add the total primary void count to list primeVoid
        primeVoid <- c(primeVoid, length(tempPrime))
        # makes a list of primary voids only
        pfpf <- fpf[tempPrime]
        # calculate the mean of primary voids
        tempPrimeAvg <- mean(pfpf)
        # add the mean of primary voids to list primeAvg
        primeAvg <- c(primeAvg, tempPrimeAvg)
        
      }
      else {
        # if there are no primary voids
        primeVoid <- c(primeVoid, 0)
        primeAvg = c(primeAvg, 0)
      }
      
      # sum the total area of all pee events   
      tempa <- sum(fpf)
      totalVol <- c(totalVol, tempa)
      
      # calculate the mean of all voids
      tempAvg <- mean(fpf)
      totalAvg <- c(totalAvg, tempAvg)
    }
    
    else {
      # If there are no micro or primary voids, but some voids < 1500 in area
      microVoid <- c(microVoid, 0)
      primeVoid <- c(primeVoid, 0)
      primeAvg = c(primeAvg, 0)
      microAvg = c(microAvg, 0) 
      totalVol <- c(totalVol, 0)
      totalVoids <- c(totalVoids,  0)
      totalAvg <- c(totalAvg, 0)
      
    }
    
  }
  else {
    
    totalVol <- c(totalVol, 0)
    totalVoids <- c(totalVoids, 0)
    microVoid <- c(microVoid, 0)
    primeVoid <- c(primeVoid, 0)
    totalAvg <- c(totalAvg, 0)
    primeAvg = c(primeAvg, 0)
    microAvg = c(microAvg, 0)
    
  } 
  
  if (i %% 5 == 0)
  print(paste(i, " of ", length(csvPaths), sep = ""))
  
}




pdata <- data.frame(row.names = csvNames, Image = csvNames, Total_Volumes = totalVol, Total_Voids = totalVoids, Total_Mean = totalAvg,
                    Primary_Voids = primeVoid, Primary_Mean = primeAvg, 
                    Micro_Voids = microVoid, Micro_Mean = microAvg) 


# !!Make sure to check the name of the file that is written!!
nameOfFile <- "VoidDataSummary.csv"

write.table(pdata, paste(folderName, nameOfFile, sep = "/"), sep = ",", row.names = FALSE)









######### END ############### END ################## END ################ END ############







