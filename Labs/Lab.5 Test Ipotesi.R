## Introduction to Hypothesis testing in R
# Fabio Postiglione (fpostiglione@unisa.it)
#---------------

getwd()   #return the current directory 
setwd('D:/PA/Didattica/AppliedStatistics/2025/LabR')

## Ex. 1
# H_0: sigma<=sig0 vs. H_a: sigma>sig0
sig0=.25; alpha=0.05; nn=20; S=0.33
criticVal <- sig0*sqrt(qchisq(1-alpha,nn-1)/(nn-1)); print(criticVal)
if(S < criticVal){  
  print("We accept H_0")
} else {
  print("We reject H_0")  
}
#------------

## Ex. 2
# H_0: mu=mu0 vs. H_a: mu!=mu0 -- pop. X~N(mu,sig^2) Known sig
sig=3; alpha=0.05
dati2 <- c(91.6,88.75,90.8,89.95,91.3)
nn=length(dati2)
mu0=90
Laccet <- mu0 - qnorm(1-alpha/2)*sig/sqrt(nn); Laccet
Uaccet <- mu0 + qnorm(1-alpha/2)*sig/sqrt(nn); Uaccet
xbar <- 1/nn*sum(dati2); xbar
if((xbar > Laccet)&&(xbar < Uaccet))  print("We accept H_0") else  print("We reject H_0")

#  b)
mu_a = 88
term1 = pnorm((mu0-mu_a)/(sig/sqrt(nn)) + qnorm(1-alpha/2))
term2 = pnorm((mu0-mu_a)/(sig/sqrt(nn)) - qnorm(1-alpha/2))
beta =  term1 - term2 
cat("Beta =",beta,"\n")

#  c)
betafix = 0.10 # other beta values can be adopted (e.g. beta = 0.05)

# Approximated value (based on term1=0.9997204 ~ 1, for n = 5)
NN_notInteger = ((sig/(mu0-mu_a))*(qnorm(1-alpha/2) + qnorm(1-betafix)))^2
cat("NN_notInteger =",NN_notInteger,"\n")
NN = ceiling(NN_notInteger)
cat("NN =",NN,"\n")

# Iterative procedure
trovato  = 0
NN2 = 1 # We could start from 6, since n=5 is not enough...
curr_BetaV = 0
indiceBetaV = 1
NNiniz <- NN2
while (trovato == 0) {
  currL = mu0 - qnorm(1-alpha/2)*sig/sqrt(NN2)
  currU = mu0 + qnorm(1-alpha/2)*sig/sqrt(NN2)
  curr_Beta = pnorm(currU,mean = mu_a,sd = sig/sqrt(NN2)) - pnorm(currL,mean = mu_a,sd = sig/sqrt(NN2))
  curr_BetaV[indiceBetaV] = curr_Beta
  if (curr_Beta < betafix) trovato = 1 else {
    NN2 = NN2 + 1
    indiceBetaV = indiceBetaV + 1
  }
}
cat("Num. of experiments:",NN2)
matplot(c(NNiniz:NN2),curr_BetaV,pch=8, lty=1, col="red", type="b",xlab = "n", ylab = "Beta")
matplot(c(NNiniz:NN2),rep(betafix,indiceBetaV),pch=NULL, lty=2, add=T, col="black", type="l")

#------------

## Ex. 3
# H_0: muX = muY vs. H_a: muX != muY
alpha=0.1
dati3 <- data.frame(X = c(89.5,90.0,91.0,91.5,92.5,91.0,89.0,89.5,91.0),
                    Y = c(89.5,91.5,91.0,89.0,91.5,92.0,92.0,90.5,90.0))
nn=nrow(dati3)
Xbar <- mean(dati3$X); Xbar
Ybar <- mean(dati3$Y); Ybar
S2 <- (sum((dati3$X-Xbar)^2)+sum((dati3$Y-Ybar)^2))/(2*(nn-1)); S2
S <- sqrt(S2); S

Laccet <- -qt(1-alpha/2, 2*(nn-1))*S*sqrt(2/nn); Laccet
Uaccet <- qt(1-alpha/2, 2*(nn-1))*S*sqrt(2/nn); Uaccet
DD <- Xbar - Ybar; DD
if((DD > Laccet)&&(DD < Uaccet))  print("We accept H_0") else  print("We reject H0")

#------------


# Other examples
 


## Examples of Hypothesis Test

#Example 1: (Uni-lateral test)
#Through measurements on average delay on data traffic, a telco operator knows that mean_delay = 50 msec.
#Before implementing a novel network strategy which aims to reduce the mean delay, the operator sets the following decision problem (to avoid useless investments):
# H_0: mean_delay >= 50 msec (no investment)
# H_a: mean_delay < 50 msec (investment ok)
# We assume that the communication delays are distributed according to a Normal distribution with unknown (for the operator) variance
#E.g. delay=rnorm(10000, mean = 49, sd=20) # var.= 20^2
#The operator can access to 30 experiments --> sample_delay=sample(delay,30).
# Assume a I type risk \alpha=0.05
mu_0 = 50
mu = 49; std=20
delay=rnorm(10000, mean = mu, sd=std)
n_sample=30
sample_delay=sample(delay,n_sample)
sample_mean=mean(sample_delay)
cat("Sample mean:",sample_mean,"\n")

alpha=0.05
t_score=qt(p = alpha, df=(n_sample - 1), lower.tail = T)
cat("\nQuantile",alpha,"equals to",t_score,"\n")

#I_c: the threshold of the set of the values of the test statistic enabling to reject H_0 under H_0 (critical region or "regione critica")
# I_c = mu_0 + S/sqrt(n) * t_score 

# temp=0
# for (i in 1:n_sample)
# {
#   temp = temp + (sample_delay[i]-sample_mean)^2
# }
# sample_stdev=sqrt(temp/(n_sample - 1)) #sd(sample_delay)
sample_stdev=sqrt(sum((sample_delay-sample_mean)^2)/(n_sample - 1))
critic=mu_0+(sample_stdev/sqrt(n_sample))*t_score
cat("I_c =",critic,"\n")

if(sample_mean < critic){  
print("We reject H_0: invest on the new network strategy")
} else {
print("We accept H_0: the actual network is fine")  
}

##
# qgamma(0.05,30,rate=1/50)
# 30*50+50*sqrt(30)*qnorm(0.05)
##

#-----------------------------


#Hypothesis T-Tests (Two-tailed tests)

#T-test on studenti dataset. May we reject (at alpha=0.05) 
#the hypothesis mu=170 for female height?

data=read.table("studenti.txt", header=TRUE)

altezza=data[,5] 
genere=data[,2]
altf=altezza[genere==1]
hist(altf,freq = F)


qqnorm(altf)
qqline(altf, col = "steelblue", lwd = 2)

library(car)
car::qqPlot(altf)

shapiro.test(altf)
gen <- rnorm(2000, mean = 5, sd = 3)
qqPlot(gen)
shapiro.test(gen)

t.test(altf,mu=170)
#H_0 must be rejected

# (mean(altf)-170)/(sd(altf)/sqrt(length(altf))) # t statistic
# qt(0.975,length(altf)-1) # quantile 1-alpha/2 

#Two-tailed t-test on mean age of 'studenti' with diploma 'alt'. The null hypothesis is that mean age = 21 - We still assume Normal distribution for the population (even if other distributions could be fit better the data)
eta=data[,3] 
dipalt=data[,9]
etaalt=eta[dipalt==1]
hist(etaalt,freq = F)
t.test(etaalt,mu=21)
#We cannot reject H_0

