# Weighs 0 Bytes (or, does it? *moon men starts playing*)
library(corrplot) # guess
library(psych) # corPlot
library(car) # vrrrrrrom (per vif, multicollinearità)


# 0.1.
twist = read.csv("Dataset_N7.csv", header = T)
n = nrow(twist)
while ("twist" %in% search()) detach("twist")
attach(twist)


twist_sorted = twist[order(y_IQ), ]

head(twist_sorted)
tail(twist_sorted)


# 1.1.
summary(twist)
lista_variabili = list(
    y_IQ = y_IQ, x1_ISO = x1_ISO, x2_T = x2_T, x3_MP = x3_MP,
    x4_CF = x4_CF, x5_F = x5_F, x6_GSI = x6_GSI, x7_UA = x7_UA
)

cat(sprintf("%-8s %10.4s %10.4s\n", "", "StD", "Var"))
for (nome in names(lista_variabili)) {
    dati = lista_variabili[[nome]]
    cat(sprintf("%-8s %10.4f %10.4f\n", nome, sd(dati), var(dati)))
}

var_coeff_y = sd(y_IQ) / mean(y_IQ) * 100
var_coeff_y # around 15%

# Old timey person (or catto)
png(filename = "plottwists/boxplot_y.png", width = 4, height = 6, units = "in", res = 300, bg = "white")
    boxplot(y_IQ, notch = T, main = "Boxplot of y_IQ", ylab = "Value", xlab = "Dependent variable")
dev.off()

png(filename = "plottwists/boxplots_xs.png", width = 8, height = 6, units = "in", res = 250, bg = "white")
    boxplot(x1_ISO, x2_T, x3_MP, x4_CF, x5_F, x6_GSI, x7_UA,
        notch = TRUE,
        xlab = "Independent variable",
        ylab = "Value",
        main = "Boxplots of Xs",
        names = c("x1_ISO", "x2_T", "x3_MP", "x4_CF", "x5_F", "x6_GSI", "x7_UA")
    )
dev.off()


# 1.2.
# Creazione tabella frequenze per variabili continue
dati_frequenze_variabili = list()

for (nome in names(lista_variabili)) {
    dati = lista_variabili[[nome]]

    k = ceiling(1 + 3.3 * log10(n))

    minimo = min(dati)
    massimo = max(dati)

    ampiezza = (massimo - minimo) / k
    limiti = minimo + 0:k * ampiezza
    limiti_tag = limiti

    classi = cut(dati, breaks = limiti, right = FALSE, include.lowest = TRUE)
    frequenza = as.integer(table(classi))
    limite_sx = head(limiti_tag, -1)
    limite_dx = tail(limiti_tag, -1)
    frequenza_relativa = frequenza / n

    tab_freq = data.frame(
        variabile = sprintf("%.2f < %s < %.2f", limite_sx, nome, limite_dx),
        classe = seq_along(frequenza),
        frequenza = frequenza,
        frequenza_relativa = frequenza_relativa,
        frequenza_cumulata = cumsum(frequenza),
        frequenza_relativa_cumulata = cumsum(frequenza_relativa)
    )

    dati_frequenze_variabili[[nome]] = tab_freq
}

dati_frequenze_variabili

png(filename = "plottwists/hists.png", width = 8, height = 12, units = "in", res = 200, bg = "white")
    par(mfrow = c(4, 2))
        for (nome in names(lista_variabili)) {
            dati = lista_variabili[[nome]]

            hist(dati, main='', xlab=nome)
    }
dev.off()


png(filename = "plottwists/qq_normals.png", width = 8, height = 12, units = "in", res = 200, bg = "white")
    par(mfrow = c(4, 2))
        for (nome in names(lista_variabili)) {
            dati = lista_variabili[[nome]]

            shapiro_risultato = shapiro.test(dati)
            p_val = round(shapiro_risultato$p.value, 4)

            qqnorm(dati, main = nome)
            qqline(dati, col = "red")

            mtext(
                text = paste("p-val:", p_val),
                side = 1,
                line = -1.2,
                adj = 0.95,
                col = ifelse(p_val < 0.05, "red", "darkgreen"),
                cex = 0.85,
                font = 2
            )
        }
dev.off()


# 1.3.
pannello_lineare_e_quadratico = function(x, y, ...) {
    points(x, y, ...)
    abline(lm(y ~ x), col = "blue", lwd = 1.5)
    seq_x = seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = 100)
    modello_quadratico = lm(y ~ poly(x, 2, raw = TRUE))
    predizioni_y = predict(modello_quadratico, newdata = data.frame(x = seq_x))
    lines(seq_x, predizioni_y, col = "red", lwd = 2, lty = "dashed")
}

