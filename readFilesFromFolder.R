temp <- dir(path ="~/TestFolder", full.names = TRUE, recursive = TRUE)
myfiles = lapply(temp,sep = ",", read.delim)
dim(myfiles[[1]])
fileNames <- substring(temp, 40)
names(myfiles) <- fileNames 