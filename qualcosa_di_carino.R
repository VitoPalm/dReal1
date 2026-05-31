# Weighs 0 Bytes (or, does it? *moon men starts playing*)
library(corrplot)       # guess
library(psych)          # corPlot


# 0.1.
twist = read.csv("Dataset_N7.csv", header=T)
n = nrow(twist)
attach(twist)


# 1.1.
twist_sorted = twist[order(y_IQ), ]

head(twist_sorted)
tail(twist_sorted)


# 1.2.
summary(twist)


# 1.3.
hist(y_IQ)
hist(x1_ISO)
hist(x2_T)
hist(x3_MP)
hist(x4_CF)
hist(x5_F)
hist(x6_GSI)
hist(x7_UA)


# 1.4.
boxplot(y_IQ, notch=T)
boxplot(x1_ISO, x2_T, x3_MP, x4_CF, x5_F, x6_GSI, x7_UA,
        notch = TRUE,
        xlab = 'Independent variable',
        ylab = 'Value',
        main = 'Boxplots of Xs',
        names = c("x1_ISO", "x2_T", "x3_MP", "x4_CF", "x5_F", "x6_GSI", "x7_UA")
)


# 1.5.
plot(x1_ISO, y_IQ)
plot(x2_T, y_IQ)
plot(x3_MP, y_IQ)
plot(x4_CF, y_IQ)
plot(x5_F, y_IQ)
plot(x6_GSI, y_IQ)
plot(x7_UA, y_IQ)

independent_twist = twist
independent_twist$y_IQ = NULL
plot(independent_twist)

plot(x7_UA, x5_F)
plot(x4_CF, x5_F)
plot(x5_F, x3_MP)
plot(x1_ISO, x2_T)

# plot(twist)


# 1.6.
cv = cov(twist)
cr = cor(twist)
corrplot(cr, method = 'ellipse')
corrplot.mixed(cr, number.cex=0.8, tl.cex=0.8)

corPlot(cr, cex = 1.1, show.legend=TRUE, main="Correlation plot")



plot(x1_ISO, y_IQ)

plot(x5_F, x7_UA)



# 99.
reg = lm(y_IQ ~ x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA, data = twist); summary(reg)
fff = step(y_I, lm(y_IQ ~ x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA + I(x1_ISO^2) + I(x2_T^2) + I(x3_MP^2) + I(x4_CF^2) + I(x5_F^2) + I(x6_GSI^2) + I(x7_UA^2) + (x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA)^2, data = twist), direction = "both", trace = 1, k = log(n)); summary(fff)
