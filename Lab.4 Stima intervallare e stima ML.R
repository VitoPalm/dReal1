# Introduction to estimation in R: Confidence interval and Maximum Likelihood
# Fabio Postiglione (fpostiglione@unisa.it) & Mario Di Mauro (mdimauro@unisa.it)

#setwd('/Fp/Unisa/Didattica/StatApplicata_Triennale/Corso 2023_24/R_ex') #set the working dir

data=read.table("studenti.txt", header=TRUE) 
genere=data[,2]
altezza_f=data$altezza[genere==1]
hist(altezza_f,freq = F, main = "Istogramma delle altezze delle ragazze")
nn <- 20
sample_altezza_f=sample(altezza_f, nn)
n_sample=length(sample_altezza_f)
#calculate the sample mean
sample_mean=mean(sample_altezza_f)
sample_var=sum((sample_altezza_f-sample_mean)^2)/(n_sample-1)
cat("var campionaria altezze: ", var(sample_altezza_f),"\n")
cat("var popolazione altezze: ", var(altezza_f),"\n")

#Calculate conf int at 1-alpha=0.95 for a Normal with mu unknown and var known
#Inverse search into z table and search for the value 0.95+0.025=0.975
#otherwise...
z_value=qnorm(0.975, lower.tail = T)
#Note: in this case we suppose to know the standard dev. (we derive it from the whole population)
lower_conf_int_95=sample_mean-z_value*sd(altezza_f)/sqrt(n_sample)
upper_conf_int_95=sample_mean+z_value*sd(altezza_f)/sqrt(n_sample)
plot(sample_altezza_f+rnorm(length(sample_altezza_f),0,.1), rnorm(length(sample_altezza_f),0,.1), xlab="altezze", ylab="",yaxt='n', pch=20, ylim=c(-2,2))
points(sample_mean,0,pch=3,col="blue", cex=1.2)
abline(v=lower_conf_int_95, lwd=2)
abline(v=upper_conf_int_95, lwd=2)
#Calculate 90% conf int (1-alpha=0.90)
z_value_90perc=qnorm(0.95, lower.tail = T)
#Inverse search into z table and search for the value 0.90+0.05=0.95
lower_conf_int_90=sample_mean-z_value_90perc*sd(altezza_f)/sqrt(n_sample)
upper_conf_int_90=sample_mean+z_value_90perc*sd(altezza_f)/sqrt(n_sample)
abline(v=lower_conf_int_90, col='red', lty=2, lwd=2)
abline(v=upper_conf_int_90, col='red', lty=2, lwd=2)
legend("bottomright", legend=c("sample points","est. mean","","IC 95%","","IC 90%"), col=c("black","blue","black","black","red","red"), lwd=c(NA,NA,NA,2,NA,2), lty=c(NA,NA,NA,1,NA,2), pch=c(20,3,NA,NA,NA,NA), cex=0.7)


#Ex2: introduction of chi-square and t-student

#Chi-Square distribution -- chisq = Sum(Z_i)^2)
#E[chisq]=d, var[chisq]=2d with d=degrees of freedom (DF)
mychisq=rchisq(1000, 10)
hist(mychisq, freq=F)
mean(mychisq) #tends to d
var(mychisq)  #tends to 2d
#Note: (n-1)*S^2/sigma^2 distributed as chisq with n-1 DF 
# --> inference on the variance of a normal distribution

#T-student distribution -- tstud=Z/sqrt(chisq/DF)
#E[tstud]=0, var[tstud]=d/(d-2)
mytstud=rt(1000, 10)
hist(mytstud, freq=F)
mean(mytstud) #tends to 0
var(mytstud)  #tends to d/(d-2)
#Note: (X_hat-mu)/S*sqrt(n) distributed as t-student with n-1 DF 
# --> inference on the mean of a normal distribution

# Example 1: Mean and std dev not known --> usage of the t-student distribution and calculate 90% conf int for the expected value mu
#Calculate sample stdev S = sqrt(sum(x-sample_mean)^2)/sqrt(n-1) 

