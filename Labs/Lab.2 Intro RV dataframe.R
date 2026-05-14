# Introduction to R
# Fabio Postiglione (fpostiglione@unisa.it)

### Random variables

set.seed(1303) # to reproduce a specific sequence of pseudo-random numbers
rnorm(50)

set.seed (3)
y=rnorm (100)
mean(y) #[1] 0.0110
var(y) #[1] 0.7329
sqrt(var(y)) #[1] 0.8561
sd(y)

#### Graphics
x=rnorm(50)
y=x+rnorm(50,mean=50,sd=.1)
cor(x,y)
dev.new()
plot(x,y)
lm(y~x)
abline(50,0.999,col='green') # line y=a*x+b

x=rnorm(100)
y=rnorm(100)
dev.new()
plot(x,y)
plot(x,y,xlab="this is the x-axis",ylab="this is the y-axis",
     main="Plot of X vs Y")
pdf("Figure.pdf")
plot(x,y,col="green")
dev.off()
png("Figure.png")
plot(x,y,col="red")
dev.off()
dev.new()
plot(x,y,xlab="this is the x-axis",ylab="this is the y-axis",
     main="Plot of X vs Y")
dev.print(device=pdf, "FigBlack.pdf")
dev.new()
plot(x,y,xlab="this is the x-axis",ylab="this is the y-axis",
     main="Plot of X vs Y", col="blue")
dev.print(device=jpeg, "FigBlue.jpeg",width=400,height=400)

######
x=seq(-pi,pi,length=50)
y=x
f=outer(x,y,function (x,y) cos(y)/(1+x^2))
dev.new()
contour (x,y,f)
dev.print(device=pdf, "contour.pdf")

dev.new()
persp(x,y,f,theta=30)
persp(x,y,f,theta=30,phi=40)
dev.print(device=pdf, "persp.pdf")

# Bivariate Normal
#install.packages("mvtnorm")
#install.packages("MASS")

library(mvtnorm)
library(MASS)
x=seq(-8,8,length=50)
y=x
fbn=outer(x,y,function(x,y)dmvnorm(cbind(x,y),mean = rep(1,2),sigma=matrix(c(1, .5, .5, 1), 2)))
fbn2=outer(x,y,function(x,y)dmvnorm(cbind(x,y),mean = rep(0,2),sigma=matrix(c(1, 0, 0, 1), 2))) # sigma=diag(2)

dev.new()
par(mfrow=c(1,2))
contour(x,y,fbn)
persp(x,y,fbn,theta = -30, phi = 25, 
      shade = 0.75, col = "gold", expand = 0.5, r = 2, 
      ltheta = 25, ticktype = "detailed")
dev.print(device=pdf, "BivarCorr.pdf")

dev.new()
par(mfrow=c(1,2))
contour(x,y,fbn2)
persp(x,y,fbn2,theta = -30, phi = 25, 
      shade = 0.75, col = "gold", expand = 0.5, r = 2, 
      ltheta = 25, ticktype = "detailed")
dev.print(device=pdf, "BivarInd.pdf")


#### Loading Data
Auto=read.table("Auto.data") # names not recognized
Auto=read.table("Auto.data",header=T,na.strings="?")
# Auto=read.csv("Auto.csv",header=T,na.strings ="?")
head(Auto)
dim(Auto)
dim(na.omit(Auto))
# unique(unlist (lapply (Auto, function (x) which (is.na (x))))) #To find all the rows in a data frame with at least one NA
Auto=na.omit(Auto)
dim(Auto)
names(Auto)

#### Additional Graphical and Numerical Summaries
dev.new()
plot(cylinders , mpg)
plot(Auto$cylinders , Auto$mpg )
dev.print(device=pdf, "MpgVsCyl.pdf")

attach(Auto)
plot(cylinders , mpg)
cylinders = as.factor(cylinders)
plot(cylinders, mpg)
plot(cylinders, mpg, col="red")
plot(cylinders, mpg, col="red", varwidth=T)
plot(cylinders, mpg, col="red", varwidth=T, horizontal=T)
plot(cylinders, mpg, col="red", varwidth=T, xlab="cylinders", ylab="MPG")
dev.print(device=pdf, "BoxPlotMpg.pdf")

