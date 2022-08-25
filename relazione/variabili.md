---
language: it-IT
---

\newpage

# Variabili globali
Durante lo sviluppo dell'applicativo si è cercato di limitare il più possibile l'uso di variabili globali. Cercando, quando possibile, di usare lo stack e i registri. \newline
Di seguito sono elencate le principali variabili **globali** necessarie.

## Telemetry {.unlisted .unnumbered}
| **Variabile**     | **Descrizione**                                                    |
| ----------------- | ------------------------------------------------------------------ |
| **row_fields[3]**         | Array di valori **long**, inizializzato a `0` nella sezione `.bss`. Conterrà i puntatori alle stringhe  `LOW`, `HIGH`, `MEDIUM`, ordinate nel modo corretto (vedere [setPilotStat](#setpilotstat))|
|                           |
| **pilot_stats[4]**        | Array di valori **long**, inizializzato a `0` nella sezione `.bss`. Conterrà i valori totali e di massimo delle righe relative al pilota, memorizzati in ordine: `rpmMax`, `tempMax`, `speedMax`, `SpeedSum` (vedere [setTotalsRow](#settotalsrow))|
|                           |
| **row_fields_size**       | Variabile statica di tipo long, contenente la lunghezza di `row_fields`|
|                           |
| **pilot_stats_size**      | Variabile statica di tipo long, contenente la lunghezza di `pilot_stats`|
|                           |
| **pilots_array**          | Array di valori **long**, contenente i puntatori alle stringhe dei piloti, individuati dalla posizione nell'array|
|                           |
| **pilots_size**           | Dimensione array `pilots_array` calcolata dall'assemblatore |