temp=0
for (i in 1:n_sample)
{
  temp = temp + (sample_altezza_f[i]-sample_mean)^2
}

sample_stdev=sqrt(temp/(n_sample - 1))

# For a CI at level 1-alpha = 0.9, enter t-stud table with 1 - alpha/2 = 0.95 where alpha = 0.1 and nn_sample-1 = 19 = DF 
#or alternatively...
alpha=0.1
t_score=qt(p=1-alpha/2, df=(n_sample - 1), lower.tail = T)
t_score=qt(p=alpha/2, df=(n_sample - 1), lower.tail = F)
print(t_score)

#Conf int = S/sqrt(n) *t_value
lower_conf_int_t90=sample_mean-t_score*sample_stdev/sqrt(n_sample)
upper_conf_int_t90=sample_mean+t_score*sample_stdev/sqrt(n_sample)
# plot(sample_mean, ylim = c(min(sample_altezza_f),max(sample_altezza_f)))
# abline(h=lower_conf_int, col='blue')
# abline(h=upper_conf_int, col='blue')
dev.new()
plot(sample_altezza_f+rnorm(length(sample_altezza_f),0,.1), rnorm(length(sample_altezza_f),0,.1), xlab="altezze", ylab="",yaxt='n', pch=20, ylim=c(-2,2))
points(sample_mean,0,pch=3,col="blue", cex=1.2)
abline(v=lower_conf_int_95, lwd=2)
abline(v=upper_conf_int_95, lwd=2)
abline(v=lower_conf_int_90, col='red', lty=2, lwd=2)
abline(v=upper_conf_int_90, col='red', lty=2, lwd=2)
abline(v=lower_conf_int_t90, col='blue', lty=2, lwd=2)
abline(v=upper_conf_int_t90, col='blue', lty=2, lwd=2)

legend("bottomright", legend=c("sample points","est. mean","","IC 95%","","IC 90%","","t-stud IC 90%"), col=c("black","blue","black","black","red","red", "blue", "blue"), lwd=c(NA,NA,NA,2,NA,2,NA,2), lty=c(NA,NA,NA,1,NA,2,NA,2), pch=c(20,3,NA,NA,NA,NA,NA,NA), cex=0.7)


# Example 2: Mean and std dev not known --> usage of the chi-square distribution and calculate 95% conf int for the variance

norm_pop=rnorm(1000,mean=12,sd=3)
sample_normpop=sample(norm_pop, 20)
n_sample=length(sample_normpop)

sample_stdev_normpop = sqrt(sum((sample_normpop-mean(sample_normpop))^2)/(length(sample_normpop)-1))

# temp=0
# for (i in 1:length(sample_normpop))
# {
#   temp = temp + (sample_normpop[i]-mean(sample_normpop))^2
# }
# sample_stdev_normpop=sqrt(temp/(n_sample - 1))

#Enter chisq table with 1-alpha=0.95 --> 1-alpha/2=0.975 with nu=n_sample-1=19=DF 
#chisq_0.975=32.9, chisq_0.025=8.91
lower_conf_int_95=(n_sample-1)*(sample_stdev_normpop^2)/32.9
upper_conf_int_95=(length(sample_normpop)-1)*(sample_stdev_normpop^2)/8.91
alpha_chisq=0.05
q_score1=qchisq(p=alpha_chisq/2, df=19, lower.tail = F)
q_score2=qchisq(p=alpha_chisq/2, df=19, lower.tail = T)
print(q_score1)
print(q_score2)

cat("Confidence Interval on variance at 95% level [L,U], where L = ",lower_conf_int_95, "and U = ",upper_conf_int_95)

cat("Sample variance = ",(sample_stdev_normpop)^2)

