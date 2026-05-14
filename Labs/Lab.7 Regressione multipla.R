## Multiple linear regression with R
# Fabio Postiglione (fpostiglione@unisa.it)
#---------------

# setwd('~/Fp/Unisa/Didattica/StatApplicata_Triennale/Corso 2025_26/R_ex') #set the working directory
data=read.csv('cars.csv')
data=na.omit(data) # remove rows with Not Available (NA) data
str(data)
summary(data)

# A simple function to evaluate the MSE: 
mse_func=function(actual,predicted) 
  {
  mean( (actual-predicted)^2 ) 
}

# Multiple Linear Regression
# --------------------------

dev.new()
plot(data$horsepower,data$mpg)
dev.print(device = pdf, "Cars_mpg_hp.pdf")
fit_1=lm(mpg ~ horsepower, data=data) #Simple linear regression
summary(fit_1)
# Y=beta0 + beta1*X1 + beta2*X2   
fit_2=lm(mpg ~ horsepower + acceleration, data=data)
summary(fit_2)
fit_2=lm(mpg ~ horsepower + cylinders, data=data)
summary(fit_2)
#Y=beta0 + beta1*X1 + beta2*X2 + beta3*X3
fit_3=lm(mpg ~ horsepower + acceleration + cylinders, data=data)
summary(fit_3)
fit_4=lm(mpg ~ displacement + weight + year + origin, data=data)
summary(fit_4) # displacement not necessary any longer 

data=data[,1:8] # eliminate last column
fit_all=lm(mpg ~ ., data=data)
summary(fit_all)

mse_mod2 = mse_func(data$mpg, fit_2$fitted.values); mse_mod2
mse_mod3 = mse_func(data$mpg, fit_3$fitted.values); mse_mod3
mse_mod4 = mse_func(data$mpg, fit_4$fitted.values); mse_mod4
mse_mod_all = mse_func(data$mpg, fit_all$fitted.values); mse_mod_all


# Exploratory Data Analysis & visualization tools
# -----------------------------------------------

dev.new()
plot(data)
# equivalent to pairs()
dev.print(device=pdf,"pairs.pdf")
dev.new()
pairs(data[,c(1,3,4,5,6,7)],
  col = "red",                # Change color
  pch = 18,                   # Change shape of points
  labels = c("Y","x1","x2","x3","x4","x5"), # Change labels
  main = "Some variables of Cars dataset" # Add a main title
)
dev.print(device = pdf, "Cars_ScatterPlots.pdf")
#install.packages('corrplot')
library(corrplot)
data_new=data[,1:8]
cor1 = round(cor(data_new), digits = 2); cor1
dev.new()
corrplot.mixed(cor(data_new),number.cex=0.8,tl.cex=0.8)
dev.print(device = pdf, "CorrPlot.pdf")
#install.packages('ggplot2') # often used with tydiverse
#install.packages('tydiverse') # a suite for data science
library(ggplot2)
#library(tydiverse)
#install.packages("GGally")
library("GGally")

dev.new()
ggpairs(data[,c(1,3,4,5,6,7)])
dev.print(device = pdf, "GGpairsPlot.pdf")

#------

#Multiple and Polynomial Regression
x1=rnorm(100,mean=1,sd=10)
x2=rnorm(100,mean=2,sd=15)
x3=runif(100,min=5,max=20)
y = 100+2*x1+x1^2+x1*x2*x3+5*x3^3 + rnorm(100,sd=20)
df <- data.frame(y,x1,x2,x3)

dev.new()
pairs(df)
dev.print(device = pdf, "scatters.pdf")

cor2 = round(cor(df), digits = 2); cor2
dev.new()
corrplot.mixed(cor2,number.cex=0.8,tl.cex=0.8)
dev.print(device = pdf, "CorrPlots.pdf")

linfit1=lm(y~x1,data = df); summary(linfit1)
linfit2=lm(y~x1+x2,data = df); summary(linfit2)
linfit3=lm(y~x1+x2+x3,data = df); summary(linfit3)

multi_poly1=lm(y~x1+I(x2^2)+I(x3^3),data = df); summary(multi_poly1)
multi_poly2=lm(y~x1+x2+x3+x1:x2+x1:x3+x2:x3,data = df); summary(multi_poly2) # interactions
multi_poly2_bis=lm(y~(x1+x2+x3)^2,data = df); summary(multi_poly2_bis) # as previous one


multi_poly3=lm(y~x1+x1:x2:x3+I(x3^3),data = df); summary(multi_poly3) # cubic x3 etc.
multi_poly4=lm(y~x1+I(x1^2)+x1:x2:x3+I(x3^3),data = df); summary(multi_poly4) # 
multi_poly5=lm(y~x1+(x1+x2+x3)^2+x1:x2:x3+I(x3^3),data = df); summary(multi_poly5)




###STEPWISE SELECTION

#library(MASS)
# data=data[,1:8] # eliminate car model names
lin_mod1=lm(mpg ~ weight, data=data)
summary(lin_mod1)
lin_mod2=lm(mpg ~ horsepower + weight, data=data)
summary(lin_mod2)
lin_mod_all=lm(mpg ~ ., data=data)
summary(lin_mod_all)

poly_mod_all=lm(mpg ~ horsepower + weight + I(horsepower^2) + I(weight^2), data=data)
summary(poly_mod_all)

step_lin1=step(lin_mod_all, trace = 1, data=data)
summary(step_lin1)
n <- nrow(data) # n is the data size
step_lin2=step(lm(mpg~1,data=data),scope=~ cylinders + displacement + horsepower + weight + acceleration + year + origin, trace = 1, k = 2)
summary(step_lin2)

step_lin3=step(lin_mod_all,scope=~ cylinders + displacement + horsepower + weight + acceleration + year + origin, trace = 1, k = log(n))
summary(step_lin3)

lin_mod_all_inter=lm(mpg ~ (cylinders + displacement + horsepower + weight + acceleration + year + origin)^2, data=data)
summary(lin_mod_all_inter)

step_lin4=step(lm(mpg~(cylinders + displacement + horsepower + weight + acceleration + year + origin)^2,data=data), trace = 1, k = log(n))
summary(step_lin4)

step_poly=step(lm(mpg~(cylinders + displacement + horsepower + weight + acceleration + year + origin)^2+I(weight^2)+I(horsepower^2),data=data), trace = 1, k = log(n))
summary(step_poly)

# diagnostics
# -----------

summary(lin_mod1)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(lin_mod1, main = "Single regressor")
dev.print(device=pdf,"diagLin1.pdf")

summary(lin_mod2)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(lin_mod2, main = "Two regressors")
dev.print(device=pdf,"diagLin2.pdf")

summary(lin_mod_all)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(lin_mod_all, main = "All regressors")
dev.print(device=pdf,"diagLinAll.pdf")

summary(step_lin1)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(step_lin1, main = "AIC Stepwise from full m.")
dev.print(device=pdf,"diagStep1.pdf")

summary(step_lin2)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(step_lin2, main = "AIC Stepwise from null m.")
dev.print(device=pdf,"diagStep2.pdf")

# summary(step_lin3)
# dev.new(width = 550, height = 330, unit = "px")
# par(mfrow=c(2,2))
# plot(step_lin3, main = "BIC Stepwise from full m.")

summary(step_lin4)
dev.new(width = 550, height = 330, unit = "px")
par(mfrow=c(2,2))
plot(step_lin4, main = "BIC Stepwise from all inter.")
dev.print(device=pdf,"diagStepBIC.pdf")

# install.packages("lmtest")
# library(lmtest)
# bptest(step_lin4) # homoscedasticity test
