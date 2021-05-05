
filePaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
fileNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)
pf = lapply(filePaths,sep = ",", header = TRUE, row.names =1, read.delim)
dim(pf[[1]])
names(pf) <- fileNames
#fileNames <- substring(temp,0)
#names(myfiles) <- fileNames 