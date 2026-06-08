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
lista_variabili <- list(
  y_IQ = y_IQ, x1_ISO = x1_ISO, x2_T = x2_T, x3_MP = x3_MP, 
  x4_CF = x4_CF, x5_F = x5_F, x6_GSI = x6_GSI, x7_UA = x7_UA
)

for(nome in names(lista_variabili)) {
    dati = lista_variabili[[nome]]

    hist(dati, main='', xlab=nome)
}

dev.new()
par(mfrow = c(4, 2))

for(nome in names(lista_variabili)) {
  
  dati <- lista_variabili[[nome]]
  
  shapiro_risultato <- shapiro.test(dati)
  p_val <- round(shapiro_risultato$p.value, 4)
  
  qqnorm(dati, main = nome)
  qqline(dati, col = "red")
  
  mtext(text = paste("p-val:", p_val), 
        side = 1, 
        line = -1.2, 
        adj = 0.95,
        col = ifelse(p_val < 0.05, "red", "darkgreen"), 
        cex = 0.85, 
        font = 2) 
}

par(mfrow = c(1, 1))




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
for (name in names(lista_variabili)) {
    if (name != "y_IQ") {
        data = lista_variabili[[name]]
        
        plot(data, y_IQ, 
            main = '',
            xlab = name, 
            ylab = "y_IQ",
            pch = 19,
            col = "blue")

        abline(lm(y_IQ ~ data), col = "red", lwd = 2)
        seq_x <- seq(min(data, na.rm = TRUE), max(data, na.rm = TRUE), length.out = 100)
        modello_quadratico <- lm(y_IQ ~ poly(data, 2, raw = TRUE))
        predizioni_y <- predict(modello_quadratico, newdata = data.frame(data = seq_x))
        lines(seq_x, predizioni_y, col = "darkblue", lwd = 3, lty = 3)
    }
}

independent_twist = twist
independent_twist$y_IQ = NULL
plot(independent_twist)


pannello_lineare_e_quadratico <- function(x, y, ...) {
    points(x, y, ...)
    abline(lm(y ~ x), col = "blue", lwd = 1.5)
    seq_x <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = 100)
    modello_quadratico <- lm(y ~ poly(x, 2, raw = TRUE))
    predizioni_y <- predict(modello_quadratico, newdata = data.frame(x = seq_x))
    lines(seq_x, predizioni_y, col = "red", lwd = 2, lty = "dashed")
}

pairs(twist, 
      panel = pannello_lineare_e_quadratico, 
      pch = 1, 
      col = "black", 
      cex = 0.7)

# 1.6.
cv = cov(twist)
cr = cor(twist)
corrplot(cr, method = 'ellipse')
corrplot.mixed(cr, number.cex=0.8, tl.cex=0.8)

corPlot(cr, cex = 1.1, show.legend=TRUE, main="Correlation plot")



plot(x1_ISO, y_IQ)

plot(x5_F, x7_UA)




# 2.

fit1 = lm()
residuals(fit1)
confint(fit1)







# 99.

reg = lm(y_IQ ~ x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA, data = twist); summary(reg)
fff = step(lm(y_IQ ~ x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA + I(x1_ISO^2) + I(x2_T^2) + I(x3_MP^2) + I(x4_CF^2) + I(x5_F^2) + I(x6_GSI^2) + I(x7_UA^2) + (x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA)^2, data = twist), direction = "both", trace = 1, k = log(n)); summary(fff)
