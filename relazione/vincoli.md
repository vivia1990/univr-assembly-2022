---
language: it-IT
---

\newpage

# Vincoli e scelte progettuali
Nello sviluppo dell'applicativo sono stati applicati i seguenti vincoli

- L'esecuzione viene resa **invalida**, ossia viene copiata in output la stringa `Invalid` quando la stringa di input è vuota, il nome del pilota non corrisponde a nessuno dei presenti in [**pilots_array**](#variabili-globali) o non sono state trovate righe valide

- Per **riga valida** si intende una riga il cui 2 campo (`id pilota`) sia uguale a [**pilotId**](#flusso-telemetry)
 
- Ogni valore di ogni campo, ad esclusione del `tempo` viene trattato come un **intero non segnato a 32bit**, i valori negativi **non** sono supportati da questa implementazione

- La stringa di **input** si considera terminata quando si incontra o un carattere `\0` oppure una sequenza di 2 o più caratteri `\n`

- La stringa di **output** contiene **sempre** un carattere `\n` finale, anche in caso di esecuzione invalida

# Funzionamento
Per eseguire il programma è necessario chiamare l'eseguibile `telemetry` nella cartella `bin/`, dopo averlo generato con il comando `make` dalla cartella **root** del progetto. \newline
Al comando vanno passati due parametri

- il primo corrisponde al **path** del file **txt** di input
- il secondo corrisponde al **path** del file di output che sarà generato dall'applicativo

### Esempio {.unlisted .unnumbered}
```sh
asm> make
asm> ./telemetry "path/to/input.txt" "path/to/output.txt
```
Il contenuto sarà in `out.txt`