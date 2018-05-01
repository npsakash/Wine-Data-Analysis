library(stringr)
library(jsonlite)
library(plyr)
library(psych)
library(ggthemes)
library(ggExtra)
library(tree)   # trees
library(randomForest) # randomForest
library(gbm) # gradient boosting
library(e1071)  # svm
library(glmnet) # ridge/lasso
library(pls)    # pls
library(ggplot2)
library(reshape2)

setwd('c:/Users/Neal/Documents/CofC/2018/MATH 441/Project/Wine/')
#developer_key = 'AIzaSyDk743GZpF2BUasrshdc7vxTp-uw8NRTgs'
wine.raw = read.csv('winemag-data-130k-v2.csv')

column_locations = c("country","province","region_1","region_2")
wine.clean = cleanWineData(wine.raw, c("country", "points", "price", "province", "region_1", "region_2", "variety", "winery", "taster_name","title"))
#unique_locations = getUniqueLocations(wine.clean, column_locations)
wine.merged = joinLatLngElev(wine.clean, column_locations,'region_1')  # merge lat lng values by province
wine<-wine.merged

# limit the data set to the most prevalent categorical values
variety_counts = count(wine$variety)
head(variety_counts)
summary(variety_counts)
province_counts = count(wine$province)

highest_freq_variety_counts = tail(variety_counts[order(variety_counts$freq),],20)$x
highest_freq_provinces = tail(province_counts[order(province_counts$freq),],20)$x

# wine with the most most prevalent varieties and provinces
wine = wine[(wine$variety %in% highest_freq_variety_counts) & (wine$province %in% highest_freq_provinces),]
wine = droplevels(wine) # hate R...so much hate

# subset by France
wine.france = wine[wine$country == 'France',]

#wine = wine[c("points","price","province","taster_name","review_length","elevation","abs_latitude")]

### Rename spelling errors and missing values ###
# Get levels and add new entries
tasterLevels <- levels(wine.france$taster_name)
tasterLevels
tasterLevels[length(tasterLevels) + 1] <- "Unknown"
#tasterLevels[length(tasterLevels) + 1] <- "Anne Krebiehl"
tasterLevels
varietyLevels<- levels(wine.france$variety)
varietyLevels

# refactor taster_name to include "Unknown" as a factor level
# and replace NA with "Unknown"
wine.france$taster_name <- factor(wine.france$taster_name, levels = tasterLevels)
wine.france$taster_name[wine.france$taster_name==""] <- "Unknown"
# wine.france$taster_name[wine.france$taster_name=="Anne KrebiehlÂ MW"] <- "Anne Krebiehl"

wine.france<-wine.france[wine.france$latitude>42,]
wine.france<-wine.france[wine.france$latitude<51,]
### Drop Levels ###
wine.france<-droplevels(wine.france)

table(wine.france$variety)
table(wine.france$taster_name)
table(wine.france$latitude)
#wine = wine[c("points","price","province","taster_name","review_length","elevation","abs_latitude")]

### Interesting Plots
plot(wine.france$points, wine.france$price)
plot(wine.france$review_length, wine.france$price) # the number of characters in the review, no relation
plot(wine.france$province, wine.france$price) # doesn't look like any relation between price and province
plot(wine.france$variety, wine.france$price) # doesn't look like any relation between price and variety
plot(wine.france$east_of_atlantic, wine.france$price)

### Splitting test and training sets
set.seed(1)
n = dim(wine.france)[1]
train_ix = sample(seq_len(n), size=0.75*n)
test_ix = (-train_ix)

### Linear Models for france ###
lm.wine.france<-lm(data=wine.france, log(price)~points)
summary(lm.wine.france)
lm.wine.france.vintage<-lm(data=wine.france, log(price)~points+vintage)
summary(lm.wine.france.vintage)

### Price by Vintage ###
ggplot(wine.france,aes(vintage,log(price))) + geom_point() + geom_rug() + xlim(1970,2018) +  theme_tufte(ticks=F) + 
  xlab("Vintage") + ylab("Log(Price)") + 
  theme(axis.title.x = element_text(vjust=-0.5), axis.title.y = element_text(vjust=1))

### Marginal Histogram Scatterplot ###
### Price by Points ###
p <- ggplot(wine.france, aes(points, log(price)))  + geom_point() + theme_tufte(ticks=F)+labs(title = sprintf("Log(Price) by Ratings of French Wines"))
ggMarginal(p, type = "histogram", fill="transparent")
# ggplot(wine.france,aes(points,price)) + geom_point() + geom_rug() + ylim(0,100)+ theme_tufte(ticks=F) + 
#   xlab("Points") + ylab("Price") + 
#   theme(axis.title.x = element_text(vjust=-0.5), axis.title.y = element_text(vjust=1))