hist(mpg)
hist(mpg, breaks=15)
dev.print(device=pdf, "HistMpg.pdf")


dev.new()
par(mfrow=c(2,1))
hist(mpg, las=1, freq=F,xlab="MPG",ylab="", main="Istogramma MPG",col="blue", xlim=c(0,50))
lines(density(mpg),lwd=2,col="red")
rug(mpg,lwd=0.25,side=1,col="green")
boxplot(mpg, horizontal=T, xlab="MPG",ylab="", main="Box-plot MPG", ylim=c(0,50)) # notice ylim!!
dev.print(device=pdf, "BoxPlotHistMpg.pdf")

dev.new()
plot(horsepower,mpg)
pairs(Auto)
dev.new()
pairs(~mpg+displacement+horsepower+weight+acceleration, data=Auto)
dev.print(device=pdf, "Pairs.pdf")

plot(horsepower, mpg)
identify(horsepower, mpg, name)

summary(Auto)

summary (mpg)



##############################
####   Intro dataframe    ####
##############################


#Dataframes
mydf=data.frame(id=c(1,2,3), name=c('Mario','Giulia','Fabio'), sex=c('m','f','m'), age=c(20,24,28)) 
#create a dataframe with heterogeneous information
mydf$age   #extract the column “age”
mydf$age=NULL   #delete the column "age"
mydf[1:2,]   #select the first two rows and all the columns
mydf[-c(2,3)]  #exclude the second and third columns (variables)
mydf[mydf$sex == 'm', ]  #select male persons


mydf=data.frame(id=c(1,2,3), name=c('Mario','Giulia','Fabio'), sex=c('m','f','m'), age=c(20,24,22)) 
mydf[order(mydf[,'age']), ]    #order the dataframe by age

colnames(mydf)[2]='nome'    #rename the second column of the dataframe in "nome"

summary(mydf)  # summarized info (min, max, median etc)

str(mydf)   #type of the variables composing the dataframe

mydf$id=as.character(mydf$id)   #converts in char the column “id”


#Strings/Dates
str1='hello'
str2='world'
paste(str1, str2)  #string union (with space)
paste0(str1, str2)  # string union (with no space)
mystr=c('ciao', 'test') #creates a string made of 2 elements

strsplit(mystr, split = ' ')   #separates string elements based on spaces

grep(pattern = 'st', mystr, ignore.case=TRUE)   #seeks for “st” group (ignoring upper/lower case)

mytime=Sys.time() ; mydate=Sys.Date()  #saves current time/date

#Derivatives
D(expression(x^2-3*x+4),"x")   #Calculates the first derivative

D(expression(log(x-2)+3*x*y),"x")  #Derivative w.r.t. "x"

D(expression(log(x-2)+3*x*y),"y")  #Derivative w.r.t. "y"

#Roots of polynomials
#Search for roots of the following polynomial: 1*x^3 −4x^2 +4x=0; 
coeff=c(0,4,-4,1)  #create the vector of coefficients 
polyroot(coeff)

#Create a Function
myfun_sum=function(x,y) 
{
   x+y
} 

myfun_sum(4,5)   #creates a function 

#IF-ELSE Structure
x=-10
if (x<0)  {  print ("the number is negative")  }    else  {print ("the number is non negative")  }

#For Structure
vect=c(1:10) 
for  (v in vect) 
{print(v)}  

#Data Rescaling min_max_norm is the simplest normalization method with a [0,1] rescaling
min_max_norm = function(x) {
   num = x - min(x)
   denom = max(x) - min(x)
   return (num/denom)
}

mean_norm = function(x) {
   num = x - mean(x)
   denom = max(x) - min(x)
   return (num/denom)
}

myds=read.csv('cars.csv')   #loads the cars dataset
View(myds)
#normalize the cylinders variable
min_max_norm(myds$cylinders)
#mean_norm(myds$cylinders)



###Read Dataset from text file and operate on it by dplyr or base packages
students=read.table("studenti.txt", header=TRUE)  #import the "studenti" dataset

#Dichotomic variables (e.g. 0/1)
#Absolute and relative frequencies for male and female students
genere=students[,2]
stud_male=sum(genere==0)   #abs. freq. male students

stud_female=sum(genere==1) #abs. freq. female students

