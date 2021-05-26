library(png)

#### Read in the CSV and PNG file Names and Paths

pngPaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = TRUE, recursive = TRUE)
pngNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = FALSE, recursive = TRUE)


csvPaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*areas.csv", full.names = TRUE, recursive = TRUE)
csvNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*areas.csv", full.names = FALSE, recursive = TRUE)


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
  if (dim(pf[1]) > 0) {
    #calculate volume 
    voidVol <- (pf[1]/stdArea)*0.283		
    voidVol <- cbind(rownames(pf), voidVol)
    colnames(voidVol) <- c("ID","Volumes")
    newFileName <-  paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(voidVol, newFileName , sep = ',', row.names = FALSE)
  }
  else {
    newFileName <- paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(pf, newFileName , sep = ',')
  }
  if (i %% 5 == 0)
  print(paste(i, " of ", length(csvNames), sep = ""))
}





