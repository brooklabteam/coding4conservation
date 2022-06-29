#########################
##  LINEAR REGRESSION ##
########################

#CODING FOR CONSERVATION
#JUNE 29, 2022
#SOPHIA HORIGAN
#Acknowledgements : Andres Garchitorena

#OBJECTIVES
# 1. Perform univariate, multivariate, and generalized linear regression
# 2. Create and interpret diagnostic plots to determine if our dataset violates any regression assumptions
# 3. Determine how to select the best model, i.e. determine which combination of predictors best explain the outcome

#THE DATA
# Group of 100 lemurs for which a number of measurements were carried out in the field
# These include height (in cm), age (in months), gender, number of gastrointestinal parasites found in their faeces, and malaria infection

# To access online manuals, references, and other material, you can type
help.start()

#----------------------------------#
#   0. CREATE WORK ENVIRONMENT 
#----------------------------------#
## 0.1 check that you are working in the right directory ("C4C-Linear Regression")
getwd()
# You can manually set working directory by going to the top bar -> Session -> Set Working Directory -> Choose Directory

## 0.2 Load dataset
lemur.data <- read.table("lemur_data.txt", stringsAsFactors = F, header = T)

## 0.3 Explore the data
# print the top 10 lines
head(lemur.data)

# examine dimensions of dataframe
dim(lemur.data)

# print column names
names(lemur.data)

# basic stats on each variable
summary(lemur.data)

# list type of each variable
str(lemur.data)

# access the variables in the dataframe without having to call the dataframe
# i.e. can print 'height' intead of 'lemur.data$height'
attach(lemur.data)
# detach(lemur.data)

## 0.4 let's check our out outcome variable of interest - lemur height
hist(height, col='grey')
boxplot(height, ylab='Height (cm)')

#-------------------------------------#
#   1. UNIVARIATE LINEAR REGRESSION 
#--------------------------------------#

# Let's create a few simple linear models to see which variables best predict height

## 1.1 Age
par(mfrow=c(1,1))
plot(age, height, pch=19, main = "Age & Height")
m1=lm(height~age, data=lemur.data)
abline(m1, col = 'red')
summary(m1)
## Call : our formula
## Residuals : some basic stats of our residuals (error) -- not much help in a table, we'll plot them later
## Coefficients : information about the slopes and intercepts
## Estimate : intercept and slope
## Standard Error : average amount the coefficients vary from model-- want it to be small relative to coefficients
## t-value : how many standard deviations our coefficient estimate is away from 0 (the null) -- want it to be far from zero
## Pr(>t) : prob of observing any value equal or larger than t -- want < 0.05
## significance codes : *** indicates highly significant p-value
## Residual standard error : measure of quality of linear regression fit -- smaller = better fit
## Multiple R-squared : statistical measure of how well model fits data (how much of observed variance in height can be explained by age)
## closer to 0 -- no variance explained, bad model! closer to 1 -- more variance explained, better fit!
## Adjusted R-squared : adjusts for including more variables (more variables will always make the model fit better, but we want the simplest model that fits the best)
## F-statistic : want farther from 1, given size of data 

# YOUR TASK: Following the example above, create a linear regression called m2 that examines how GI parasites impacts height 
## 1.2 GI Parasites


#--------------------------------------#
#   2. MULTIVARIATE LINEAR REGRESSION 
#--------------------------------------#

# 2.1 Sex and Age
boxplot(height~sex)
plot(age, height, col=factor(sex),pch=19)
legend("topleft",
       legend = levels(factor(sex)),
       pch = 19,
       col = factor(levels(factor(sex))))
abline(lm(height[sex=='Female']~age[sex=='Female']), col='black',lwd=2)
abline(lm(height[sex=='Male']~age[sex=='Male']), col='red',lwd=2)

m3=lm(height~age+sex, data=lemur.data)
summary(m3)

# 2.2 Biggest multivariate of them all -- all variables!
m4=lm(height~age+sex+GIparasites+malaria, data=lemur.data)
summary(m4)


#-----------------------------------
# 3. MODEL SELECTION & DIAGNOSTICS
#-----------------------------------
## 3.1 Stepwise selection
# Now that we've built many different linear models, we can perform model selection to choose the best
# Stepwise selection to exclude variables that do not help explain the outcome variable
# Step function : choose a model by AIC in a stepwise algorithm
# the default is 'both', but you can also select 'backward' or 'forward' selection
# start with full model
m5=step(m4)
# this output shows you the AIC value for each model version

summary(m5)

## 3.2 Model diagnostics
# remember, we need to make sure it doesn't violate any of the assumptions!
par(mfrow = c(2,2))
plot(m5)
# Residuals vs Fitted : Linearity
# Normal QQ : Normality
# Scale - Location : Homoscedasticity
# Residuals vs Leverage : Outliers etc.


#--------------------------------------#
#   4. GENERALIZED LINEAR REGRESSION 
#--------------------------------------#
## 4.1 Examine data
# Instead of height, let's explore determinants of parasite numbers and of infectious status
# For this, we need to understand first what type of outcome variable we're dealing with and the most appropriate model
par(mfrow=c(1,1))
hist(GIparasites, col='grey')
plot(as.factor(sickGIparasites), col="grey", main="Infection status")
# a factor is a variable that stores categorical datasets

## 4.2 Number of Parasites
# The variable "Number of parasites" is count data and it's poisson distributed. 
# This type of variable is typically modeled with poisson models 
m6=glm(GIparasites~age+sex+malaria, family='poisson', data=lemur.data)
summary(m6)

## 4.2 Stepwise selection
m7=step(m6)
summary(m7)


## 4.3 Backtransform
# Remember that each family has a certain link to associate the linear predictor with the response variable
# To be able to interpret the results given in the model output, we need to back-transform them
# Let's look at the intercept of our poisson model of GI parasites and one coefficient 
m7tab=summary(m7)$coefficients

intercept=exp(m7tab[1,1]) ; intercept
effet.sex=exp(m7tab[2,1]) ; effet.sex

## 4.3 YOUR TASK : Infection Status
# The variable "infectious status" is a binary variable 
# This type of variable is typically modeled with binomial models (also known as logistic regression)
# Using the code above, apply a GlM looking at how age, sex, and malaria presence impact infection status (SickGIParasites)
# hint: what distribution is typically used for binary data? it isn't a poisson!


## Now, perform stepwise selection on your glm, save the results, and examine the summary of the best-fit model





