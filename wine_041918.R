library(stringr)
library(jsonlite)
library(plyr)
library(tree)   # trees
library(randomForest) # randomForest
library(gbm) # gradient boosting
library(e1071)  # svm
library(glmnet) # ridge/lasso
library(pls)    # pls

setwd('c:/Users/Neal/Documents/CofC/2018/MATH 441/Project/Wine/')
#developer_key = 'AIzaSyDk743GZpF2BUasrshdc7vxTp-uw8NRTgs'
wine.raw = read.csv('winemag-data-130k-v2.csv')

column_locations = c("country","province","region_1","region_2")
wine = cleanWineData(wine.raw, c("country", "points", "price", "province", "region_1", "region_2", "variety", "winery", "taster_name"))
wine = joinLatLngElev(wine, column_locations,'region_1')  # merge lat lng values by province

# limit the data set to the most prevalent categorical values
variety_counts = count(wine$variety)
province_counts = count(wine$province)
highest_freq_variety_counts = tail(variety_counts[order(variety_counts$freq),],20)$x
highest_freq_provinces = tail(province_counts[order(province_counts$freq),],20)$x

# wine with the most most prevalent varieties and provinces
wine = wine[(wine$variety %in% highest_freq_variety_counts) & (wine$province %in% highest_freq_provinces),]
wine = droplevels(wine) # hate R...so much hate
head(wine)

# select a subset by location
wine.cali = wine[wine$province == 'California',]
wine.cali = wine.cali[c("points","price","province","taster_name","review_length","elevation","abs_latitude")]
wine['log_price'] = log(wine$price)
wine.cali<-droplevels(wine.cali)

### Interesting Plots
plot(wine$points, wine$price)
plot(wine$points, wine$log_price)
plot(wine$review_length, wine$log_price) # the number of characters in the review, no relation
plot(wine$province, wine$price) # doesn't look like any relation between price and province
plot(wine$variety, wine$price) # doesn't look like any relation between price and variety
plot(wine$east_of_atlantic, wine$price)


### Splitting test and training sets
set.seed(1)
n = dim(wine.cali)[1]
train_ix = sample(seq_len(n), size=0.75*n)
test_ix = (-train_ix)


### Predicting Price with other quantitative variables ###
getStep(wine.cali[train_ix,], wine.cali[test_ix,])
getPLS(wine.cali[train_ix,], wine.cali[test_ix,])
getLasso(wine.cali[train_ix,], wine.cali[test_ix,])
data.train = wine.cali[train_ix,] # not sure why this needs to be here, looks like R bug
getTreeCV(wine.cali[train_ix,], wine.cali[test_ix,])
getRandomForest(wine.cali[train_ix,], wine.cali[test_ix,])

#####################################
# Only need to use this if we want to pull in more latlng data
unique_locations = getUniqueLocations(wine.clean, column_locations)
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

