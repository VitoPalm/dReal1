***Sounds About rrrRight***

# 0. Introduzione al Progetto
Questo progetto si svolge nel più ampio contesto del corso di Statistica Applicata nel CdL in Ingegneria Informatica all'Università di Salerno.

Ci è stato fornito un dataset rappresentativo di un campione dei quali elementi consideriamo 8 caratteristiche, una di queste è espressa come dipendente dalle altre.

L'obbiettivo di questa attività è quello di svolgere un'analisi statistica descrittiva sui dati forniti, per poi procedere con una fase di regressione lineare multipla, al fine di identificare un modello che possa spiegare al meglio la variabilità della variabile dipendente in funzione delle altre caratteristiche.

Al termine dell'attività potremo fornire a un ipotetico operatore le conoscenze necessarie per ottimizzare la procedura di acquisizioni di immagini da UAV.

# 1. Analisi Statistica Descrittiva
Nella sezione di Statistica Descrittiva andremo a utilizzare una serie di strumenti per valutare la natura dei dati forniti. Questi strumenti permettono di ottenere insight sui dati presentati, che verranno usati per guidare le fasi successive del progetto.

Il campione in analisi è costituito da 100 (`n = nrow(ds)`) elementi di cui sono definite 8 caratteristiche di natura quantitativa continua.

Per avere un'idea limitata ma immediata della natura dei dati, abbiamo visualizzato i valori iniziali e finali del campione, ordinati secondo la variabile dipendente `y_IQ`.

```R console
> head(twist_sorted)
      y_IQ      x1_ISO       x2_T       x3_MP
  85.76275  1.71051927  1.2694487 -1.60960262
  89.37733  0.47531620  1.6607291  0.01548673
  91.74121  1.61621307  1.6178761  0.94264143
  94.66445  1.43905003  1.4720261 -1.06032801
 101.76777  0.01069104  1.5602105 -1.71690096
 104.91759  1.40622836  0.6077778  0.20020511
     x4_CF        x5_F     x6_GSI       x7_UA
-0.5973638  1.21935086  0.9950725  -1.2313230
-0.3395450  2.11793190  1.5027906  -1.6492509
-1.5664503 -1.95141132  0.7572437  -0.2628265
 0.7965453  0.03008541 -0.6582414  -0.7980054
 1.2178391  0.46207915  0.7841440  -1.1420552
-0.1788123  1.62989182  0.4556526   1.4947013

> tail(twist_sorted)
      y_IQ     x1_ISO        x2_T      x3_MP 
  166.9723  0.1009377 -0.09395068  1.2803254 
  168.0356 -0.2722747  0.58255508 -0.3704142 
  172.9470 -1.7186148 -1.02359897  1.4190216 
  174.0162 -1.0760703 -1.57173461  1.4307073 
  178.1100 -1.6223626 -1.28167295  0.3701268 
  181.1781 -1.6345881 -1.50141175  0.2449209 
     x4_CF       x5_F     x6_GSI       x7_UA
-0.1025210 -0.8338555 -0.7336588 -0.19635859
-0.4599907 -0.3538943 -1.6650442  0.46473235
-1.5514532 -1.4660646 -1.4374694  0.79578587
 0.3972056 -0.9538855 -0.6366092 -0.08404836
 0.7842828 -0.8365009 -0.2303526  0.29413924
 1.3692702 -0.7514527 -1.0163686 -0.88874785
```

## 1.1. Summary & Whiskerrrrrrs
Prima di tutto valutiamo gli indici di tendenza centrale (media e mediana) e di dispersione (deviazione standard) per tutte le caratteristiche del dataset.