png(filename = "plottwists/scatters_y_vs_xs_lines.png", width = 10, height = 14, units = "in", res = 200, bg = "white")
    par(mfrow = c(4, 2))
        for (name in names(lista_variabili)) {
            if (name != "y_IQ") {
                data = lista_variabili[[name]]
                plot(data, y_IQ, main='', xlab=name, ylab="y_IQ", type="n")
                pannello_lineare_e_quadratico(data, y_IQ, pch=1, col="black")
            }
    }
dev.off()

independent_twist = twist
independent_twist$y_IQ = NULL

png(filename = "plottwists/scatters_all_lines.png", width = 14, height = 14, units = "in", res = 200, bg = "white")
    pairs(independent_twist,
        panel = pannello_lineare_e_quadratico,
        pch = 1,
        col = "black",
        cex = 0.7
    )
dev.off()

png(filename = "plottwists/x1_ISO_vs_y_IQ.png", width = 4, height = 4, units = "in", res = 400, bg = "white")
    plot(x1_ISO, y_IQ, type="n")
    pannello_lineare_e_quadratico(x1_ISO, y_IQ, pch=1, col="black")
dev.off()

png(filename = "plottwists/x7_UA_vs_x5_F.png", width = 4, height = 4, units = "in", res = 400, bg = "white")
    plot(x7_UA, x5_F, type="n")
    pannello_lineare_e_quadratico(x7_UA, x5_F, pch=1, col="black")
dev.off()


# 1.4.
cv = cov(twist)
cr = cor(twist)

png(filename = "plottwists/corrplot.png", width = 10, height = 10, units = "in", res = 200, bg = "white")
    corrplot(cr, method = "ellipse")
dev.off()
# corrplot.mixed(cr, number.cex=0.8, tl.cex=0.8)

png(filename = "plottwists/corrplot_heatmap.png", width = 10, height = 10, units = "in", res = 200, bg = "white")
    corPlot(cr, cex = 1.1, show.legend=TRUE, main="Correlation plot")
dev.off()




# 2.1.
# We'll do it R way.
fit0 = lm(y_IQ ~ ., data=twist); summary(fit0)                                                  # R²=0.8408; x4_CF, x5_F**, x7_UA
fit1 = lm(y_IQ ~ .-x7_UA, data=twist); summary(fit1)                                            # R²=0.8408; -x7_UA
fit2 = lm(y_IQ ~ .-x7_UA-x4_CF, data=twist); summary(fit2)                                      # R²=0.8371; -x4_CF

fit00 = lm(y_IQ ~ .^2, data=twist); summary(fit00)                                              # R²=0.859; x4_CF, x5_F.,x7_USA, .^2-{x3_MP:x4_CF.}
fit01 = lm(y_IQ ~ .-x7_UA-x4_CF+x3_MP:x4_CF, data=twist); summary(fit01)                        # R²=0.842; -x4_CF -x7_UA -.^2-{x3_MP:x4_CF}

fit000 = lm(y_IQ ~ .^2+I(x7_UA^2), data=twist); summary(fit000)                                 # R²=0.8672; x4_CF., x5_F, x7_UA, x7_UA^2*, .^2
fit001 = lm(y_IQ ~ .+I(x7_UA^2)-x5_F-x7_UA, data=twist); summary(fit001)                        # R²=0.8488; x4_CF, x7_UA^2***; -x5_F -x7_UA -.^2
fit002 = lm(y_IQ ~ .+I(x7_UA^2)-x4_CF-x5_F-x7_UA, data=twist); summary(fit002)                  # R²=0.8456; -x4_CF
fit003 = lm(y_IQ ~ .+I(x7_UA^2)-x4_CF-x7_UA, data=twist); summary(fit003)                       # R²=0.8462; x7_UA^2*, x5_F; +x5_F

