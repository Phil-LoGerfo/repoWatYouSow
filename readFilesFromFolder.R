 
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
 #csvPaths <- dir(path =trunk, pattern = "*.csv", full.names = TRUE, recursive = TRUE)
 
 csvPaths <- dir(path =trunk, pattern = "*areas.csv", full.names = TRUE, recursive = TRUE)
 # Make a list of the CSV file names without the paths
 #csvNames <- dir(path =trunk, pattern = "*areas.csv", full.names = FALSE, recursive = TRUE)

########
########

age <- NULL
diet <- NULL
group <- NULL
day <- NULL
imageNum <- NULL

pixelCount <- NULL
totalVol <- NULL
totalArea <- NULL
microVoid <- NULL
primeVoid <- NULL
totalVoids <- NULL
primeAvg <- NULL
microAvg <- NULL
totalAvg <- NULL
primeAvgArea <- NULL
microAvgArea <- NULL
totalAvgArea <- NULL



if (length(csvPaths) != length(pngPaths)) {
  print("Number of csv files: ", length(csvPaths), ". Number of png files: ", length(pngPaths), 
        ". Must have equal number of files!")
} else {

  
  for (i in 1:length(csvPaths)) {

	
    branches <- str_split(csvPaths[i],"/")
  
    age <- rbind(age, branches[[1]][5])
    diet <- rbind(diet, branches[[1]][6])
    group <- rbind(group, branches[[1]][7])
    day <- rbind(day, branches[[1]][8])
    imageNum <- rbind(imageNum, branches[[1]][10])
  
    # Read in the PNG file that corresponds with the CSV file
    pp <- readPNG(pngPaths[i])
    # estimate the pixel area of the cage floor
    temppixelCount <- length(which(pp > .05))
   # pixelCount <- c(pixelCount, temppixelCount)
  
    # Read in the CSV file 
    pf <- read.delim(csvPaths[i], sep = ",", header = TRUE, row.names = 1)
  
    # make sure there are pee events
    if (length(pf[,1]) > 0) {
    
      #convert pixels area and standardize area
      stdArea <- temppixelCount/(265*111)
      
      #make a list of standardized void areas
      parea <- pf[1]/stdArea    
      #calculate volume 
      pvol <- parea*0.283
      
      # Here would be a good place to retain the stdArea values, by binding them to the pvol values..
      # filter out very small volumes
      filter <- which(pvol > 2)
    
      # make a list of void volumes and areas for file i
      fpf <- pvol[filter,1]
      fpfa <- parea[filter,1]
      # check again for pee events after filtering
      if (length(fpf) > 0) {
      
        # count the number of total voids
        tempEvent <- length(fpf)
        #add the total void count from that file to list totalVoids
        totalVoids <- c(totalVoids, tempEvent)
      
        # count microvoids
        tempMicro <- which(fpf < 22)
        if (length(tempMicro > 0)) {
          # add the total micro void count to list microv
          microVoid <- c(microVoid, length(tempMicro))
          # makes a list of micro void volumes and area only
          mfpf <- fpf[tempMicro]
          mfpfa <- fpfa[tempMicro]
          # calculate the mean of micro voids
          tempMicroAvg <- mean(mfpf)
          tempMicroAvgArea <- mean(mfpfa)
          # add the mean of micro voids to list microAvg
          microAvg <- c(microAvg, tempMicroAvg)
          microAvgArea <- c(microAvgArea, tempMicroAvgArea)
        } else {
            # if there are no micro voids
            microVoid <- c(microVoid, 0)
            microAvg <- c(microAvg, 0)
            microAvgArea <- c(microAvgArea, 0)
          }
      
        # count primaryvoids
        tempPrime <- which(fpf >= 22)
        if (length(tempPrime > 0)) {
          # add the total primary void count to list primeVoid
          primeVoid <- c(primeVoid, length(tempPrime))
          # makes a list of primary voids only
          pfpf <- fpf[tempPrime]
          pfpfa <- fpfa[tempPrime]
          # calculate the mean of primary voids
          tempPrimeAvg <- mean(pfpf)
          tempPrimeAvgArea <- mean(pfpfa)
          # add the mean of primary voids to list primeAvg
          primeAvg <- c(primeAvg, tempPrimeAvg)
          primeAvgArea <- c(primeAvgArea, tempPrimeAvgArea)
        
        } else {
            # if there are no primary voids
            primeVoid <- c(primeVoid, 0)
            primeAvg <- c(primeAvg, 0)
            primeAvgArea <- c(primeAvgArea, 0)
          }
      
        # sum the total area of all pee events   
        tempv <- sum(fpf)
        totalVol <- c(totalVol, tempv)
        
        tempa <- sum(fpfa)
        totalArea <- c(totalArea, tempa)
      
        # calculate the mean of all voids
        tempAvg <- mean(fpf)
        totalAvg <- c(totalAvg, tempAvg)
        tempAvgArea <- mean(fpfa)
        totalAvgArea <- c(totalAvgArea, tempAvgArea)
        
      } else {
          # If there are no micro or primary voids, but some voids < 1500 in area
          microVoid <- c(microVoid, 0)
          microAvg <- c(microAvg, 0) 
          microAvgArea <- c(microAvgArea, 0) 
          primeVoid <- c(primeVoid, 0)
          primeAvg <- c(primeAvg, 0)
          primeAvgArea <- c(primeAvgArea, 0)
          totalVol <- c(totalVol, 0)
          totalArea <- c(totalArea, 0)
          totalVoids <- c(totalVoids,  0)
          totalAvg <- c(totalAvg, 0)
          totalAvgArea <- c(totalAvgArea, 0)
          
        }
    
    } else {
    
        microVoid <- c(microVoid, 0)
        microAvg <- c(microAvg, 0)
        microAvgArea <- c(microAvgArea, 0) 
        primeVoid <- c(primeVoid, 0)
        primeAvg <- c(primeAvg, 0)
        primeAvgArea <- c(primeAvgArea, 0)
        totalVol <- c(totalVol, 0)
        totalArea <- c(totalArea, 0)
        totalVoids <- c(totalVoids, 0)
        totalAvg <- c(totalAvg, 0)
        totalAvgArea <- c(totalAvgArea, 0)
        
       
       
       
    } 
    
    
  
    if (i %% 5 == 0)
      print(paste(i, " of ", length(csvPaths), sep = ""))
  
  }



  pdata <- data.frame(row.names = imageNum, Image = imageNum, Total_Volumes = totalVol,Total_Areas = totalArea, Total_Voids = totalVoids, Total_Mean = totalAvg,
                    Total_Mean_Area = totalAvgArea, Primary_Voids = primeVoid, Primary_Mean = primeAvg, Primary_Mean_Area = primeAvgArea, 
                    Micro_Voids = microVoid, Micro_Mean = microAvg, Micro_Mean_Area = microAvgArea, Age = age, Diet = diet, Group = group, Day = day) 


  # !!Make sure to check the name of the file that is written!!
  nameOfFile <- "VoidDataSummaryWithAREA.csv"

  write.table(pdata, nameOfFile, sep = ",", row.names = FALSE)

}


