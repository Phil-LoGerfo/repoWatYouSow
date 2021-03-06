 
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
 
########

 # Load the packages required for the program
 library(png)
 #library(ggplot2)

 
 # !!Make sure to check the name of the directory path!!
 pngPathName <- "~/Test_set_Lg/Test_Set_Lg"

 # Make a list of the PNG file names with the paths included
 pngPaths <- dir(path =pngPathName, pattern = "*.png", full.names = TRUE, recursive = TRUE)
 
 # Make a list of the PNG file names without the paths
 pngNames <- dir(path =pngPathName, pattern = "*.png", full.names = FALSE, recursive = TRUE)

# !!Make sure to check the name of the directory path!!
 csvPathName <-	"~/Test_set_Lg/Test_Set_Lg"
 
 # Make a list of the CSV file names with the paths included
 csvPaths <- dir(path =csvPathName, pattern = "*areas.csv", full.names = TRUE, recursive = TRUE)
 
 # Make a list of the CSV file names without the paths
 csvNames <- dir(path =csvPathName, pattern = "*areas.csv", full.names = FALSE, recursive = TRUE)

########

pixelCount <- NULL
totalVol <- NULL
microVoid <- NULL
primeVoid <- NULL
totalVoids <- NULL
primeAvg = NULL
microAvg = NULL
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
  if (dim(pf[1]) > 0) {
    
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
      tempMicro <- which(fpf < 22)
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
      tempPrime <- which(fpf >= 22)
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
  print(paste(i, " of ", length(csvNames), sep = ""))
  
}
###################

# Add the name of data file to list pnames   
 # tempName <- csvNames[i]
 # pnames <- c(pnames, tempName)

#***



pdata <- data.frame(row.names = csvNames, csvNames = csvNames, Total_Volumes = totalVol, Total_Voids = totalVoids, Total_Mean = totalAvg,
                    Primary_Voids = primeVoid, Primary_Mean = primeAvg, 
                    Micro_Voids = microVoid, Micro_Mean = microAvg) 


# !!Make sure to check the name of the file that is written!!
nameOfFile <- "pVolsData.csv"

write.table(pdata, nameOfFile, sep = ",", row.names = FALSE)




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



