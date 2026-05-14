## Introduction to regression analysis with R
# Fabio Postiglione (fpostiglione@unisa.it)
#---------------


getwd()   #return the current directory 
setwd('D:/PA/Didattica/AppliedStatistics/2025/LabR') #set the working directory
data=read.csv('cars.csv')
data=na.omit(data)

dev.new(width = 550, height = 330, unit = "px")
# X = data$horsepower; Y = data$mpg
plot(data$horsepower,data$mpg)

#Evaluate coefficients beta0 and beta1 
beta1_num = sum( (data$horsepower - mean(data$horsepower)) * (data$mpg - mean(data$mpg)) )
beta1_den = sum((data$horsepower - mean(data$horsepower))^2)
beta1 = beta1_num/beta1_den # cov(data$horsepower,data$mpg)/var(data$horsepower) <-> cor(data$horsepower,data$mpg)*(sd(data$mpg/sd(data$horsepower))) 
beta0 = mean(data$mpg)-beta1*(mean(data$horsepower))

abline(beta0,beta1,lwd=2,col="red")

#Apply a linear regression model 
#lm(response ~ feature)
myreg=lm(mpg ~ horsepower, data=data)
myreg$coef
abline(myreg,col="blue")
res=residuals(myreg)
plot(res)
boxplot(res)
summary(myreg)

#Std Errors useful for Hyp. test:
# H_0: beta1=0 --> no relationship between X (horsepower) and Y(mpg)
# H_a: beta1!=0 --> there is some relationship between X and Y
# a small p-value for the intercept and the slope indicates that we can reject the null hypothesis, thus we conclude that there is a relationship between horsepower and mpg


# Confidence intervals
# --------------------
#myreg=lm(mpg ~ horsepower, data=data)
b0=myreg$coefficients[1]
b1=myreg$coefficients[2]
y.fitted=myreg$fitted.values
y=data$mpg
x=data$horsepower

# Find SSE (SQE) and MSE (MSQE)
n=length(y)
sqe=sum((y - y.fitted)^2); sqe
msqe=sqe/(n-2); msqe
S=sqrt(msqe); S

#confidence intervals at 95% confidence level
#-------------
# quantile 1-alpha/2 of Student t distribution with n-2 dof
t.val = qt(0.975, n - 2)
#Conf int at 95% confidence level for b0
conf_int_b0=t.val*S*sqrt(1/n+( (mean(x))^2  / (sum(x^2)-n*(mean(x))^2 ) ) )
low_confint_b0=b0-conf_int_b0
up_confint_b0=b0+conf_int_b0
cat("\nIntervallo di confidenza a livello di confidenza 0.95 per b0:\n[",low_confint_b0,",",up_confint_b0,"]\n")
#Conf int at 95% confidence level for b1
conf_int_b1=t.val*S*sqrt(  (1  / (sum(x^2)-n*(mean(x))^2 ) ) )
low_confint_b1=b1-conf_int_b1
up_confint_b1=b1+conf_int_b1
cat("\nIntervallo di confidenza a livello di confidenza per b1:\n[",low_confint_b1,",",up_confint_b1,"]\n")

# Plot of regression line with confidence and prediction intervals
#-----------------------------------------------------------

#Conf int at 95% confidence level for E[Y|X=x]
xx <- seq(min(x),max(x),along.with = x)
fhat_of_y = (cbind(1, xx)%*%myreg$coefficients) ## b0+b1*xx
#pred_y <- predict(myreg,newdata=data.frame(horsepower=xx))
low_conf_int_ev=fhat_of_y - t.val*S*sqrt(1/n+( (xx-mean(x))^2  / (sum(x^2)-n*(mean(x))^2 ) ) )
up_conf_int_ev=fhat_of_y + t.val*S*sqrt(1/n+( (xx-mean(x))^2  / (sum(x^2)-n*(mean(x))^2 ) ) )
low_pred_int=fhat_of_y - t.val*S*sqrt(1+1/n+( (xx-mean(x))^2  / (sum(x^2)-n*(mean(x))^2 ) ) )
up_pred_int=fhat_of_y + t.val*S*sqrt(1+1/n+( (xx-mean(x))^2  / (sum(x^2)-n*(mean(x))^2 ) ) )