######### END ############### END ################## END ################ END ############





















###################

# Add the name of data file to list pnames   
 # tempName <- csvNames[i]
 # pnames <- c(pnames, tempName)

#***


#######

#~/150 Weeks/20/DO-20-1049-1094/Day 2/tifs_Predic

filePathNameLength <- nchar("~/150 Weeks/20/DO-20-1049-1094/Day 2/tifs_Predic")
branch2length <- nchar("DO-20-1049-1094")
#15
trunk <- "~/150 Weeks"
branch1 <- c("1D","2D","20","40","AL")

folderPath <- paste(trunk, branch1, sep, "/")
folderPath
#branch2 <- c("","")

currFolderPath <- dir(path = trunk, full.names = TRUE, recursive = FALSE)

currFolderPath <- dir(path = currFolderPath[1], full.names = TRUE, recursive = FALSE)

currFolderPath <- dir(path = currFolderPath[1], full.names = TRUE, recursive = FALSE)

currFolderPath <- dir(path = currFolderPath[1], full.names = TRUE, recursive = FALSE)

csvAreasFilePath <- dir(path = currFolderPath[1], pattern = "areas.csv", full.names = TRUE, recursive = FALSE)

pngFilePath <- dir(path = currFolderPath[1], pattern = ".png", full.names = TRUE, recursive = FALSE)
 
#######################################

csvAreasFilePath <- dir(path = trunk, pattern = "areas.csv", full.names = TRUE, recursive = TRUE)


#######################################


pic <-ggplot(data.frame(Area= pdata$Total_Area, Voids=pdata$Total_Voids)) +
geom_point(aes(Area,Voids)) +
geom_smooth(mapping = aes(Area,Voids), method="lm", se=FALSE, color = "red")
plot(pic)
ggsave("AreaVoids.png")



#names(psums) <- pnames
#ordpsums <- order(psums)
#ordpsums <- psums[ordpsums]
#plot(ordpsums)
#psumsdata <- as.data.frame(ordpsums, 
#row.names = names(ordpsums))
#colnames(psumsdata)  <- "Ordered Pee Sums"


# Next: sum the number of pee events



# pool <- rbind(c(tempName, tempSum))



###### pca tests


#frm <- NULL
#for (i in 1:10)
#frm <- cbind(frm, runif(20))
#dow_pca <- princomp(frm)
#screeplot(dow_pca)
#t(eigen(cov(frm))$vectors)[1:5,]*(-1)

csv80 <- NULL
for (i in 1:length(csvPaths)) {
	temp <- substring(csvPaths[i],1,80)
	csv80 <- rbind(csv80, temp)
	}



png80 <- NULL
for (i in 1:length(pngPaths)) {
	temp <- substring(pngPaths[i],1,80)
	png80<- rbind(png80, temp)
	}






