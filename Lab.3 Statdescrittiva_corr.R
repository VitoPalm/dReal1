## Statistica descrittiva

# moda, mediana, media
dati=read.table("studenti.txt", header=TRUE)
View(dati)
tabulate(dati$altezza)
moda <- which.max(tabulate(dati$altezza)); moda
mediana <- median(dati$altezza); mediana
media <- mean(dati$altezza); media

# robustezza mediana agli outlier
median(c(1,2,3,10,13))
mean(c(1,2,3,10,13))
median(c(1,2,3,10,13000))
mean(c(1,2,3,10,13000))

# quantili
quantile(dati$altezza,probs=c(0.25,0.50,0.75)) #quartili
quantile(dati$altezza,probs=(1:9)/10) #decili
#fivenum(dati$altezza)
print(summary(dati$altezza))
#range (min ; max)
range(dati$altezza)
diff(range(dati$altezza)) # escursione campionaria

# Statistica descrittiva

##
## condizionamento di una var. qualitativa
##
dev.new()
plot(dati$diploma,dati$altezza) # no ---> error
plot(as.factor(dati$diploma),dati$altezza) # ok if we encode the categorical variable as factor 

boxplot(dati$altezza~dati$diploma, col=gray(c(0.3,0.4,0.5,0.6)), varwidth=TRUE,notch=TRUE, xlab='Tipo diploma', ylab="Altezza", names=c("altri","classico","scientifico","tecnico"))
# con solo donne
dev.new()
boxplot(dati[dati[,"genere"]==1,]$altezza~dati[dati[,"genere"]==1,]$diploma, col=gray(c(0.3,0.4,0.5,0.6)), varwidth=TRUE,notch=TRUE, xlab='Tipo diploma', ylab="Altezza", main="Solo donne", names=c("altri","classico","scientifico","tecnico"))
# con solo uomini
dev.new()
boxplot(dati[dati[,"genere"]==0,]$altezza~dati[dati[,"genere"]==0,]$diploma, col=gray(c(0.3,0.4,0.5,0.6)), varwidth=TRUE,notch=TRUE, xlab='Tipo diploma', ylab="Altezza", main="Solo uomini", names=c("altri","classico","scientifico","tecnico"))

##
## Scatter plots
##
plot(dati$genere, dati$altezza) # risp. a 0 e 1
plot(as.factor(dati$genere), dati$altezza) # genere as factor

plot(dati$peso,dati$altezza)
plot(dati$altezza~dati$peso, xlim=c(20,120), ylim=c(140,200))
abline(134,0.55,col='red',lwd=3) #summary(lm(dati$altezza~dati$peso))

# jittered scatter plot
genere=dati[,2]; n=length(genere)
peso=dati[,4]; altezza=dati[,5]
colgen=ifelse(genere==1,"red","blue") # differenti colori
pchgen=ifelse(genere==1,20,21) # differenti simboli
altezza=altezza+0.25*rnorm(n) # altezza jittered
peso=peso+0.25*rnorm(n) # peso jittered
plot(altezza~peso, xlim=c(20,120), ylim=c(140,200), col=colgen, pch=pchgen)

numdati <- dati[,2:12]
covvv <- round(cov(numdati), digits = 2)
View(covvv)
cc <- round(cor(numdati), digits = 2)
View(cc)

realdati <- dati[,c(3,4,5,10)]
dev.new()
pairs(realdati)

#install.packages("corrplot") # se non installato in R
library(corrplot)
corrplot(cc,method = 'ellipse')
corrplot.mixed(cc,order='original',number.cex=1, upper="ellipse")

#utile per salvare figure in pdf...
pdf(paste0("corrplot_","stud",".pdf"))
corrplot.mixed(cc,order='original',number.cex=1)
dev.off()

corrplot(round(cor(realdati), digits = 2),method = 'ellipse')
corrplot.mixed(round(cor(realdati), digits = 2),order='original',number.cex=1, upper="ellipse")

#install.packages("psych") # se non installato in R
library(psych)
dev.new()
corPlot(round(cor(realdati), digits = 2), cex = 1.1, show.legend=TRUE, main="Correlation plot")

# correlazione nulla e dipendenza quadratica
set.seed(150) # seed fissato per esigenze di riproducibilita'
x <- runif(100,-4,4)
y <- x^2+rnorm(100,0,1)
dev.new()
plot(x,y)
cor(x,y)