### Marginal Histogram Scatterplot ###
### Price by Vintage ###
v <- ggplot(wine.france, aes(vintage, log(price)))  + geom_point() + 
    theme_tufte(ticks=F)+labs(title = sprintf("Log(Price) by Vintage of French Wines"))
ggMarginal(v, type = "histogram", fill="transparent")

#ggplot(wine.france)+geom_bar(aes(x=vintage))+xlim(1975,2020)
colnames(wine.france)

### Marginal Histogram Scatterplot ###
### Price by Latitude ###
#ggplot(wine.france)+geom_point(aes(x=latitude,log_price))
lat <- ggplot(wine.france, aes(latitude, log(price)))  + geom_point() + 
  theme_tufte(ticks=F)+labs(title = sprintf("Log(Price) by Latitude of French Wines"))
ggMarginal(lat, type = "histogram", fill="transparent")


### Barchart of French Tasters ###
#ggplot(wine.france)+geom_bar(aes(x=taster_name))
ggplot(wine.france, aes(x=taster_name)) + theme_tufte(base_size=14, ticks=F) +
  geom_bar(width=0.25, fill="gray", stat="count") +  theme(axis.title=element_blank()) +
  scale_y_continuous(breaks=seq(0, 10000, 1000)) + 
  geom_hline(yintercept=seq(0, 12000, 1000), col="white", lwd=1) +
  theme(axis.text.x=element_text(angle=30, hjust=1)) +
  annotate("text", x = 3, y = 12000, adj=1,  family="serif",
           label = c("Tasters of French Wines"))

### Barchart of French Varieties###
# ggplot(wine.france)+geom_bar(aes(x=variety))+
#   theme(axis.text.x=element_text(angle=30, hjust=1))+
#           labs(title = sprintf("Variety of francefornia Wines"))
ggplot(wine.france, aes(x=variety)) + theme_tufte(base_size=14, ticks=F) +
  geom_bar(width=0.25, fill="gray", stat="count") +  theme(axis.title=element_blank()) +
  scale_y_continuous(breaks=seq(0, 2000, 100)) + 
  geom_hline(yintercept=seq(0, 2000, 100), col="white", lwd=1) +
  theme(axis.text.x=element_text(angle=30, hjust=1)) +
  annotate("text", x = 7, y = 2000, adj=1,  family="serif",
           label = c("Variety of French Wines"))


### Interesting Plots
plot(wine.france$points, wine.france$price)
plot(wine.france$review_length, wine.france$price) # the number of characters in the review, no relation
plot(wine.france$province, wine.france$price) # doesn't look like any relation between price and province
plot(wine.france$variety, wine.france$price) # doesn't look like any relation between price and variety
plot(wine.france$east_of_atlantic, wine.france$price)

### Splitting test and training sets
head(wine.france)
colnames(wine.france)


### 
wine.france.sample<-wine.france[c("region_1","points","variety","taster_name","price","vintage")]
colnames(wine.france.sample)
sorted<-wine.france.sample[order("variety"),]
factor(wine.france.sample$variety)
table(wine.france.sample$variety)
count(wine.france.sample, "taster_name")

set.seed(1)
n = dim(wine.france.sample)[1]
train_ix = sample(seq_len(n), size=0.75*n)
test_ix = (-train_ix)

### Linear Models for France ###
lm.wine.france<-lm(data=wine.france, price~vintage)
summary(lm.wine.france)

### Price by Vintage ###
ggplot(wine.france,aes(vintage,price)) + geom_point() + geom_rug() +ylim(0,500)+ theme_tufte(ticks=F) + 
  xlab("Vintage") + ylab("Price") + 
  theme(axis.title.x = element_text(vjust=-0.5), axis.title.y = element_text(vjust=1))

### Price by Points ###
ggplot(wine.france,aes(points,price)) + geom_point() + geom_rug() +ylim(0,500)+ theme_tufte(ticks=F) + 
  xlab("Points") + ylab("Price") + 
  theme(axis.title.x = element_text(vjust=-0.5), axis.title.y = element_text(vjust=1))


plot(price~points+vintage, data=wine.france)
abline(lm.wine.france)

