---
language: it-IT
---

\newpage

# Funzioni e parametri
Di seguito la lista delle funzioni utilizzate dal programma. \newline
I parametri vengono passati alle funzioni caricandoli sullo **stack**, di modo da avere per ultimo valore il primo parametro della funzione, e così via. I valori di ritorno, invece, vengono caricati  nel registro **eax**

| **Definizione**  | **Descrizione** |
| ------------- | ------------- |
| `int stringCompare(`{.c}       | Compara due stringhe, se sono uguali
| \quad `char *string1,   `{.c}     | ritorna `0`, se la prima è maggiore
| \quad `char *string2     `{.c}    |  ritorna un valore **maggiore** di `0` 
| ` );`{.c}                       |  altrimenti **minore** \[`utility.s`\]
|                   |
| `int charLen(char* string);`{.c}  | Restituisce la lunghezza della stringa fino al carattere `\n` o `\0`  \[`utility.s`\]|
|                   |
| `long strToNum(char* number);`{.c}  | Converte una stringa di caratteri in numero \[`utility.s`\] |
|                   |
| `int stringCopy(`{.c}         | Copia una stringa da indirizzo di partenza 
| \quad `char* input,`{.c}      | a una destinazione e restituisce la 
| \quad `char* output`{.c}      | lunghezza della stringa copiata \[`utility.s`\]
| ` );`{.c}  |   
|                   |
| `char* intToString(unsigned long numeric);`{.c}  | Converte un numero unsigned long in stringa \[`utility.s`\] |
|                   |
| [`void telemetry(inputString, outputString);`{.c}](#flusso-telemetry)  | Funzione principale \[`telemetry.s`\] |
|                   |
| [`int getPilotId(char *pilotName);`{.c}](#getpilotid)  | Restituisce id del pilota dall'array dei piloti \[`telemetry.s`\] |
|                   |
| [`int setPilotStats(`{.c}](#setpilotstats)      | Setta la statistica relative al pilota da 
| \quad `char *output,`{.c}     | aggiornare a seconda del parametro field
| \quad `unsigned field`{.c}    | \[`telemetry.s`\]
| )                 | 
|                   |
| [`void setPilotStat(`{.c}](#setpilotstat)  | Setta la statistica relativa al pilota con i vari 
| \quad `long number,`{.c}  | confronti per **rowFields** e **pilot_stats** 
| \quad `long lowVal,`{.c}  | \[`telemetry.s`\]
| \quad `long highVal,`{.c} |
| \quad `long index`{.c}    |
| `);`{.c}  
|                   |
| [`long writeArray(char *output);`{.c}](#writearray)  | Scrive i valori di **row_fields** e ritorna il numero di caratteri scritti  \[`telemetry.s`\] |
|                   |
| [`void setTotalsRow(`{.c}](#settotalsrow)  | Scrive i valori di **pilot_stats** nell'ultima riga 
| \quad `char* output,`{.c} | di output \[`telemetry.s`\]
| \quad `unsigned long countLine`{.c} |
| `);`{.c}  |
