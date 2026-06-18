# dReal1
**R, cause as they say, rrrr, r, rrrrrrr, rr, r. And don't forget, keep on rrrrrr!**

## 🪣 List
- Perché controllano la regressione singola su tutto l'universo
Per fare i grafici

- Perché controllano la regressione multipla su tutto l'universo
bro.. tf..? were you smoking or smth? or r we now?

- Come controlliamo l'overfitting?
Lo fa lui, BIC AIC

- Come scegliamo il modello da cui partire per muoverci verso il modello finale
In maniera occhiometrica con la roba diagnostica che in realtà non capiamo (a parte qq)

- Modello che predicta y in base alle tante x, why (ig how is more important but who cares)
huh?










- ![alt text](image.png)
- Potremmo fare una cosa del genere dividendo il modello finale in contributi da parte di singoli regressori
- I want you ↑

<!-- TODO: does this work? -->

### la parte di statistica descrittiva 1

#### done?
- Comment the data
- Other noticeable thinghies (hanno i baffi)
Notato che hanno i baffi, grandi baffi con pezzo ispirato ad iphone x


### la parte di statistica descrittiva 2
- choose whether to use the tables
Le usiamo, ma commentate nel rrrrrrreporrrrrrrt
- capire definizione della statistica test usata nel test di Shapiro
- De-functionize the function

#### done?
- Explain how you choose number of thinghies 🪣
- Denote clear noticeable thinghies
- Shits and giggles
- since we don't know if they're "normal" (what does that mean anyway?): Q-Q plots



geminiiii

A livello di **codice R hai calcolato quasi tutto**, ma a livello di **report scritto (`rrrrrreporrrrrrt.md`) la seconda metà del documento è ancora una bozza** composta da appunti, segnaposto (placeholder) e note personali. 

Ecco cosa manca nel dettaglio per ciascun punto dello schema:

---

### 1. Analisi preliminare dei dati (Statistica descrittiva e correlazione)
* **Nel codice R:** Completo (ci sono summary, deviazioni standard, boxplot, istogrammi, Shapiro-Wilk test, e corrplot).
* **Nel report:** Quasi completo. La sezione **1.4 (Correlazioni)** contiene solo appunti/promemoria da sviluppare (es. `"- cov just cause we know it by name"`, `"- comment on correlation"`, ecc.). Manca il commento reale sulla matrice di correlazione e su come questa guidi la scelta delle variabili per la regressione.

### 2. Valutazione della relazione y vs xs (Scatter plot con polinomiale)
* **Nel codice R & nel report:** Completo. Gli scatter plot con le due curve (lineare blu e quadratica rossa) sono generati e inseriti correttamente.

### 3. Definizione del modello statistico e confronto di diversi modelli
* **Nel codice R:** Completo. Hai definito molti modelli manuali (da `fit0` a `fit0003`) esplorando interazioni e termini quadratici.
* **Nel report:** Incompleto. La sezione **2 (Regression)** contiene solo un elenco di argomenti da trattare (es. `"- lm (so fitting)"`, `"- residuals"`, ecc.). Mancano la scrittura formale delle equazioni dei modelli considerati e la descrizione del percorso logico che ti ha portato a definire proprio quei modelli.

### 4. Stima ai minimi quadrati ed intervalli di confidenza dei parametri
* **Nel codice R:** Calcolato (tramite `summary` e `confint`).
* **Nel report:** Mancante. C'è solo il testo temporaneo: *"Determinazione degli intervalli di confidenza sui parametri trovati: al 95% ogni parametro è tra minimo e massimo dell'intervallo"*. Mancano la tabella dei coefficienti stimati ($\hat{\beta}_j$), i relativi p-value per i test $t$ sui singoli coefficienti e gli intervalli di confidenza numerici per il modello finale scelto (`FLAG`).

### 5. Coefficiente di determinazione ($R^2$) e grafici diagnostici
* **Nel codice R:** Calcolato.
* **Nel report:** Incompleto. Le immagini dei grafici diagnostici (sia dei confronti che del modello `FLAG`) sono inserite, ma manca la discussione testuale. Non vengono quantificati né commentati i coefficienti $R^2$ e $R^2_{\text{adjusted}}$, e non vengono interpretati fisicamente i grafici diagnostici dei residui (omoschedasticità, normalità, e l'analisi dei punti influenti tramite la distanza di Cook).

### 6. Criterio di scelta del modello e regressione Stepwise
* **Nel codice R:** Eseguito. Hai implementato la stepwise bidirezionale con criterio BIC (`k = log(n)`).
* **Nel report:** Mancante. Manca la spiegazione del criterio di selezione (perché usare AIC o BIC? Perché il BIC penalizza di più la complessità?), la descrizione del funzionamento della regressione stepwise e la discussione del modello ottimale selezionato da `step()`.

### 7. Presentazione ed analisi dei risultati (Conclusioni)
* **Nel report:** Mancante. La sezione conclusioni contiene solo una battuta di riempimento (*"the journey matters more than the destination"*). Manca la parte fondamentale: **tradurre i risultati statistici nel contesto del problema reale** (acquisizione immagini da UAV). Ad esempio, spiegare all'operatore quale configurazione (quali valori delle variabili $x$) massimizza o ottimizza la qualità dell'immagine (`y_IQ`) sulla base del modello stimato.