```R console
> summary(twist)
      y_IQ                x1_ISO                x2_T            
 Min.   :  85.76      Min.   :-1.71861     Min.   :-1.57489     
 1st Qu.: 117.65      1st Qu.:-0.60159     1st Qu.:-0.91172     
 Median : 135.13      Median : 0.08236     Median :-0.10059     
 Mean   : 134.27      Mean   : 0.06321     Mean   :-0.04587     
 3rd Qu.: 148.53      3rd Qu.: 0.90001     3rd Qu.: 0.69212     
 Max.   : 181.18      Max.   : 1.72094     Max.   : 1.66073     
     x3_MP                x4_CF                 x5_F         
 Min.   :-1.7278494   Min.   :-1.65848     Min.   :-2.1460   
 1st Qu.:-0.7305715   1st Qu.:-0.71533     1st Qu.:-0.7686   
 Median : 0.0963404   Median :-0.08772     Median :-0.1531   
 Mean   :-0.0002303   Mean   :-0.02413     Mean   : 0.0000   
 3rd Qu.: 0.7124093   3rd Qu.: 0.81905     3rd Qu.: 0.6915   
 Max.   : 1.7311851   Max.   : 1.72493     Max.   : 2.4726   
     x6_GSI             x7_UA       
 Min.   :-1.71454     Min.   :-1.6839 
 1st Qu.:-0.90640     1st Qu.:-1.0527 
 Median :-0.30275     Median :-0.1906 
 Mean   :-0.09797     Mean   :-0.1496 
 3rd Qu.: 0.78453     3rd Qu.: 0.6444 
 Max.   : 1.70911     Max.   : 1.6263 
```

```R console
y_IQ        20.3977
x1_ISO       1.0159
x2_T         0.9618
x3_MP        0.9746
x4_CF        0.9741
x5_F         1.0000
x6_GSI       0.9879
x7_UA        0.9997
```

Notiamo che le variabili indipendenti presentano una derivazione standard prossima ad 1, ed una media prossima a 0, il che suggerisce che si possa trattare di dati standardizzati. La variabile dipendente invece è definita nel range [85.76, 181.18], per cui ne possiamo valutare il coefficiente di variazione (`sd(y_IQ) / mean(y_IQ)`), che si attesta attorno al 15%.


Queste informazioni possono essere visualizzate in maniera efficace mediante l'utilizzo dei boxplot.

<!-- *whisker plots start appearing* -->
- Comment the data
- indici di tendenza centrale: media, mediana (boh mostra i dati)
- indici di dispersione: varianza (e il cugino), escursione campionaria (range)
- Consider doing fancy shit for labels
- Notiamo che non ci sono outliers?
- Other noticeable thinghies (hanno i baffi)

## 1.2. Istogrammi e Q-Q plot
- Explain how you choose number of thinghies 🪣
- Denote clear noticeable thinghies
- Shits and giggles
- since we don't know if they're "normal" (what does that mean anyway?): Q-Q plots
- 

## 1.3. Scatter Plot
- Grandi quelli con Y
- independent twist
- honorable mentions
- ipotesi su why forme all throughout
- poly regression for all graphs


## 1.4. (covariances too) CORRELATION = CAUSATION SHIT NEEDS BETTER NAME (CONTROVERSIAL)
- cov just cause we know it by name
- correlation (con tabella di interpretazioni)
- comment on correlation (may integrate next entry)
- comment on scatter plot hypotheses though comments on correlation
- may need to have to take a look at second order (gl)

## 1.A. Conclusioni
- prediction on next steps
- I look forward to see the evolution of the honorable mentions from the scatter plots


# 2. Regression
- lm (so fitting)
- residuals
- test di HP 
    - globali
    - individuali


# 2.1. Ricerca di un modello che minimizzi R²


Direttamente sul fit che scegliamo
Determinazione degli intervalli di confidenza sui parametri trovati: al 95% ogni parametro è tra minimo e massimo dell'intervallo


# 

In maniera occhiometrica, il più carino per ogni categoria diagnostica
- Residuals vs Fitted -> fit002 (Runner up: fit0002)
- Q-Q Plots: fit0002 (Runner up: fit0001)
- Scale-Location: fit1 (Runner up: fit01)
- Cook's Distance: fit001 (Runner up: fit1)













7. Conclusioni Finali
the journey matters more than the destination