freq_male=stud_male/(stud_male+stud_female)  #Rel. Freq. male students

perc_male=freq_male*100; perc_male
#A more immediate way through TABLE command
table(students$genere)
#Freq. distribution of eta through histogram
hist(students$eta)
hist(students$eta,breaks=c(seq(ceiling(min(students$eta))-1,round(max(students$eta)),1),65))
#Freq. distribution of peso per genre
peso_m=students$peso[genere==0]
peso_f=students$peso[genere==1]
dev.new()
par(mfrow=c(2,1))
hist(peso_m, freq=F, xlab='Studenti', main='Distribuz. peso studenti')
hist(peso_f, freq=F, xlab='Studentesse', main='Distribuz. peso studentesse')
dev.print(device=pdf, "histMF.pdf")


####SOME MATH PLOTS
#Plot a cubic polynomial with x in (-3,3); lwd=line width, lty=line style
dev.new()
curve(3*x^3-8*x^2+2*x+10, xlab='x', ylab='mycurve', from=-3, to=3, lwd=5, lty=1, col="blue")
#Add a second function in green
curve(10*x^2+30*x+1, from=-3, to=3, lwd=5, add=TRUE, lty=1, col="green")
#Add a legend
legend("bottomright", legend=c("Cubica","Parabola"), col=c("blue","green"), lwd=5)
dev.print(device=pdf, "CubPar.pdf")


# Legge dei grandi numeri - LLN
g1 <- rnorm(50,mean=3,sd=3) # dnorm, pnorm, qnorm...
h1<-hist(g1)
sum(g1)/length(g1)
mean(g1)
g1 <- rnorm(50,mean=3,sd=3) # altra generazione di numeri casuali
h1<-hist(g1) # diverso dal precedente
sum(g1)/length(g1)
mean(g1) # valore diverso dal precedente

g1 <- rnorm(1000,mean=3,sd=3)
h1<-hist(g1)
sum(g1)/length(g1)
mean(g1)
# g1 <- rnorm(10000,mean=3,sd=3)
# h1<-hist(g1)
# sum(g1)/length(g1)
# mean(g1)

g1 <- rnorm(100000,3,3) # aumentiamo il campione
h1<-hist(g1,freq = F)
xg<- seq(-8,14, length.out = 10000)
mg = mean(g1)
vg <- var(g1)
yg <- dnorm(xg,mean = mg, sd=sqrt(vg))
matplot(xg,yg, lty=3, add=T, col="blue", type="l")
dev.print(device=pdf, "histNorm.pdf")

# esempio con uniforme
x <- runif(100,0,2)
h<-hist(x)
dev.print(device=pdf, "Unif100.pdf")

x1 <- runif(100000,0,2)
h1<-hist(x1,freq = F)
dev.print(device=pdf, "Unif100000.pdf")

# CLT con uniformi iid
x2 <- runif(100000,0,2)
h2<-hist(x1+x2,freq = F)
dev.print(device=pdf, "Unif_2.pdf")

x3 <- runif(100000,0,2)
h3<-hist(x1+x2+x3,freq = F)
dev.print(device=pdf, "Unif_3.pdf")

x4 <- runif(100000,0,2)
h4<-hist(x1+x2+x3+x4,freq = F)
dev.print(device=pdf, "Unif_4.pdf")

x5 <- runif(100000,0,2)
h5<-hist(x1+x2+x3+x4+x5,freq = F, ylim = c(0,0.35))
msum <- mean(x1+x2+x3+x4+x5)
sdsum <- sd(x1+x2+x3+x4+x5) #sqrt(5/3)
ysum <- dnorm(xg,mean = msum, sd=sdsum)
matplot(xg,ysum,pch=2, lty=1, add=T, col="blue", type="l")
dev.print(device=pdf, "Unif_5.pdf")

# CLT con z norm.std
zz <- ((x1+x2+x3+x4+x5)/5-1)/sqrt(1/15) #mean(xbar)=1, var=(1/3)/5
hz<-hist(zz,freq = F,  ylim = c(0,0.5))
xz <- seq(-4,4, length.out = 1000)
yz <- dnorm(xz,mean = 0, sd=1)
matplot(xz,yz,pch=2, lty=1, add=T, col="red", type="l")
dev.print(device=pdf, "CLT.pdf")