dev.new(width = 550, height = 330, unit = "px")
plot(x, y,col="red",type="p",pch=19,xlab = "horsepower",ylab="mpg",xlim=c(40,250),ylim=c(5,50))
lines(xx, fhat_of_y,lty=1, lwd=2, col="black") 
#matplot(xx,pred_y,lty=1, lwd=2, col="black", type="l",add=T)
lines(xx, low_conf_int_ev,lty=3, lwd=2, col="blue")
lines(xx, up_conf_int_ev,lty=3, lwd=2, col="blue")
lines(xx, low_pred_int,lty=3, lwd=2, col="green")
lines(xx, up_pred_int,lty=3, lwd=2, col="green")
legend('topright', c('data', 'regression line', 'confidence bounds','','predicition bounds',''), lty=c(NA,1,3,NA,3,NA), lwd=c(NA,2,2,NA,2,NA), col=c('red', 'black', 'blue', 'blue', 'green', 'green'), pch=c(19,NA,NA,NA,NA,NA),cex=0.95)


#------------------------------------------------------
# An application of polynomial regression (from slides)
#------------------------------------------------------

df = data.frame("x"=c(0,0.5,1,1.5,2,2.5,3,3.5,4,4.5),"y"=c(3,2.2,2,1.2,1,0.8,1,0.8,0.5,0.5))
dev.new()
dev.new(width = 550, height = 330, unit = "px")
plot(df$x, df$y,xlab="x",ylab="y") ## scatter plot
fit1 = lm(y~x, data=df) ## simple linear regression 
summary(fit1) #summary(fit1)$r.squared

fit2 = lm(y~x+I(x^2), data=df) ## linear regression with x^2
summary(fit2)

fit3 = lm(y~x+I(x^2)+I(x^3), data=df) ## linear regression with x^3
summary(fit3)

fit4 = lm(y~x+I(x^3), data=df) ## linear regression with con x^3 without x^2
summary(fit4)

fhat_of_x = (cbind(1, df$x)%*%fit1$coefficients)
# xx <- seq(min(df$x),max(df$x),along.with = df$x)
# pred_x <- predict(fit1,newdata=data.frame(x=xx))
# dev.new()
# lines(df$x, fhat_of_x, lwd=2, col="red")
# matplot(xx,pred_x,, lwd=2, col="blue",add=T,type = "l")
dev.new()
dev.new(width = 550, height = 330, unit = "px")
plot(df$x, df$y,xlab="x",ylab="y",main="Example") ## scatter plot
lines(df$x, fhat_of_x, lwd=2, col="red") ## simple regr.
fhat_of_x2 = (cbind(1, df$x,(df$x)^2)%*%fit2$coefficients)
lines(df$x, fhat_of_x2, lwd=2, col="blue") ## regr. with x^2
fhat_of_x3 = (cbind(1, df$x,(df$x)^2,(df$x)^3)%*%fit3$coefficients)
lines(df$x, fhat_of_x3, lwd=2, col="green") ## regr. with x^2 and x^3
fhat_of_x4 = (cbind(1, df$x,(df$x)^3)%*%fit4$coefficients)
lines(df$x, fhat_of_x4, lwd=2, col="brown") ## regr. with x^3 without x^2

legend('topright', c('data','simple regression','regression with x^2','regression with x^3','regression with x^3 without x^2'), lty=c(NA,1,1,1,1), lwd=c(NA,2,2,2,2), col=c('black',"red","blue","green","brown"), pch=c(1,NA,NA,NA,NA),cex=0.95)

# diagnostics 
dev.new()
par(mfrow=c(2,2))
plot(fit1)

dev.new()
par(mfrow=c(2,2))
plot(fit2)

dev.new()
par(mfrow=c(2,2))
plot(fit3)

dev.new()
par(mfrow=c(2,2))
plot(fit4)


