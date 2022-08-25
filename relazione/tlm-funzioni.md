---
language: it-IT
---

\newpage

# Funzioni Telemetry
Di seguito sono elencate in codice `C` le funzioni del file `telemetry.s`, ad eslcusione di `telemetry`.

## setTotalsRow {.unlisted .unnumbered}
Aggiunge alla fine del testo le statistiche del pilota selezionato contenute nell'array [**pilot_stats**](#variabili-globali). L'ultimo campo dell'array contiene la somma della velocità, che divisa per il numero di **righe valide** darà la velocità media (intera)
```c
void setTotalsRow(char* output, long countLine)
{    
    for (long i = 0; i < STATS_LENGTH - 1; i++) {        
        output += stringCopy(intToString(pilotStats[i]), output);
        *output = ',';
        output++;
    }

    long avgSpeed = sumSpeed / countLine;
    output += stringCopy(intToString(pilotStats[3]), output);

    *output = '\n';
    output++;
    *output = '\0';
}
```

## writeArray {.unlisted .unnumbered}
Scrive sull'output il contenuto dell'array [**row_fields**](#variabili-globali) popolato precedentemente da setPilotStats.
Questa funzione viene chiamata alla fine di ogni riga valida. Ritorna il numero di caratteri scritti.
```c
long writeArray(char* output)
{
    char* string = output;
    for (long i = 0; i < ROW_FIELD_LENGTH; i++) {        
        string += stringCopy(rowFields[i], string);
        *string = ',';
        string++;
    }
    string--;
    *string = '\0';

    return string - output;
}
```

\newpage

## setPilotStats {.unlisted .unnumbered}
Chiama setPilotStat con i relativi parametri a seconda del parametro field [**(countComma)**](#flusso-telemetry), che determina l'azione da eseguire in base al campo che si sta analizzando

```c
void setPilotStats(char* output, unsigned field)
{
    long number = atoi(output);

    if (field < 3) {
        goto spss_end;
    }

    if (field == 3) {
        pilotStats[3] += number;
        setPilotStat(number, 100, 250, 2);
        goto spss_end;
    }

    if (field == 4) {
        setPilotStat(number, 5000, 10000, 0);
        goto spss_end;
    }

    if (field == 5) {
        setPilotStat(number, 90, 110, 1);
        goto spss_end;
    }

spss_end:
}
```


## getPilotId {.unlisted .unnumbered}
Fornisce, dato il nome del pilota, il suo id confrontando la stringa in input con ogni elemento di [**pilots_array**](#variabili-globali) restituendo l'indice dell'array se viene trovato un elemento uguale a quello dato in input metre restituisce -1 nel caso non venga trovato.
```c
long getPilotId(const char* pilotName)
{
    int flag = 0;
    size_t count = 0;
    while (count < PILOTS_NUMBER) {
        flag = stringCompare(*(pilots + count), pilotName, '\0');
        if (!flag) {
            return count;
        }
        count++;
    }

    return -1;
}
```



## setPilotStat {.unlisted .unnumbered}
Setta la statistica individuata da **index** in base ai valori di [soglia](#vincoli-e-scelte-progettuali). Viene scritta la stringa corrispondente sull'array [**rowFields**](#variabili-globali) in posizione **index**, ossia la posizione corretta che il campo deve avere nella riga di output. 
Viene aggiornato anche il corrispondente massimo in [**pilot_stats**](#variabili-globali)
```c
void setPilotStat(long number, long lowVal, long highVal, long index)
{

    if (number > pilotStats[index]) {
        pilotStats[index] = number;
    }

    if (number <= lowVal) {
        rowFields[index] = low;
        goto sps_end;
    }

    if (number > highVal) {
        rowFields[index] = high;
        goto sps_end;
    }

    rowFields[index] = medium;

sps_end:
}
```