# Confidence intervals with a given confidence level ('for' cycles)
library(tictoc)
tic()
mcrep = 1000000               # Simulation (Monte Carlo) replications
n = 20                       # Sample size we are studying
meann = 2; varn = 3          # mean and var of Normal dist.
alpha = 0.05                  # alpha: risk
quant = qt(1-alpha/2,n-1)    # Multiplier for (1-alpha)% confidence
cvg<-0
for(ii in 1:mcrep) {
  xmat = rnorm(n,meann,sd=sqrt(varn))  # Simulate N(meann,varn) data
  mn = mean(xmat)    # Sample mean of each column
  se = sd(xmat) / sqrt(n)           # Standard errors of the mean
  lcb = mn - quant*se          # lower confidence bounds
  ucb = mn + quant*se          # upper confidence bounds
  cvg = cvg + ifelse((lcb < meann) & (ucb > meann),1,0) 
}
print(cvg/mcrep)
toc()

# Smart version: Confidence intervals with a given confidence level (Vectorized)
tic()
mcrep = 1000000               # Simulation (Monte Carlo) replications
n = 20                       # Sample size we are studying
meann = 2; varn = 3          # mean and var of Normal dist.
xmat = rnorm(n * mcrep,meann,sd=sqrt(varn))  # Simulate N(meann,varn) data
dim(xmat) = c(n,mcrep)       # Each column is a dataset
#mn = apply(xmat, 2, mean)  # SLOW Sample mean of each column
mn = colMeans(xmat)          # Sample mean of each column
#std = apply(xmat, 2, sd)     # SLOW Sample std. dev. of each column
std = sqrt(colSums((xmat - matrix(rep(mn,n),nrow = n, byrow = T))^2)/ (nrow(xmat) - 1)) # Sample std. dev. of each column
se = std / sqrt(n)           # Standard errors of the mean
alpha = 0.05                  # alpha: risk
quant = qt(1-alpha/2,n-1)    # Multiplier for (1-alpha)% confidence
lcb = mn - quant*se          # lower confidence bounds
ucb = mn + quant*se          # upper confidence bounds
cvrg_prob = mean((lcb < meann) & (ucb > meann)) # coverage probability
print(cvrg_prob)
toc()

################
#   Likehood   # -- All my homies 
################

#Es. Normal with mu=0 and var=theta (to estimate)
mynorm=rnorm(1000, mean = 0, sd=1.8) 
x=sample(mynorm,30)
n=length(x) 
ml_est=(1/n)*sum(x^2)

normal_loglik=function(theta,x)
{
n=length(x)  
mylogl = -0.5*n*log(2*pi*theta) - sum(x^2)/(2*theta)
}

thetavals=seq(1,40,by=0.1)
elle=normal_loglik(thetavals,x)
plot(thetavals,elle, lwd=1, xlab = 'theta', ylab='Log-likelihood')
abline(v=ml_est)
cat("Stima ML teorica: ",ml_est,"\nStima ML numerica: ",thetavals[which.max(elle)])

#Exercise: Normal with mu=theta (to estimate) and var=1 
mynorm=rnorm(1000, mean = 1.5, sd=1)
x=sample(mynorm,30)
n=length(x) 
ml_est=mean(x)

normal_loglik=function(theta,x)
{
  n=length(x)  
  mylogl=-0.5*n*log(2*pi)-0.5*sum((x-theta)^2)
}

thetavals=seq(-10,10,by=0.1)
elle=0
for (i in 1:length(thetavals))
{
  elle[i]=normal_loglik(thetavals[i],x)
}

plot(thetavals,elle, lwd=1, xlab = 'theta', ylab='Log-likelihood')
abline(v=ml_est)
cat("\n\nStima ML teorica: ",ml_est,"\nStima ML numerica: ",thetavals[which.max(elle)])

x=sample(mynorm,100)
elle=0
for (i in 1:length(thetavals))
{
  elle[i]=normal_loglik(thetavals[i],x)
}

matplot(x=thetavals,y=elle, add=T, lwd=1, col="red")

x=sample(mynorm,500)
elle=0
for (i in 1:length(thetavals))
{
  elle[i]=normal_loglik(thetavals[i],x)
}

matplot(x=thetavals,y=elle, add=T, lwd=1, col="green")