fit0000 = lm(y_IQ ~ .^2+I(x2_T^2)+I(x7_UA^2), data=twist); summary(fit0000)                     # R²=0.8899; x4_CF., x5_F, x7_UA, x7_UA^2*, .^2
fit0001 = lm(y_IQ ~ .+I(x2_T^2)+I(x7_UA^2)-x5_F-x7_UA, data=twist); summary(fit0001)            # R²=0.869; x4_CF, x7_UA^2***; -x5_F -x7_UA -.^2
fit0002 = lm(y_IQ ~ .+I(x2_T^2)+I(x7_UA^2)-x4_CF-x5_F-x7_UA, data=twist); summary(fit0002)      # R²=0.8666; -x4_CF
fit0003 = lm(y_IQ ~ .+I(x2_T^2)+I(x7_UA^2)-x4_CF-x7_UA, data=twist); summary(fit0003)           # R²=0.8667; x7_UA^2*, x5_F; +x5_F


a_fist_full_of_fits = list(
    fit0 = fit0,
    fit1 = fit1,
    fit2 = fit2,
    fit00 = fit00,
    fit01 = fit01,
    fit000 = fit000,
    fit001 = fit001,
    fit002 = fit002,
    fit003 = fit003,
    fit0000 = fit0000,
    fit0001 = fit0001,
    fit0002 = fit0002,
    fit0003 = fit0003
)

cool_fits = list(
    fit1 = fit1,
    fit01 = fit01,
    fit001 = fit001,
    fit002 = fit002,
    fit0001 = fit0001,
    fit0002 = fit0002
)


# 2.2.
confronto_modelli = data.frame(
    RSS            = sapply(a_fist_full_of_fits, function(m) deviance(m)),
    R2             = sapply(a_fist_full_of_fits, function(m) summary(m)$r.squared),
    R2a            = sapply(a_fist_full_of_fits, function(m) summary(m)$adj.r.squared),
    Fstat          = sapply(a_fist_full_of_fits, function(m) summary(m)$fstatistic["value"]),    
    AIC            = sapply(a_fist_full_of_fits, function(m) AIC(m)),
    BIC            = sapply(a_fist_full_of_fits, function(m) BIC(m))
)
print(confronto_modelli)


# 2.3.
for (i in 1:4) {
    png(filename = sprintf("plottwists/diagnostics_%d.png", i), width = 8, height = 12, units = "in", res = 200, bg = "white")
    par(mfrow = c(3, 2))
    for (name in names(cool_fits)) {
        fit = cool_fits[[name]]

        if (i < 4) {
            if (i == 2) {
                residui = residuals(fit)
                shapiro_risultato = shapiro.test(residui)
                p_val = round(shapiro_risultato$p.value, 4)

                residui_standardizzati = rstandard(fit)
                qqnorm(residui_standardizzati, main = name)
                qqline(residui_standardizzati, col = "red")

                mtext(
                    text = paste("p-val:", p_val),
                    side = 1,
                    line = -1.2,
                    adj = 0.95,
                    col = ifelse(p_val < 0.05, "red", "darkgreen"),
                    cex = 0.85,
                    font = 2
                )
            } else {
                plot(fit, which = i, main = name)
            }
        } else {
            cook = cooks.distance(fit)
            threshold = 4 / nobs(fit)

            plot(cook, type = "h", main = name, ylim = c(0, 0.13), xlab = "Obs. number", ylab = "Cook's distance")

            abline(h = threshold, col = "red", lty = 2) # Seizing the means of production

            influential = which(cook > threshold)

            text(influential, cook[influential], labels = influential, pos = 3, cex = 0.8)
        }
    }
    dev.off()
}

shapiro.test(residuals(fit0002))    # gotta see if it's normal
shapiro.test(residuals(fit001))     # gotta see if it's normal

FLAG = fit0002 # Fits Like A Glove


png(filename = "plottwists/diagnostics_FLAG.png", width = 10, height = 10, units = "in", res = 200, bg = "white")
    par(mfrow = c(2, 2))
    plot(FLAG)
dev.off()



pole = residuals(FLAG)

vif(fit0002) # variance inflation factor, multicollinearità
vif(fit0000)

# 2.4.
# a small step for a man crrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr, a giant leap for mankind crrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
stepwise_formula_full = y_IQ ~ (x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA)^2 +
    I(x1_ISO^2) + I(x2_T^2) + I(x3_MP^2) + I(x4_CF^2) +
    I(x5_F^2) + I(x6_GSI^2) + I(x7_UA^2)
stepwise_formula_mid = y_IQ ~ x1_ISO + x2_T + x3_MP + x4_CF + x5_F + x6_GSI + x7_UA
stepwise_formula_null = y_IQ ~ 1
stepwise_scope = list(lower = stepwise_formula_null, upper = stepwise_formula_full)