### Predicting Price with other quantitative variables ###
getStep(wine.france[train_ix,], wine.france[test_ix,])
getPLS(wine.france[train_ix,], wine.france[test_ix,])
getLasso(wine.france[train_ix,], wine.france[test_ix,])
data.train = wine.france[train_ix,] # not sure why this needs to be here, looks like R bug
getTreeCV(wine.france[train_ix,], wine.france[test_ix,])
getRandomForest(wine[train_ix,], wine[test_ix,])

#####################################
# Only need to use this if we want to pull in more latlng data
collectLatLngData(unique_locations)


########### Analysis Functions ###############
getStep = function(data.train, data.test)
{
  null = lm(price~1, data=data.train)
  full =  lm(price~., data=data.train)
  fwd.lm = step(null, scope=list(lower=null, upper=full), direction="forward")
  bwd.lm = step(full, direction="backward")
  #summary(fwd.lm)
  #summary(bwd.lm)
  step.pred = predict(fwd.lm, newx=data.test[,-1])
  error = mean((step.pred-data.test[,1])^2)
  cat("Min Outsample Error", error, "\n")
  cat("Step Coefs","\n")
  print(fwd.lm$coefficients)
}

getRidge = function(data.train, data.test)
{}

getLasso = function(data.train, data.test)
{
  grid = 10^seq(10,-2,length=100)
  lasso.mod = glmnet(as.matrix(data.train[,-1]),data.train[,1],alpha=1,lambda=grid)
  cv.out = cv.glmnet(as.matrix(data.train[,-1]),data.train[,1],alpha=1)
  bestlam = cv.out$lambda.min
  lasso.pred = predict(lasso.mod,s=bestlam,newx=as.matrix(data.test[,-1]))
  error = mean((lasso.pred-data.test[,1])^2)
  out = glmnet(as.matrix(data.train[,-1]),data.train[,1],alpha=1,lambda=grid)
  lasso.coef = predict(out,type="coef",s=bestlam)[1:length(data.train),]
  plot(lasso.mod,lwd=2)
  plot(cv.out)
  cat("Min Outsample Error", error, "\n")
  cat("CV Lasso Coefs","\n")
  print(lasso.coef)
}

getPLS = function(data.train, data.test)
{
  pls.fit = plsr(price~.,data=data.train,validation="CV",scale=T)
  #summary(pls.fit)
  validationplot(pls.fit,val.type="MSEP")
  k = dim(data.train)[2]-1
  val.errors.pls<-rep(NA,k)
  for (i in 1:k)
  {
    pls.pred = predict(pls.fit,data.test[,-1],ncomp=i)
    val.errors.pls[i] = mean((pls.pred-data.test[,1])^2)
  }
  j = which.min(val.errors.pls)
  min_error = val.errors.pls[j]
  cat("Min Outsample Error", min_error, "Components", j, "\n")
  data.test['predicted_price'] = pls.pred
}

getSVMLinear = function(data, cost, verbose=FALSE)
{
  tuning_costs = c(.1,1,10,100,1000)
  tuning_gammas = c(0.5,1,2,3,4)
  wine.svm<-svm(country~.,data=data,kernel="linear",cost=1,scale=T)
  tune.out<-tune(svm,country~.,data=data,kernel="linear",ranges=list(cost=tuning_cost))
  return(tune.out)
}

getSVMRadial = function(data, cost, gamma, verbose=FALSE)
{
  tuning_costs = c(.1,1,10,100,1000)
  tuning_gammas = c(0.5,1,2,3,4)
  pima.tr.svm<-svm(type~.,data=data,kernel="radial",cost=1,gamma=1,scale=T)
  tune.out<-tune(svm,type~.,data=data,kernel="radial",ranges=list(cost=tuning_cost,gamma=tuning_gamma))
  return(tune.out)
}

getTreeCV = function(data.train, data.test)
{
  data.tree = tree(price~., data=data.train)
  data.tree.cv = cv.tree(data.tree, FUN=prune.tree)
  data.tree.prune = prune.tree(data.tree, best=data.tree.cv$size[which.min(data.tree.cv$dev)])
  plot(data.tree.prune, main="Classification for Price")
  text(data.tree.prune, all=TRUE, cex=.8)
  
  data.tree.prune.pred = predict(data.tree.prune, data.test, type='vector')
  error = mean((data.tree.prune.pred-data.test[,1])^2)
  cat("Min Outsample Error", error, "\n")
}

