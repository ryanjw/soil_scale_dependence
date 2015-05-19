# reading in an otu table that has had 6 columns of metadata added to it
# dataset<-read.csv("~/Downloads/ITS_unrar_aggs_only.csv",header=T,check.names=F)
# head(dataset[,1:10])

# reading in metadata that describes aggregate distribution which is represented as a proportion
# meta<-read.csv("~/Google Drive/COBS_16S_biodiversity/KBase_MGRast_Metadata_9May2013_EMB.csv")


# having to change some factors for appropriate matches when merging
# levels(meta$Date)<-c("12-Jul","12-Oct")

library(reshape2)

# melting dataset for merging

dataset_melt<-melt(dataset, id=c("row_sum","SampleName","SoilFrac","Date","block","Crop"))
names(dataset_melt)[5]<-"Block"
head(meta[,1:10])
head(dataset_melt)
names(meta)
# merging metadata with melted data, but only the necessary columns
merged<-merge(dataset_melt, meta[,c(3:6,26)],by=c("Date","Block","Crop","SoilFrac"))

# since the aggregate distribution is a proportion, it can be multiplied by the number of reads. Create a new variable called prop_value
merged$prop_value<-merged$value*merged$prop_agg_fraction

# now we are going to cast a new data frame with no aggregates as we are summing to create a new variable called "wsprop"

wsprop_dataset<-dcast(merged, SampleName+Date+Block+Crop~variable, value.var="prop_value",fun.aggregate=sum)