stepwise_full = lm(stepwise_formula_full, data = twist)
stepwise_mid = lm(stepwise_formula_mid, data = twist)
stepwise_null = lm(stepwise_formula_null, data = twist)

ffs_backward_bic = step(
    stepwise_full,
    scope = stepwise_scope,
    direction = "backward",
    trace = 1,
    k = log(n)
)
summary(ffs_backward_bic)

ffs_forward_bic = step(
    stepwise_null,
    scope = stepwise_scope,
    direction = "forward",
    trace = 1,
    k = log(n)
)
summary(ffs_forward_bic)

ffs = step(
    stepwise_mid,
    scope = stepwise_scope,
    direction = "both",
    trace = 1,
    k = log(n)
)
summary(ffs)

ffs_backward_aic = step(
    stepwise_full,
    scope = stepwise_scope,
    direction = "backward",
    trace = 1,
    k = 2
)
summary(ffs_backward_aic)

ffs_forward_aic = step(
    stepwise_null,
    scope = stepwise_scope,
    direction = "forward",
    trace = 1,
    k = 2
)
summary(ffs_forward_aic)

ffs_aic = step(
    stepwise_mid,
    scope = stepwise_scope,
    direction = "both",
    trace = 1,
    k = 2
)
summary(ffs_aic)

stepwise_fits = list(
    backward_bic = ffs_backward_bic,
    forward_bic = ffs_forward_bic,
    both_bic = ffs,
    backward_aic = ffs_backward_aic,
    forward_aic = ffs_forward_aic,
    both_aic = ffs_aic
)

stepwise_confronto = data.frame(
    SQE   = sapply(stepwise_fits, function(m) deviance(m)),
    R2    = sapply(stepwise_fits, function(m) summary(m)$r.squared),
    R2a   = sapply(stepwise_fits, function(m) summary(m)$adj.r.squared),
    Fstat = sapply(stepwise_fits, function(m) summary(m)$fstatistic["value"]),
    AIC   = sapply(stepwise_fits, function(m) AIC(m)),
    BIC   = sapply(stepwise_fits, function(m) BIC(m))
)
print(stepwise_confronto)
lapply(stepwise_fits, formula)

# 2.5.
confint(FLAG)
confint(ffs_backward_aic)
confint(ffs_aic)

plot_confidence_intervals = function(fit, filename, title, width = 6, height = 4) {
    png(filename = filename, width = width, height = height, units = "in", res = 200, bg = "white")
        par(mfrow = c(1, 1))
        c0 = coef(fit)
        cc = confint(fit)

        parametri = seq_along(c0)[-1]
        etichette_parametri = names(c0)[parametri]
        etichette_parametri = sub("^I\\((.*)\\)$", "\\1", etichette_parametri)

        stima = c0[parametri]
        limite_inf = cc[parametri, 1]
        limite_sup = cc[parametri, 2]
        y_pos = rev(seq_along(parametri))

        x_lim = range(c(0, limite_inf, limite_sup))
        x_pad = diff(x_lim) * 0.05
        if (x_pad == 0) x_pad = 1
        x_lim = x_lim + c(-x_pad, x_pad)

        old_par = par(no.readonly = TRUE)
        par(mar = c(5, 8, 4, 2) + 0.1)

        plot(
            stima, y_pos,
            xlim = x_lim,
            ylim = c(0.5, length(parametri) + 0.5),
            axes = FALSE,
            xlab = "Estimated coefficient",
            ylab = "",
            pch = 19,
            main = title
        )
        abline(v = 0, col = "gray60", lty = 2)
        segments(limite_inf, y_pos, limite_sup, y_pos)
        segments(limite_inf, y_pos - 0.08, limite_inf, y_pos + 0.08)
        segments(limite_sup, y_pos - 0.08, limite_sup, y_pos + 0.08)
        points(stima, y_pos, pch = 19)
        axis(side = 1)
        axis(side = 2, at = y_pos, labels = etichette_parametri, las = 1)
        box(bty = "l")

        par(old_par)
    dev.off()
}

plot_confidence_intervals(
    FLAG,
    "plottwists/confidence_intervals.png",
    "Confidence Intervals for Parameter Estimates"
)
plot_confidence_intervals(
    ffs_backward_aic,
    "plottwists/confidence_intervals_backward_aic.png",
    "Confidence Intervals - backward AIC",
    height = 7
)
plot_confidence_intervals(
    ffs_aic,
    "plottwists/confidence_intervals_both_aic.png",
    "Confidence Intervals - both AIC"
)
