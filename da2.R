#Package
install.packages("recommenderlab")
library(recommenderlab)

#Dataset
data("MovieLense")
str(MovieLense)
View(as(MovieLense,"data.frame"))

#Visualize the data
image(MovieLense[1:25,25:1])

#Movie Recoard of Person 1
head(as(MovieLense,"data.frame"))

#Number of Ratings per user
hist(colCounts(MovieLense),col=2)

#Average User Ratings
hist(rowMeans(MovieLense),col=3)

#Number of Users in the data set
nusers=dim(MovieLense)[1]
nusers

#Number of Movies
nmovies=dim(MovieLense)[2]
nmovies

#Summary of users
summary(rowCounts(MovieLense))

#visualise a part of the data
image(MovieLense [sample(nusers, 25), sample(nmovies,25)])

#Check Movie Ratings
vector_ratings<-as.vector(MovieLense@data)
vector_ratings
unique(vector_ratings)

#Checkig for Null Values
table_ratings<-table(vector_ratings)
table_ratings

#types of reccomenders
recommenderRegistry$get_entries(dataType="realRatingMatrix")

#Similarity Matrix
#User Similarity
similarity_users <- similarity(MovieLense[1:4, ], method="cosine",which="users")
similarity_users
#Item Similarity
similarity_items <- similarity(MovieLense[ ,1:4], method="cosine",which="items")
similarity_items

#Reccomendation Engine

#Create an evaluation scheme by splitting the data and specifying other parameters 
evls <- evaluationScheme (MovieLense, method="split", train=0.9, given=10);
evls
#Creating Training Dataset
trg <- getData(evls,"train")
trg
test_known <- getData(evls,"known")
test_known
test_unknown <- getData(evls,"unknown")
test_unknown

#UBCF(User Based Collabrative Filtering) recommender model with the training data
rcmnd_ub <- Recommender (trg,"UBCF")

#Generate Predictions
pred_ub <- predict(rcmnd_ub, test_known, type="ratings");
pred_ub
acc_ub <- calcPredictionAccuracy (pred_ub, test_unknown)
#Compare the results
as (test_unknown, "matrix") [1:8, 1:5]
as (pred_ub, "matrix")[1:8,1:5]

#IBCF(Item Based Collabrative Filtering) recommender model with the training data
rcmnd_ib <- Recommender (trg, "IBCF")
pred_ib <- predict(rcmnd_ib, test_known, type="ratings")
acc_ib <- calcPredictionAccuracy (pred_ib, test_unknown)
acc<- rbind(UBCF = acc_ub, IBCF = acc_ib);
acc

#Get the top recommendations
pred_ub_top <- predict (rcmnd_ub, test_known);
pred_ub_top
movies <-as (pred_ub_top, "list")
movies[1]