getRandomForest<-function(data.train, data.test, mtry=3, importance=FALSE)
{
  data.rf<-randomForest(price~.,data=data.train,mtry=mtry,importance=importance)
  data.rf.pred<-predict(data.rf,newdata=data.test)
  error = mean((data.rf.pred-data.test[,1])^2)
  cat("Min Outsample Error=", error, "\n")
}

# better for categorical response?  allows for larger set categorical indep vars
# this doesn't seem to work the way I would expect it to...
getGBM<-function(data.train, data.test, interaction=1, shrinkage=0.001)
{
  data.gbm<-gbm(price~.,data=data.train, 
                distribution="gaussian",interaction.depth=interaction,
                shrinkage=shrinkage)
  data.gbm.pred<-predict(object=data.gbm,newdata=data.test,
                         n.trees=100,type="response")
  return(data.gbm.pred)
}

getKMeans = function(data)
{}

############# Data Manipulation ################
cleanWineData = function(data, column_names)
{
  data.out = data[,column_names]
  data.out['review_length'] = apply(matrix(wine.raw$description), MARGIN=1, FUN=nchar)
  data.out['vintage'] = numExtractVintage(data$title)
  data.out = na.omit(data.out)
  removed = dim(data)[1]-dim(data.out)[1]
  cat("Removed",removed,"NaNs",removed/dim(data)[1],"percent")
  return(data.out)
}

joinLatLngElev = function(data, column_locations, query_location_str)
{
  if (!match(query_location_str, column_locations))
  {
    return(NA)
  }
  latlng = read.csv('latlng.prod.csv')
  merged_data = merge(x=data, y=latlng, by.y='location', by.x=query_location_str, all.x=TRUE)
  merged_data = na.omit(merged_data)
  merged_data$unique_loc_ix = NULL
  merged_data$abs_latitude = abs(merged_data$latitude)
  merged_data$east_of_atlantic = merged_data$longitude < -30
  removed = dim(data)[1]-dim(merged_data)[1]
  #cat("Removed",removed,"NaNs",removed/dim(data)[1],"percent")
  return(merged_data)
}

getWineNumericalValues = function(data, quantitative_variables)
{
  data = data[, quantitative_variables]
  data$points = as.numeric(data$points)
  return(data)
}

getWineCategoricalValues = function(data)
{}

numExtract = function(string){ 
  return(as.numeric(str_extract(string, "2[0-9]{3}")))
}
numExtractVintage = function(string){ 
  return(as.numeric(str_extract(string, "[0-9]{4}")))
}

getLatLng = function(location)
{
  html_loc = gsub("\\s+", "+", location)
  html_str = sprintf('https://maps.google.com/maps/api/geocode/json?address=%s&sensor=false&key=%s', html_loc, developer_key)
  cat(html_str, "\n")
  data = fromJSON(html_str)
  lat = as.numeric(data$result$geometry$location$lat[1])
  lng = as.numeric(data$result$geometry$location$lng[1])
  return(c(lat,lng))
}

getAltitude = function(latlng)
{
  html_str = sprintf('https://maps.googleapis.com/maps/api/elevation/json?locations=%s,%s&key=%s', latlng[1], latlng[2], developer_key)
  cat(html_str, latlng, "\n")
  if (is.na(latlng[1]) || is.na(latlng[2]))
  {
    elevation = NA
  }
  else
  {
    data = fromJSON(html_str)
    elevation = as.numeric(data$results$elevation)
  }
  return(elevation)
}

getUniqueLocations = function(data, cols_with_locations)
{
  unique_locations<-c()
  for (col in cols_with_locations)
  {
    values = as.vector(unlist(unique(data[col])))
    unique_locations = c(unique_locations, values)
  }
  return(sort(unique_locations[unique_locations != ""]))
}

collectLatLngData = function(unique_elements, filename='latlng.csv', max_errors=3)
{
  i = 1
  errors = 0
  data<-NULL
  while (i <= length(unique_elements)) 
  {
    latlng = getLatLng(unique_elements[i])
    elevation = getAltitude(latlng)
    str = paste(i, unique_elements[i], latlng[1], latlng[2], elevation, sep=',')
    cat(str,"\n")
    Sys.sleep(.1)
    if (length(latlng) == 0) # query came up empty, sleep and try again
    {
      errors = errors + 1
      if (errors > max_errors) # giveup if we exceed max tries
      {
        i = i + 1
        data<-c(data,c(i,latlng))
        errors = 0
      }
      Sys.sleep(1)
      next
    }
    data<-c(data,c(i, latlng))
    write(str, file=filename, append=TRUE)
    i = i+1
    errors = 0
  }
  return(data)
}

