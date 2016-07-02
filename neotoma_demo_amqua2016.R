#Neotoma Workshop
#AmQua, July 2, 2016
#Jack Williams, Simon Goring, and Eric Grimm
#
#This script is available at:  https://github.com/IceAgeEcologist/NeotomaWorkshops
#

++++++++++++++
#Install neotoma package from GitHub repository
install.packages("devtools")
library(devtools)
install.packages("neotoma")
library(neotoma)

#Get Site Information
#get_site returns a data frame with information about 
#Note use of % as wildcard operator
marion.meta.site <- get_site(sitename = 'Marion%')
marion.meta.site

#Get Dataset Information
#get_dataset returns a list of datasets containing the metadata for each dataset
#we can pass output from get_site to get_dataset
marion.meta.data  <- get_dataset(marion.meta.site)
#Let's look at the metadata returned for Marion Lake - in  this case the first of two sites.
marion.meta.data[[1]]

#Get Dataset
#get_download returns a list which stores a list download objects - one for each retrieved dataset.
#Each download object contains a suite of data for the samples in that dataset
marion.data <- get_download(marion.meta.site)

#Within the download object, sample.meta stores the core depth and age information for that dataset
#We just want to look at the first few lines, so are  using the head function
head(marion.data[[1]]$sample.meta)

#taxon.list stores a list of taxa found  in the  dataset
head(marion.data[[1]]$taxon.list)

#counts stores the the counts, presence/absence data, or percentage data for each taxon for each sample
head(marion.data[[1]]$counts)

#lab.data stores any associated  laboratory measurements in the dataset
#(no data for marion...)
head(marion.data[[1]]$lab.data)

#Making a quick plot of Alnus abundances at Marion Lake, using the analogue package 
#to calculate pollen percentages
#load analogue
install.packages("analogue")
library("analogue")

#Obtain all the pollen counts for Alnus from Marion Lake
marion.alnus <- tran(x = marion.data[[1]]$counts, method = 'percent')[,'Alnus']

#Build a dataframe containing the pollen counts and sample ages
alnus.df <- data.frame(alnus = marion.alnus,
                       ages  = marion.data[[1]]$sample.meta$age,
                       site = rep('Marion', length(marion.alnus)))

#Plot the  data
plot(alnus ~ ages, data = alnus.df, col = alnus.df$site, pch = 19,
     xlab = 'Radiocarbon Years Before Present', ylab = 'Percent Alnus')